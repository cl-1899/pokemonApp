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
    func fetchPokemonList()
}

protocol ModuleInteractorOutputProtocol {
    func didFetchPokemonList(_ pokemonList: [Pokemon])
    func onError(_ alertType: AlertType)
}

class ModuleInteractor: ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol!
    
    private var pokemonList: [Pokemon] = []
    private var nextURL: URL?
    private let coreDataManager = CoreDataManager.shared
    private let reachability = try! Reachability()
    private let pokemonsURL = ApiManager.pokemonsURL
    
    func fetchPokemonList() {
        if let cachedData = coreDataManager.fetchPokemonData() {
            self.pokemonList = cachedData
            self.presenter.didFetchPokemonList(pokemonList)
        } else {
            self.fetch()
        }
    }
    
    private func fetch() {
        guard reachability.connection != .unavailable else {
            presenter.onError(.noNetwork)
            return
        }
        
        guard let url = nextURL ?? URL(string: pokemonsURL) else {
            presenter.onError(.loadDataError)
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
            }
            
            let newPokemonList = response.results.map { result in
                let id = self.calculateIDFromURL(url: result.url)
                return Pokemon(name: result.name, url: result.url, id: id)
            }
            
            self.pokemonList.append(contentsOf: newPokemonList)
            self.presenter.didFetchPokemonList(self.pokemonList)
            
            self.coreDataManager.savePokemonData(newPokemonList)
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
