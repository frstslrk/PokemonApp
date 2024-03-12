import Foundation

protocol PokemonListViewModelDelegate : AnyObject {
    func refreshData()
}

final class PokemonListViewModel: PokemonListViewProtocol {
    
    private var isLoading = false
    private var networkManager: NetworkManager
    private var coordinator: Coordinator
    weak var delegate: PokemonListViewModelDelegate?
    private var pages = 0
    private var pokemons = [Pokemon](){
        didSet {
            DispatchQueue.main.async {
                self.delegate?.refreshData()
            }
        }
    }

    init(networkManager: NetworkManager, coordinator: Coordinator) {
        self.networkManager = networkManager
        self.coordinator = coordinator
        fetchData()
    }
    
    private func fetchData() {
        guard !isLoading else { return }
        
        self.isLoading = true
        networkManager.getPokemons(page: pages) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let success):
                self.pokemons.append(contentsOf: success.results)
                self.pages+=1
            case .failure(let failure):
                // show alert
                break
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
        fetchData()
    }
}
