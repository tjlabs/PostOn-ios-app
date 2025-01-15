
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class InitialView: UIView {

    let profileView = ProfileView()
    private let bottomWavesImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "img_bottom_waves")
    }
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(bottomWavesImageView)
        bottomWavesImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.height.equalTo(130)
        }
        
        addSubview(profileView)
        profileView.snp.makeConstraints{ make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomWavesImageView.snp.top)
        }
    }
    
    private func bindActions() {
        
    }
}

