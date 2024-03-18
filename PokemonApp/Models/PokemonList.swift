import Foundation

public struct PokemonList: Codable{
    var next: URL?
    var previous: URL?
    var results: [Pokemon]
}
