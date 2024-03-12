import UIKit
import SnapKit

protocol PokemonListViewProtocol {
    var delegate: PokemonListViewModelDelegate? { get set }
    
    func pulledDown()
    func getPokemonsCount() -> Int
    func getPokemon(_ index: Int) -> Pokemon?
}

final class PokemonListViewController: UIViewController, PokemonListViewModelDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var viewModel: PokemonListViewProtocol

    init(viewModel: PokemonListViewProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }

    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func refreshData() {
        tableView.reloadData()
    }
}

extension PokemonListViewController: UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPokemonsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let pokemon = viewModel.getPokemon(indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
            cell.textLabel?.text = pokemon.name
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            viewModel.pulledDown()
        }
    }
}

