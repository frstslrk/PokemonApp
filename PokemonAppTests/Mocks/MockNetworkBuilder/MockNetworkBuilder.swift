import Foundation
import PokemonApp

public class MockNetworkBuilder {
    static func makePokemonsListNetworkManager(
        result: MockPokemonsListNetworkManager.PokemonListParseResult
    ) -> MockPokemonsListNetworkManager {
        MockPokemonsListNetworkManager(result: result)
    }

    static func makePokemonInfoNetworkManager(
        result: MockPokemonInfoNetworkManager.PokemonInfoParseResult
    ) -> MockPokemonInfoNetworkManager {
        MockPokemonInfoNetworkManager(result: result)
    }
}
