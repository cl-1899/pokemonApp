//
//  PokemonModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import Foundation

protocol PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol! { get set }
    func fetchPokemonDetails(with id: Int)
}

protocol PokemonModuleInteractorOutputProtocol {
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails)
    func onError()
}

class PokemonModuleInteractor: PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol!
    
    private let pokemonsURL = ApiManager.pokemonsURL
    
    func fetchPokemonDetails(with id: Int) {
        let apiURL = "\(pokemonsURL)/\(id)/"
        guard let url = URL(string: apiURL) else {
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
            let response = try JSONDecoder().decode(PokemonDetailsResponse.self, from: data)
            let pokemonDetaials = PokemonDetails(
                name: response.name,
                imageURL: response.sprites.url,
                types: response.types.map { $0.pokemonType.name },
                weight: response.weight,
                height: response.height)
            self.presenter.didFetchPokemonDetails(pokemonDetaials)
        } catch {
            self.presenter.onError()
        }
    }
}
