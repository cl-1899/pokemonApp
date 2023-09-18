//
//  PokemonModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import Foundation

protocol PokemonModuleInteractorInputProtocol {
    func fetchPokemonDetails(with id: Int)
}

protocol PokemonModuleInteractorOutputProtocol {
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails)
    func onError()
}

class PokemonModuleInteractor: PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol!
    
    func fetchPokemonDetails(with id: Int) {
        let apiURL = "\(pokemonsURL)/\(id)/"
        guard let url = URL(string: apiURL) else {
            presenter.onError()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data, error == nil else {
                self?.presenter.onError()
                return
            }
            
            do {
                let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                self?.presenter.didFetchPokemonDetails(pokemonDetails)
            } catch {
                self?.presenter.onError()
            }
        }.resume()
    }
}
