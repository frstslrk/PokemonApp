import Foundation
import PokemonApp

class MockPokemonInfoNetworkManager: Requestable {
    enum PokemonInfoParseResult {
        case success(PokemonInfoExtended)
        case noNetwork
        case invalidData
        case cache(PokemonInfo?)
    }

    var result: PokemonInfoParseResult

    init(result: PokemonInfoParseResult) {
        self.result = result
    }

    func request<T>(
        _ controller: ApiController,
        completionQueue: DispatchQueue?,
        completion: @escaping (Result<T, PokemonApp.NetworkError>) -> Void
    ) where T : Codable {
        switch self.result {
        case .invalidData:
            completion(.failure(.noDataReceived))
        case .noNetwork:
            completion(.failure(.noConnection))
        case .success(let pokemon):
            guard let unwrappedPokemon = pokemon as? T else {
                completion(.failure(.parseError))
                return
            }

            completion(.success(unwrappedPokemon))
        case .cache(let info):
            guard let unwrappedInfo = info as? T else {
                completion(.failure(.parseError))
                return
            }

            completion(.success(unwrappedInfo))
        }
    }
}
