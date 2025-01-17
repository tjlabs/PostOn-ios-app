
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then

class ProfileImageCell: UICollectionViewCell {
    
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_profile_empty")
    }
    
    let selectImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_checkCircle_green")
        $0.isHidden = true
    }
    
    public var isSelectedState = false
    var selectImageSize: Int = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectImageSize = Int(frame.width/3)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let selectImageWidth = self.selectImageSize
        addSubview(selectImageView)
        selectImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(selectImageWidth)
            make.bottom.trailing.equalToSuperview().inset(2)
        }
    }
    
    func configure(imageName: String) {
        if imageName != "" {
            if let image = UIImage(named: imageName) {
                mainImageView.image = image
            }
        }
    }
    
}
