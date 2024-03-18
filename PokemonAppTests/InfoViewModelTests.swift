import XCTest
@testable import PokemonApp

final class InfoViewModelTests: XCTestCase {
    let coordinator = Coordinator(navigationController: UINavigationController())

    func testSuccessExample() throws {
        let pokemon = Pokemon(name: "Pok")
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let CDManager = MockCoreData(pokemons: [], pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonInfoNetworkManager(result: .success(pokemonInfo))

        let viewModel = PokemonInfoViewModel(
            pokemon: pokemon,
            coreDataManager: CDManager,
            networkManager: networkManager,
            coordinator: coordinator
        )

        viewModel.fetchPokemon(pokemon)
        XCTAssert(viewModel.pokemonInfo?.name == pokemon.name)
    }
    
    func testCache() throws {
        let pokemon = Pokemon(name: "Pok")
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let CDManager = MockCoreData(pokemons: [], pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonInfoNetworkManager(result: .noNetwork)

        let viewModel = PokemonInfoViewModel(
            pokemon: pokemon,
            coreDataManager: CDManager,
            networkManager: networkManager,
            coordinator: coordinator
        )

        viewModel.fetchPokemon(pokemon)
        XCTAssertEqual(viewModel.pokemonInfo?.name, pokemonInfo.name)
    }
}
