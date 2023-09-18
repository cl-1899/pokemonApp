//
//  ModulePresenter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

protocol ModulePresenterInputProtocol {
    func viewDidLoad()
    func loadNextPage()
    func didSelectPokemon(withID id: Int)
}

protocol ModulePresenterOutputProtocol: AnyObject {
    func displayPokemonList(_ pokemonList: [Pokemon])
    func showError()
}

class ModulePresenter: ModulePresenterInputProtocol, ModuleInteractorOutputProtocol {
    weak var view: ModulePresenterOutputProtocol?
    var interactor: ModuleInteractorInputProtocol!
    var router: ModuleRouterInputProtocol!
    
    private var pokemonList: [Pokemon] = []
    
    
    func viewDidLoad() {
        interactor.fetchPokemonList()
    }
    
    func loadNextPage() {
        interactor.fetchPokemonList()
    }
    
    func didSelectPokemon(withID id: Int) {
        router.navigateToPokemonDetails(withID: id)
    }
    
    func didFetchPokemonList(_ pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        view?.displayPokemonList(pokemonList)
    }
    
    func onError() {
        view?.showError()
    }
}
