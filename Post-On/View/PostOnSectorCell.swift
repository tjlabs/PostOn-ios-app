
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then

class PostOnSectorCell: UICollectionViewCell {
    static let reuseIdentifier = "PostOnSectorCell"
    
    private let sectorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lemonRegular(size: 18)
        label.textColor = UIColor(hex: "#333333")
        label.textAlignment = .left
        return label
    }()
    
    // MARK: Distance
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lemonadaBold(size: 12)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: Distance
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "#666666")
        label.textAlignment = .left
        return label
    }()
    
    // MARK: Address
    private let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_place")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(hex: "#666666")
        label.textAlignment = .left
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EEEEEE")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(sectorImageView)
        sectorImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(14)
            make.width.lessThanOrEqualTo(80)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(sectorImageView.snp.trailing).offset(30)
            make.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        containerStackView.addArrangedSubview(messageLabel)
        containerStackView.addArrangedSubview(distanceLabel)
        addressStackView.addArrangedSubview(addressImageView)
        addressImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        addressStackView.addArrangedSubview(addressLabel)
        containerStackView.addArrangedSubview(addressStackView)
        // Separator
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: SectorCellItem) {
        let placeholderImage = UIImage(named: "ic_placeholder")
        sectorImageView.image = placeholderImage
        
        titleLabel.text = data.title
        let messageColor = data.available ? UIColor(hex: "#46B1E1") : UIColor(hex: "#AF3228")
        messageLabel.text = data.message
        messageLabel.textColor = messageColor
        distanceLabel.text = "\(data.distance)m 떨어짐"
        addressLabel.text = data.address
    }
}
