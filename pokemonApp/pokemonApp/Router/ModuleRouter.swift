//
//  ModuleRouter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import UIKit

protocol ModuleRouterInputProtocol {
    func navigateToPokemonDetails(withID id: Int, from view: ModulePresenterOutputProtocol?)
}

class ModuleRouter: ModuleRouterInputProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func createModule() -> UINavigationController {
        
        let viewController = ModuleViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let presenter: ModulePresenterInputProtocol & ModuleInteractorOutputProtocol = ModulePresenter()
        
        viewController.presenter = presenter
        viewController.presenter.router = ModuleRouter(viewController: viewController)
        viewController.presenter.view = viewController
        viewController.presenter.interactor = ModuleInteractor()
        viewController.presenter.interactor.presenter = presenter
        
        return navigationController
    }
    
    func navigateToPokemonDetails(withID id: Int, from view: ModulePresenterOutputProtocol?) {
        let pokemonModuleViewController = PokemonModuleViewController()
        let presenter = PokemonModulePresenter(pokemonId: id)
        presenter.view = pokemonModuleViewController
        presenter.interactor = PokemonModuleInteractor()
        presenter.interactor.presenter = presenter
        pokemonModuleViewController.presenter = presenter
        
        self.viewController?.navigationController?.pushViewController(pokemonModuleViewController, animated: true)
    }
}
