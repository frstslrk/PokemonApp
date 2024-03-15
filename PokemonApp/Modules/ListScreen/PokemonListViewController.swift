import UIKit
import SnapKit

protocol ListViewProtocol {
    var delegate: PokemonListViewModelDelegate? { get set }
    func pulledDown()
    func getPokemonsCount() -> Int
    func getPokemon(_ index: Int) -> Pokemon?
}

final class PokemonListViewController: UIViewController, PokemonListViewModelDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.isHidden = true
        let spinner = UIActivityIndicatorView(style: .medium)
        footerView.addSubview(spinner)

        spinner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return footerView
    }()
    
    private lazy var loader: UIView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.isHidden = false
        return spinner
    }()

    private var viewModel: ListViewProtocol

    init(viewModel: ListViewProtocol) {
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
        view.addSubview(loader)
        view.addSubview(tableView)
        view.addSubview(footerView)

        loader.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.contentInset.bottom = footerView.frame.height + 10
        footerView.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func showTable() {
        loader.isHidden = true
        tableView.isHidden = false
    }

    func refreshData() {
        tableView.reloadData()
    }
    
    func footerIsVisible(_ value: Bool) {
        footerView.isHidden = !value
        footerView.subviews.forEach({
            !value
            ? ($0 as? UIActivityIndicatorView)?.stopAnimating()
            : ($0 as? UIActivityIndicatorView)?.startAnimating()
        })
    }

    func showAlert(_ title: String, _ message: String?) {
        self.showAlert(title: title, message: message)
    }
}

extension PokemonListViewController: UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPokemonsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let pokemon = viewModel.getPokemon(indexPath.row) {
            guard let cell =
                    tableView.dequeueReusableCell(
                        withIdentifier: CustomTableViewCell.identifier,
                        for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: pokemon.name)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //ShowPokemon
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            footerIsVisible(true)
            viewModel.pulledDown()
        }
    }
}

