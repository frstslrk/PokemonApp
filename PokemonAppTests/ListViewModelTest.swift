import XCTest
@testable import PokemonApp

final class ListViewModelTest: XCTestCase {
    let coordinator = Coordinator(navigationController: UINavigationController())

    func testInit() throws {
        let pokemons = [Pokemon(name: "Pok1"), Pokemon(name: "Pok2"), Pokemon(name: "Pok3")]
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let pokemonList = PokemonList(results: pokemons)
        let CDManager = MockCoreData(pokemons: pokemons, pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonsListNetworkManager(result: .success(pokemonList))

        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: CDManager,
            coordinator: coordinator
        )

        XCTAssertEqual(pokemons.count, viewModel.getPokemonsCount())
    }
    
    func testFetchList() throws {
        let pokemons = [Pokemon(name: "Pok1"),Pokemon(name: "Pok2"),Pokemon(name: "Pok3")]
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let pokemonList = PokemonList(results: pokemons)
        let CDManager = MockCoreData(pokemons: pokemons, pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonsListNetworkManager(result: .success(pokemonList))

        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: CDManager,
            coordinator: coordinator
        )

        viewModel.fetchList()
        XCTAssert(pokemons.count * 2 == viewModel.getPokemonsCount())
    }
    
    func testGetPokemon() throws {
        let pokemons = [Pokemon(name: "Pok1")]
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let pokemonList = PokemonList(results: pokemons)
        let CDManager = MockCoreData(pokemons: pokemons, pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonsListNetworkManager(result: .success(pokemonList))

        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: CDManager,
            coordinator: coordinator
        )

        XCTAssertEqual(viewModel.getPokemon(0)?.name, pokemons[0].name)
    }
    
    func testPulledDown() throws {
        let pokemons = [Pokemon(name: "Pok1")]
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types:[], height: 42, weight: 42, image: UIImage())
        let pokemonList = PokemonList(results: pokemons)
        let CDManager = MockCoreData(pokemons: pokemons, pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonsListNetworkManager(result: .success(pokemonList))

        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: CDManager,
            coordinator: coordinator
        )

        viewModel.pulledDown()
        XCTAssertEqual(pokemons.count * 2, viewModel.getPokemonsCount())
    }
    
    func testPullFromCoreData() throws {
        let pokemons = [Pokemon(name: "Pok1")]
        let pokemonInfo = PokemonInfoExtended(name: "Pok" , types: [], height: 42, weight: 42, image: UIImage())
        let CDManager = MockCoreData(pokemons: pokemons, pokemonInfoExtended: pokemonInfo)
        let networkManager = MockNetworkBuilder.makePokemonsListNetworkManager(result: .noNetwork)

        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: CDManager,
            coordinator: coordinator
        )

        XCTAssertEqual(pokemons.count, viewModel.getPokemonsCount())
    }
}
