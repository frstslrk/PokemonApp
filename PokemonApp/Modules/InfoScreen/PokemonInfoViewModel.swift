import UIKit
import CoreData
import SDWebImage

protocol PokemonInfoViewModelDelegate : AnyObject{
    func configure()
    func showAlert(_ title: String, _ message: String?)
}

final class PokemonInfoViewModel: PokemonInfoViewProtocol {
    private var coordinator: Coordinator
    private var networkManager: NetworkManager
    private var coreDataManager: CoreDataManager
    weak var delegate: PokemonInfoViewModelDelegate?
    var pokemonInfo: PokemonInfoExtended? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.configure()
            }
        }
    }

    init(
        pokemon: Pokemon,
        coreDataManager: CoreDataManager,
        networkManager: NetworkManager,
        coordinator: Coordinator
    ) {
        self.networkManager = networkManager
        self.coordinator = coordinator
        self.coreDataManager = coreDataManager
        fetchPokemon(pokemon)
    }

    private func getCachedPokemon(with name: String) -> PokemonInfoExtended? {
        coreDataManager.getPokemon(name: name)
    }

    func fetchPokemon(_ pokemon: Pokemon) {
        if let cached = self.getCachedPokemon(with: pokemon.name) {
            self.pokemonInfo = cached
            print("DEB:Prop changer")
        } else {
            self.fetchPokemonInfo(pokemon) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let info):
                    self.fetchPokemonImage(info: info)
                case .failure(let error):
                    self.delegate?.showAlert(error.errorDescription ?? "Error", nil)
                }
            }
        }
    }
}

private extension PokemonInfoViewModel {
    func fetchPokemonInfo(_ pokemon: Pokemon, completion: @escaping GenericDataCompletion<PokemonInfo>) {
        networkManager.request(
            PokemonApiController.getPokemonInfo(req: pokemon),
            completionQueue: .main,
            completion: completion
        )
    }

    func fetchPokemonImage(info: PokemonInfo) {
        guard let url = info.sprites.front_default else {
            self.delegate?.showAlert("No image", nil)
            self.pokemonInfo = info.getInfoExtended()
            return
    }

        SDWebImageManager.shared.loadImage(
            with: url,
            options: .refreshCached,
            progress: nil
        ) { [weak self] (image, _, error, _, _, _) in
            guard let self,
                  error == nil,
                  let image = image else {
                self?.delegate?.showAlert("No image", nil)
                self?.pokemonInfo = info.getInfoExtended()
                return
            }

            let extendedInfo = info.getInfoExtended(with: image)
            self.pokemonInfo = extendedInfo
            self.coreDataManager.addPokemon(pokemonInfo: extendedInfo)
        }
    }
}
