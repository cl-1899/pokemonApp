//
//  CoreDataManager.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 23.09.23.
//

import Foundation
import CoreData

class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func savePokemonData(_ pokemonList: [Pokemon]) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PokemonEntityData> = PokemonEntityData.fetchRequest()
        do {
            let existingPokemonEntities = try context.fetch(fetchRequest)
            for entity in existingPokemonEntities {
                context.delete(entity)
            }
        } catch {
            print("Error removing data from CoreData: \(error)")
        }
        
        for pokemon in pokemonList {
            let pokemonEntityData = PokemonEntityData(context: context)
            pokemonEntityData.name = pokemon.name
            pokemonEntityData.url = pokemon.url
            pokemonEntityData.id = pokemon.id
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving data in CoreData: \(error)")
        }
    }
    
    func fetchPokemonData() -> [Pokemon]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PokemonEntityData> = PokemonEntityData.fetchRequest()
        
        do {
            let pokemonEntities = try context.fetch(fetchRequest)
            let pokemonList = pokemonEntities.map { entity in
                return Pokemon(name: entity.name ?? "", url: entity.url ?? "", id: entity.id)
            }
            if !pokemonList.isEmpty {
                return pokemonList
            } else {
                return nil
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
            return nil
        }
    }
    
    func savePokemonDetails(_ pokemonDetails: PokemonDetails, id: Int16) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PokemonDetailsEntityData> = PokemonDetailsEntityData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let existingDetailsEntity = try context.fetch(fetchRequest).first {
                existingDetailsEntity.name = pokemonDetails.name
                existingDetailsEntity.imageData = pokemonDetails.imageData
                existingDetailsEntity.types = pokemonDetails.types
                existingDetailsEntity.weight = pokemonDetails.weight
                existingDetailsEntity.height = pokemonDetails.height
            } else {
                let pokemonDetailsEntity = PokemonDetailsEntityData(context: context)
                pokemonDetailsEntity.id = id
                pokemonDetailsEntity.name = pokemonDetails.name
                pokemonDetailsEntity.imageData = pokemonDetails.imageData
                pokemonDetailsEntity.types = pokemonDetails.types
                pokemonDetailsEntity.weight = pokemonDetails.weight
                pokemonDetailsEntity.height = pokemonDetails.height
            }
            
            try context.save()
        } catch {
            print("Error saving data in CoreData: \(error)")
        }
    }

    func fetchPokemonDetails(for id: Int16) -> PokemonDetails? {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PokemonDetailsEntityData> = PokemonDetailsEntityData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let detailsEntity = try context.fetch(fetchRequest).first {
                let details = PokemonDetails(
                    id: detailsEntity.id,
                    name: detailsEntity.name ?? "",
                    imageData: detailsEntity.imageData,
                    types: detailsEntity.types ?? "",
                    weight: detailsEntity.weight ?? "",
                    height: detailsEntity.height ?? ""
                )
                return details
            } else {
                print("No data yet")
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
        
        return nil
    }

}
