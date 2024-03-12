import Foundation

struct PokemonList: Codable{
    var next: URL?
    var previous: URL?
    var results: [Pokemon]
}
