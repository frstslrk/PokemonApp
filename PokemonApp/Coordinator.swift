import UIKit
import CoreData

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }

    func start()
    func showPokemonDetails(pokemon: Pokemon)
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    private let networkManager = PokemonNetworkManager()
    private let coreDataManager = PokemonCoreDataManager()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PokemonListViewModel(
            networkManager: networkManager,
            coreDataManager: coreDataManager,
            coordinator: self)
        let controller = PokemonListViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showPokemonDetails(pokemon: Pokemon){
        let viewModel = PokemonInfoViewModel(
            pokemon: pokemon,
            coreDataManager: coreDataManager,
            networkManager: networkManager, 
            coordinator: self)
        let controller = PokemonInfoViewController(viewModel: viewModel)
        self.navigationController.pushViewController(controller, animated: true)
    }
}
