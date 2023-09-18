//
//  PokemonModuleRouter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import UIKit

protocol PokemonModuleRouterInputProtocol {
    func navigateBack()
}

class PokemonModuleRouter: PokemonModuleRouterInputProtocol {
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
