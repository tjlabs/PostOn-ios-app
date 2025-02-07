
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then

class PostOnSectorCell: UICollectionViewCell {
    static let reuseIdentifier = "PostOnSectorCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
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
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
//        addSubview(cellView)
//        cellView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//        }
        
        addSubview(sectorImageView)
        sectorImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.lessThanOrEqualTo(120)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(sectorImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        // Separator
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func configure(data: SectorCellItem) {
        let placeholderImage = UIImage(named: "ic_placeholder")
        sectorImageView.image = placeholderImage
        
        titleLabel.text = data.title
    }
}
