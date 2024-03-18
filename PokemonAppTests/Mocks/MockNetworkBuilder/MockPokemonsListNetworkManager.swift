import PokemonApp
import Foundation

class MockPokemonsListNetworkManager: Requestable {
    enum PokemonListParseResult {
        case success(PokemonList)
        case noNetwork
        case invalidData
    }

    var result: PokemonListParseResult

    init(result: PokemonListParseResult) {
        self.result = result
    }

    func request<T>(
        _ controller: ApiController,
        completionQueue: DispatchQueue?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) where T : Codable {

        switch self.result {
        case .invalidData:
            completion(.failure(.noDataReceived))
        case .noNetwork:
            completion(.failure(.noConnection))
        case .success(let list):
            guard let unwrappedList = list as? T else {
                completion(.failure(.parseError))
                return
            }

            completion(.success(unwrappedList))
        }
    }
}
