//
//  ModulePresenter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

protocol ModulePresenterInputProtocol {
    var view: ModulePresenterOutputProtocol? { get set }
    var interactor: ModuleInteractorInputProtocol! { get set }
    var router: ModuleRouterInputProtocol! { get set }
    
    func viewDidLoad()
    func loadNextPage()
    func didSelectPokemon(withID id: Int, from view: ModulePresenterOutputProtocol?)
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
    
    func didSelectPokemon(withID id: Int, from view: ModulePresenterOutputProtocol?) {
        router?.navigateToPokemonDetails(withID: id, from: view)
    }
    
    func didFetchPokemonList(_ pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        self.view?.displayPokemonList(pokemonList)
    }
    
    func onError() {
        self.view?.showError()
    }
}
