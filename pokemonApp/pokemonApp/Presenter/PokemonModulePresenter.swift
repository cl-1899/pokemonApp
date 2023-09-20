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
    var router: PokemonModuleRouterInputProtocol! { get set }
    
    func viewDidLoad()
    func backButtonPressed()
}

protocol PokemonModulePresenterOutputProtocol: AnyObject {
    func displayPokemonDetails(_ pokemonDetails: PokemonDetails)
    func showError()
}

class PokemonModulePresenter: PokemonModulePresenterInputProtocol, PokemonModuleInteractorOutputProtocol {
    weak var view: PokemonModulePresenterOutputProtocol?
    var interactor: PokemonModuleInteractorInputProtocol!
    var router: PokemonModuleRouterInputProtocol!
    
    private var pokemonId: Int?
    
    init(pokemonId: Int) {
        self.pokemonId = pokemonId
    }
    
    func viewDidLoad() {
        guard let pokemonId else {
            self.view?.showError()
            return
        }
        interactor.fetchPokemonDetails(with: pokemonId)
    }
    
    func backButtonPressed() {
        router.navigateBack()
    }
    
    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails) {
        self.view?.displayPokemonDetails(pokemonDetails)
    }
    
    func onError() {
        self.view?.showError()
    }
}
