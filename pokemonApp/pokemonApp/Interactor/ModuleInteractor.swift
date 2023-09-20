//
//  ModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

protocol ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol! { get set }
    
    func fetchPokemonList()
}

protocol ModuleInteractorOutputProtocol {
    func didFetchPokemonList(_ pokemonList: [Pokemon])
    func onError()
}

class ModuleInteractor: ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol!
    
    private var pokemonList: [Pokemon] = []
    private var nextURL: URL?
    
    func fetchPokemonList() {
        DispatchQueue.main.async { [weak self] in
            self?.fetch()
        }
    }
    
    private let pokemonsURL = ApiManager.pokemonsURL
    
    private func fetch() {
        guard let url = nextURL ?? URL(string: pokemonsURL) else {
            presenter.onError()
            return
        }
        ApiClient.fetchData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleSuccessResponse(data: data)
            case .failure(_):
                self?.presenter.onError()
            }
        }
    }
    
    private func handleSuccessResponse(data: Data) {
        do {
            let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            self.nextURL = response.next
            
            let newPokemonList = response.results.map { result in
                return Pokemon(name: result.name, url: result.url)
            }
            
            self.pokemonList.append(contentsOf: newPokemonList)
            self.presenter.didFetchPokemonList(self.pokemonList)
        } catch {
            self.presenter.onError()
        }
    }
}
