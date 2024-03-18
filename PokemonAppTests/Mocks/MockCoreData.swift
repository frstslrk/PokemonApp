import Foundation
import PokemonApp

class MockCoreData: CoreDataManager {
    var pokemons: [Pokemon]!
    var pokemonInfo: PokemonInfo!
    var pokemonInfoExtended: PokemonInfoExtended!

    init() {}

    convenience init(pokemons: [Pokemon], pokemonInfoExtended: PokemonInfoExtended) {
        self.init()
        self.pokemons = pokemons
        self.pokemonInfoExtended = pokemonInfoExtended
    }

    func getPokemonsFromList() -> [Pokemon] {
        pokemons
    }

    func addPokemon(pokemonInfo: PokemonInfoExtended) {
        self.pokemonInfoExtended = pokemonInfo
    }

    func getPokemon(name: String) -> PokemonInfoExtended? {
        name != pokemonInfoExtended.name ? nil : self.pokemonInfoExtended
    }
}
