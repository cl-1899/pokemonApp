//
//  PokemonModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import Foundation

protocol PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol! { get set }
    func fetchPokemonDetails(with id: Int16)
}

protocol PokemonModuleInteractorOutputProtocol {
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails)
    func onError()
}

class PokemonModuleInteractor: PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol!
    
    private let pokemonsURL = ApiManager.pokemonsURL
    private let coreDataManager = CoreDataManager()
    
    func fetchPokemonDetails(with id: Int16) {
        if let cachedDetails = coreDataManager.fetchPokemonDetails(for: id) {
            self.presenter.didFetchPokemonDetails(cachedDetails)
        } else {
            let apiURL = "\(pokemonsURL)/\(id)/"
            guard let url = URL(string: apiURL) else {
                presenter.onError()
                return
            }
            ApiClient.fetchData(with: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.handleSuccessResponse(data: data, id: id)
                case .failure(_):
                    self?.presenter.onError()
                }
            }
        }
    }
    
    private func handleSuccessResponse(data: Data, id: Int16) {
        do {
            let response = try JSONDecoder().decode(PokemonDetailsResponse.self, from: data)
            
            let imageURL = response.sprites.url
            guard let url = URL(string: imageURL),
                  let imageData = try? Data(contentsOf: url)
            else {
                self.presenter.onError()
                return
            }
            
            var formattedTypes = ""
            for type in response.types {
                formattedTypes += type.pokemonType.name + ", "
            }
            formattedTypes = String(formattedTypes.dropLast(2))
            
            let weightText = String(format: "Weight: %.1f kg", response.weight)
            let heightText = String(format: "Height: %.1f cm", response.height)
            
            let pokemonDetaials = PokemonDetails(
                id: id,
                name: response.name,
                imageData: imageData,
                types: formattedTypes,
                weight: weightText,
                height: heightText)
            self.presenter.didFetchPokemonDetails(pokemonDetaials)
            
            coreDataManager.savePokemonDetails(pokemonDetaials, id: id)
        } catch {
            self.presenter.onError()
        }
    }
}
