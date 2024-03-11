import UIKit

class Coordinator{
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(){
        let viewModel = PokemonListViewModel(coordinator: self)
        navigationController.pushViewController(PokemonListViewController(viewModel: viewModel), animated: true)
    }
}
