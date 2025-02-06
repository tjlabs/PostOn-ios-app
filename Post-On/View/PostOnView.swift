import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class PostOnView: UIView {
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
    }
    
    private func bindActions() {
    }
}
