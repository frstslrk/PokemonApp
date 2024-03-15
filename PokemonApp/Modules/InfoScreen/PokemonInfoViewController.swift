import UIKit
import SnapKit

protocol PokemonInfoViewProtocol {
    var delegate: PokemonInfoViewModelDelegate? { get set }
    var pokemonInfo: PokemonInfoExtended? { get }
}

final class PokemonInfoViewController: UIViewController, PokemonInfoViewModelDelegate {
    private enum Constants {
        static let imageSize: CGFloat = 200
        static let labelsHeight: CGFloat = 50
    }
    
    private lazy var loader: UIView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.isHidden = false
        return spinner
    }()
    
    private let pokemonImage: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage()
       imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var viewModel: PokemonInfoViewProtocol
    
    init(viewModel: PokemonInfoViewProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndConstraints()
    }

    func configure(){
        print("DEB:Configure")

        guard let pokemon = viewModel.pokemonInfo else { return }

        loader.isHidden = true
        nameLabel.text = "Name - \(pokemon.name)"
        typeLabel.text = "Types - \(pokemon.types.joined(separator:" , "))"
        weightLabel.text = "Weight - \(pokemon.weight) kg"
        heightLabel.text = "Height - \(pokemon.height * 100) cm"
        pokemonImage.image = pokemon.image
    }
}

extension PokemonInfoViewController {
    func setupViewsAndConstraints() {
        title = "Decription"
        view.addSubview(nameLabel)
        view.addSubview(typeLabel)
        view.addSubview(pokemonImage)
        view.addSubview(weightLabel)
        view.addSubview(heightLabel)
        view.addSubview(loader)

        loader.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints{make in
            make.leading.width.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        pokemonImage.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.imageSize)
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
        }
 
        typeLabel.snp.makeConstraints{make in
            make.leading.width.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
            make.top.equalTo(pokemonImage.snp.bottom)
        }
        
        heightLabel.snp.makeConstraints{make in
            make.leading.width.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
            make.top.equalTo(typeLabel.snp.bottom)
        }
        
        weightLabel.snp.makeConstraints{make in
            make.leading.width.equalToSuperview()
            make.height.equalTo(Constants.labelsHeight)
            make.top.equalTo(heightLabel.snp.bottom)
        }
    }

    func showAlert(_ title: String, _ message: String?) {
        self.showAlert(title: title, message: message)
    }
}
