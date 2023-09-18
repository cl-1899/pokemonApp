//
//  ModuleRouter.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import UIKit

protocol ModuleRouterInputProtocol {
    func navigateToPokemonDetails(withURL url: URL)
}

class ModuleRouter: ModuleRouterInputProtocol {
    func navigateToPokemonDetails(withURL url: URL) {
        <#code#>
    }
    
    weak var viewController: UIViewController?
}
