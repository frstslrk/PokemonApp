import UIKit

struct PokemonInfo: Codable {
    var name: String
    var types: [PokemonType]
    var height: Int
    var weight: Int
    var sprites: Sprite
}

struct Sprite: Codable {
    var front_default: URL?
}

extension PokemonInfo {
    func getInfoExtended(with image: UIImage = UIImage(), url: URL? = nil) -> PokemonInfoExtended {
        PokemonInfoExtended(
            name: name,
            types: types.map({$0.type.name}),
            height: height,
            weight: weight,
            image: image
        )
    }
}
