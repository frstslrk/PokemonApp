import CoreData
import Foundation

protocol PokemonListViewModelDelegate : AnyObject {
    func refreshData()
    func showTable()
    func showAlert(_ title: String, _ message: String?)
    func footerIsVisible(_ value: Bool)
}

final class PokemonListViewModel: ListViewProtocol {
    private var isLoading = false
    private var networkManager: NetworkManager
    private var coordinator: Coordinator
    weak var delegate: PokemonListViewModelDelegate?
    private var pages = 0
    private var pokemons = [Pokemon]() {
        didSet {
            if oldValue.count == 0 {
                self.delegate?.showTable()
            }
            self.delegate?.refreshData()
        }
    }

    init(
        networkManager: NetworkManager,
        coordinator: Coordinator
    ) {
        self.networkManager = networkManager
        self.coordinator = coordinator
        fetchList()
    }
    
    func fetchList() {
        guard !isLoading else { return }
        self.isLoading = true
        
        fetchPokemonsList { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            self.delegate?.footerIsVisible(false)
            
            switch result {
            case let .success(list):
                self.pokemons.append(contentsOf: list.results)
                self.pages += 1
            case let .failure(error):
                self.delegate?.showAlert(error.errorDescription ?? "Error", nil)
            }
        }
    }

    func getPokemonsCount() -> Int {
        pokemons.count
    }
    
    func getPokemon(_ index: Int) -> Pokemon? {
        pokemons[safe: index]
    }
    
    func pulledDown() {
        self.fetchList()
    }
}

private extension PokemonListViewModel {
    func fetchPokemonsList(completion: @escaping GenericDataCompletion<PokemonList>) {
        networkManager.request(
            PokemonApiController.getPokemons(page: pages),
            completionQueue: .main,
            completion: completion
        )
    }
}
