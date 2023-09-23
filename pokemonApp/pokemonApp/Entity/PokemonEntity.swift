//
//  PokemonEntity.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
    let id: Int16
}

struct PokemonResponse: Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let results: [PokemonResponse]
    let next: String?
}

struct PokemonDetails: Codable {
    let id: Int16
    let name: String
    let imageData: Data?
    let types: String
    let weight: String
    let height: String
}

struct PokemonDetailsResponse: Codable {
    let name: String
    let sprites: Sprite
    let types: [Types]
    let weight: Double
    let height: Double
}

struct Types: Codable {
    let pokemonType: PokemonType
    
    enum CodingKeys: String, CodingKey {
        case pokemonType = "type"
    }
}

struct PokemonType: Codable {
    let name: String
}

struct Sprite: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
}
