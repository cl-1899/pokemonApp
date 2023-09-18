//
//  ModuleRouter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import UIKit

protocol ModuleRouterInputProtocol {
    func navigateToPokemonDetails(withID id: Int)
}

class ModuleRouter: ModuleRouterInputProtocol {
    weak var viewController: UIViewController?
    
    func navigateToPokemonDetails(withID id: Int) {
        let pokemonModuleViewController = PokemonModuleViewController()
        let presenter = PokemonModulePresenter(pokemonId: id)
        pokemonModuleViewController.presenter = presenter
        presenter.view = pokemonModuleViewController
        
        viewController?.navigationController?.pushViewController(pokemonModuleViewController, animated: true)
    }
}
