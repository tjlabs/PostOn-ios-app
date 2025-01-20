
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class InitialView: UIView {
    private let disposeBag = DisposeBag()
    
    let profileView = ProfileView(imageName: "img_bottom_waves")
    var onDicisionButtonTapped: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(profileView)
        profileView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func bindActions() {
        profileView.dicisionButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.onDicisionButtonTapped?()
            }).disposed(by: disposeBag)
    }
}

