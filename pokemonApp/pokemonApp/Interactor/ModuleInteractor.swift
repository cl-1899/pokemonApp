//
//  ModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

protocol ModuleInteractorInputProtocol {
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
    private let pokemonsURL = "https://pokeapi.co/api/v2/pokemon"
    
    func fetchPokemonList() {
        guard let url = nextURL ?? URL(string: pokemonsURL) else {
            presenter.onError()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data, error == nil else {
                self?.presenter.onError()
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                self?.nextURL = response.next
                
                let newPokemonList = response.results.map { result in
                    return Pokemon(name: result.name, url: result.url)
                }
                
                self?.pokemonList.append(contentsOf: newPokemonList)
                self?.presenter.didFetchPokemonList(self?.pokemonList ?? [])
            } catch {
                self?.presenter.onError()
            }
        }.resume()
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonResult]
    let next: URL?
}

struct PokemonResult: Codable {
    let name: String
    let url: URL
}
