//
//  CoreDataManager.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 23.09.23.
//

import Foundation
import CoreData

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func savePokemonListPage(page: Int16, nextUrl: String?, pokemonList: [Pokemon]) {
        let context = persistentContainer.viewContext
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(pokemonList)
            
            let pageEntityData = PokemonListPageEntityData(context: context)
            pageEntityData.page = page
            pageEntityData.nextUrl = nextUrl
            pageEntityData.pokemonList = jsonData
            
            try context.save()
        } catch {
            print("Error saving data in CoreData: \(error)")
        }
    }
    
    func fetchPokemonListPage(page: Int16) -> ([Pokemon], String?)? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PokemonListPageEntityData> = PokemonListPageEntityData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "page == %d", page)
        
        do {
            if let pageEntity = try context.fetch(fetchRequest).first,
               let jsonData = pageEntity.pokemonList {
                let decodedPokemonList = try JSONDecoder().decode([Pokemon].self, from: jsonData)
                return (decodedPokemonList, pageEntity.nextUrl ?? "")
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
            let pokemonDetailsEntity = PokemonDetailsEntityData(context: context)
            pokemonDetailsEntity.id = id
            pokemonDetailsEntity.name = pokemonDetails.name
            pokemonDetailsEntity.imageData = pokemonDetails.imageData
            pokemonDetailsEntity.types = pokemonDetails.types
            pokemonDetailsEntity.weight = pokemonDetails.weight
            pokemonDetailsEntity.height = pokemonDetails.height
            
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
                return nil
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
            return nil
        }
    }
    
    func deleteAllPokemonListPages() {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PokemonListPageEntityData> = PokemonListPageEntityData.fetchRequest()
        
        do {
            let pokemonListPages = try context.fetch(fetchRequest)
            for pageEntity in pokemonListPages {
                context.delete(pageEntity)
            }
            
            try context.save()
        } catch {
            print("Error deleting data from CoreData: \(error)")
        }
    }
    
    func deleteAllPokemonDetails() {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PokemonDetailsEntityData> = PokemonDetailsEntityData.fetchRequest()
        
        do {
            let allDetailsEntities = try context.fetch(fetchRequest)
            for entity in allDetailsEntities {
                context.delete(entity)
            }
            
            try context.save()
        } catch {
            print("Error removing data from CoreData: \(error)")
        }
    }
}
