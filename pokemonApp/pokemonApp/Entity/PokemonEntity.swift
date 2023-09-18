//
//  PokemonEntity.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

struct Pokemon {
    let name: String
    let url: URL
}

struct PokemonDetails {
    let name: String
    let imageURL: URL
    let types: [String]
    let weight: Double
    let height: Double
}
