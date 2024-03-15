import UIKit
import CoreData

final class Coordinator {
    var navigationController: UINavigationController
    var networkManager = NetworkManager()
    var coreDataManager: CoreDataManager
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coreDataManager = CoreDataManager()
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
            networkManager: networkManager, coordinator: self)
        let controller = PokemonInfoViewController(viewModel: viewModel)
        self.navigationController.pushViewController(controller, animated: true)
    }
}
