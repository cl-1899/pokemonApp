//
//  ModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation
import Reachability

protocol ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol! { get set }
    var nextURL: URL? { get set }
    func fetchPokemonList()
}

protocol ModuleInteractorOutputProtocol {
    func didFetchPokemonList(_ pokemonList: [Pokemon])
    func onError(_ alertType: AlertType)
}

class ModuleInteractor: ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol!
    var nextURL: URL?
    
    private var pokemonList: [Pokemon] = []
    private var currentPage: Int16 = 0
    private var nextPage: Int16 = 1
    private let coreDataManager = CoreDataManager.shared
    private let reachability = try! Reachability()
    private let pokemonsURL = ApiManager.pokemonsURL
    private var shouldShowNoNetworkAlert = true
    
    func fetchPokemonList() {
        if let (newPokemonList, nextURL) = coreDataManager.fetchPokemonListPage(page: nextPage) {
            if let nextURL {
                self.nextURL = URL(string: nextURL)
            } else {
                self.nextURL = nil
            }
            
            self.currentPage += 1
            self.nextPage += 1
            
            self.pokemonList.append(contentsOf: newPokemonList)
            self.presenter.didFetchPokemonList(self.pokemonList)
        } else {
            self.fetchFromNetwork()
        }
    }

    private func fetchFromNetwork() {
        guard reachability.connection != .unavailable else {
            if self.shouldShowNoNetworkAlert {
                self.presenter.onError(.noNetwork)
                self.shouldShowNoNetworkAlert = false
            }
            return
        }
        
        guard let url = nextURL ?? URL(string: pokemonsURL) else {
            self.presenter.onError(.loadDataError)
            return
        }
        
        fetchApiClient(with: url)
    }
    
    private func fetchApiClient(with url: URL) {
        ApiClient.fetchData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleSuccessResponse(data: data)
            case .failure(_):
                self?.presenter.onError(.loadDataError)
            }
        }
    }
    
    private func handleSuccessResponse(data: Data) {
        do {
            let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            if let nextURL = response.next {
                self.nextURL = URL(string: nextURL)
            } else {
                self.nextURL = nil
            }
            
            let newPokemonList = response.results.map { result in
                let id = self.calculateIDFromURL(url: result.url)
                return Pokemon(name: "\(id). \(result.name.capitalized)", url: result.url, id: id)
            }
            
            self.currentPage += 1
            self.nextPage += 1
            
            self.pokemonList.append(contentsOf: newPokemonList)
            self.presenter.didFetchPokemonList(self.pokemonList)
            
            self.coreDataManager.savePokemonListPage(page: currentPage, nextUrl: self.nextURL?.absoluteString, pokemonList: newPokemonList)
        } catch {
            self.presenter.onError(.loadDataError)
        }
    }
    
    private func calculateIDFromURL(url: String) -> Int16 {
        let parts = url.components(separatedBy: "/")
        if let idString = parts.dropLast().last,
           let id = Int16(idString) {
            return id
        } else {
            return 0
        }
    }
}
