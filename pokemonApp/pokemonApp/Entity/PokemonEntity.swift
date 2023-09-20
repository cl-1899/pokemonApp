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
    lazy var id: Int = {
        return extractID(from: self.url)
    }()
    
    private func extractID(from url: String) -> Int {
        let parts = url.components(separatedBy: "/")
        if let idString = parts.dropLast().last, let id = Int(idString) {
            return id
        } else {
            return 0
        }
    }
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]
    let next: URL?
}

struct PokemonDetails: Codable {
    let name: String
    let imageURL: String?
    let types: [String]
    let weight: Double
    let height: Double
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
