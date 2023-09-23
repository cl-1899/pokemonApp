//
//  PokemonModulePresenter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import Foundation

protocol PokemonModulePresenterInputProtocol {
    var view: PokemonModulePresenterOutputProtocol? { get set }
    var interactor: PokemonModuleInteractorInputProtocol! { get set }
    
    func viewDidLoad()
}

protocol PokemonModulePresenterOutputProtocol: AnyObject {
    func displayPokemonDetails(_ pokemonDetails: PokemonDetails)
    func showError(_ alertType: AlertType)
}

class PokemonModulePresenter: PokemonModulePresenterInputProtocol, PokemonModuleInteractorOutputProtocol {
    weak var view: PokemonModulePresenterOutputProtocol?
    var interactor: PokemonModuleInteractorInputProtocol!
    
    private var pokemonId: Int16?
    
    init(pokemonId: Int16) {
        self.pokemonId = pokemonId
    }
    
    func viewDidLoad() {
        guard let pokemonId else {
            self.view?.showError(.loadDataError)
            return
        }
        interactor.fetchPokemonDetails(with: pokemonId)
    }
    
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails) {
        self.view?.displayPokemonDetails(pokemonDetails)
    }
    
    func onError(_ alertType: AlertType) {
        self.view?.showError(alertType)
    }
}
