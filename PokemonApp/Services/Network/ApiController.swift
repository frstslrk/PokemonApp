import Foundation

public protocol ApiController {
    var url: URL? { get }
    var path: String? { get }
    var query: String { get }
    var method: PokemonNetworkManager.HTTPMethod { get }
}

enum PokemonApiController {
    case getPokemons(page: Int)
    case getPokemonInfo(req: Pokemon)
}

extension PokemonApiController: ApiController {
    var url: URL? {
        URL(string: path.unwrapped + query)
    }
    
    var path: String? {
        switch self {
        case .getPokemons:
            return "https://pokeapi.co/api/v2/pokemon?"
        case .getPokemonInfo(let req):
            return req.url?.description
        }
    }
    
    var query: String {
        switch self {
        case .getPokemons(let page):
            return "offset=\(page * 20)&limit=20"
        case .getPokemonInfo:
            return ""
        }
    }
    
    var method: PokemonNetworkManager.HTTPMethod {
        switch self {
        case .getPokemons:
            return .GET
        case .getPokemonInfo:
            return .GET
        }
    }
}
