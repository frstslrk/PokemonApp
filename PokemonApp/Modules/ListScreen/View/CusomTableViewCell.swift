import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18,weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        backgroundColor = .systemBackground
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with title: String){
        label.text = title
    }

}
