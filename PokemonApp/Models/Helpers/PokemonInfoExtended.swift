import UIKit

struct PokemonInfoExtended {
    var name: String
    var types: [String]
    var height: Int
    var weight: Int
    var image: UIImage
}

extension PokemonInfoExtended {
    static var empty: PokemonInfoExtended {
        PokemonInfoExtended(
            name: "",
            types: [],
            height: 0,
            weight: 0,
            image: UIImage()
        )
    }
}
