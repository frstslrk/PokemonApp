import Foundation

struct PokemonType: Codable {
    var type: PokemonTypeData
}

struct PokemonTypeData: Codable {
    var name: String
}
