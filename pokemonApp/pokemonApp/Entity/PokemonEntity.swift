//
//  PokemonEntity.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

let pokemonsURL = "https://pokeapi.co/api/v2/pokemon"

struct Pokemon: Codable {
    let name: String
    let id: Int
    let url: URL
}

struct PokemonDetails: Codable {
    let name: String
    let imageURL: URL
    let types: [String]
    let weight: Double
    let height: Double
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]
    let next: URL?
}
