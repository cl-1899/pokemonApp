//
//  PokemonModuleInteractor.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import Foundation
import Reachability

protocol PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol! { get set }
    func fetchPokemonDetails(with id: Int16)
}

protocol PokemonModuleInteractorOutputProtocol {
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails)
    func onError(_ alertType: AlertType)
}

class PokemonModuleInteractor: PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol!
    
    private let pokemonsURL = ApiManager.pokemonsURL
    private let coreDataManager = CoreDataManager.shared
    private let reachability = try! Reachability()
    
    func fetchPokemonDetails(with id: Int16) {
        if let cachedDetails = coreDataManager.fetchPokemonDetails(for: id) {
            self.presenter.didFetchPokemonDetails(cachedDetails)
        } else {
            self.fetchFromNetwork(for: id)
        }
    }
    
    private func fetchFromNetwork(for id: Int16) {
        guard reachability.connection != .unavailable else {
            self.presenter.onError(.noNetwork)
            return
        }
        
        let apiURL = "\(pokemonsURL)/\(id)/"
        guard let url = URL(string: apiURL) else {
            presenter.onError(.loadDataError)
            return
        }
        
        self.fetchApiClient(with: url, for: id)
    }
    
    private func fetchApiClient(with url: URL, for id: Int16) {
        ApiClient.fetchData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleSuccessResponse(data: data, id: id)
            case .failure(_):
                self?.presenter.onError(.loadDataError)
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
                self.presenter.onError(.loadDataError)
                return
            }
            
            var formattedTypes = ""
            for type in response.types {
                formattedTypes += type.pokemonType.name + ", "
            }
            formattedTypes = String(formattedTypes.dropLast(2))
            
            let weightText = String(format: "%.1f kg", response.weight)
            let heightText = String(format: "%.1f cm", response.height)
            
            let pokemonDetaials = PokemonDetails(
                id: id,
                name: response.name.capitalized,
                imageData: imageData,
                types: formattedTypes.capitalized,
                weight: weightText,
                height: heightText)
            self.presenter.didFetchPokemonDetails(pokemonDetaials)
            
            self.coreDataManager.savePokemonDetails(pokemonDetaials, id: id)
        } catch {
            self.presenter.onError(.loadDataError)
        }
    }
}
