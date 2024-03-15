import Foundation
import CoreData

final class CoreDataManager {
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CDPokemon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}

    
    func getPokemonsFromList() -> [Pokemon] {
        getCachedPokemons().map({
            Pokemon(name: $0.name.unwrapped)
        })
    }
    
    func addPokemon(pokemonInfo: PokemonInfoExtended) {
        let pokemonLocal = CDPokemon(context: context)
        
        pokemonLocal.name = pokemonInfo.name
        pokemonLocal.weight = Int64(pokemonInfo.weight)
        pokemonLocal.height = Int64(pokemonInfo.height)
        pokemonLocal.image = pokemonInfo.image.toPngString()
        pokemonLocal.types = pokemonInfo.types.map({$0}) as NSObject
        
        do {
            try self.context.save()
        } catch {
            self.context.rollback()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getPokemon(name: String) -> PokemonInfoExtended? {
        getCachedPokemons().filter({$0.name == name}).map({
            PokemonInfoExtended(
                name: $0.name.unwrapped,
                types: $0.types as? [String] ?? [],
                height: Int($0.height),
                weight: Int($0.weight),
                image: $0.image.unwrapped.toImage()
            )
        }).first
    }
    
    func getCachedPokemons() -> [CDPokemon]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPokemon")
        if let result = try? self.context.fetch(request) as? [CDPokemon] {
            return result
        } else {
            return [CDPokemon]()
        }
    }
}
