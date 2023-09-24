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
    var isLoadingNextPage: Bool { get set }
    
    func viewDidLoad()
    func loadNextPage()
    func didSelectPokemon(withID id: Int16, from view: ModulePresenterOutputProtocol?)
}

protocol ModulePresenterOutputProtocol: AnyObject {
    func displayPokemonList(_ pokemonList: [Pokemon])
    func showError(_ alertType: AlertType)
}

class ModulePresenter: ModulePresenterInputProtocol, ModuleInteractorOutputProtocol {
    weak var view: ModulePresenterOutputProtocol?
    var interactor: ModuleInteractorInputProtocol!
    var router: ModuleRouterInputProtocol!
    var isLoadingNextPage: Bool = false
    
    private var pokemonList: [Pokemon] = []
    
    func viewDidLoad() {
        self.interactor.fetchPokemonList()
    }
    
    func loadNextPage() {
        self.interactor.fetchPokemonList()
    }
    
    func didSelectPokemon(withID id: Int16, from view: ModulePresenterOutputProtocol?) {
        self.router?.navigateToPokemonDetails(withID: id, from: view)
    }
    
    func didFetchPokemonList(_ pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        self.view?.displayPokemonList(pokemonList)
        self.isLoadingNextPage = false
    }
    
    func onError(_ alertType: AlertType) {
        self.view?.showError(alertType)
        self.isLoadingNextPage = false
    }
}
