import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

enum PostOnViewState {
    case expanded, closed, normal
}

import RxRelay

class PostOnView: UIView {
    private let disposeBag = DisposeBag()
    
    let screenHeight = UIScreen.main.bounds.height
    let expandedHeight: CGFloat
    let normalHeight: CGFloat
    let closedHeight: CGFloat = 100
    
    private var lastPanTranslation: CGFloat = 0

    private let stateRelay = BehaviorRelay<PostOnViewState>(value: .normal)
    var currentState: Observable<PostOnViewState> { stateRelay.asObservable() }
    
    let dragIndicatorSize = CGSize(width: UIScreen.main.bounds.width * 0.2, height: 5.0)
    
    private var dragIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .darkGray
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        self.expandedHeight = 0.8 * (screenHeight - 110)
        self.normalHeight = max(0.4 * (screenHeight - 110), 210)
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubview(dragIndicatorView)
        dragIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.size.equalTo(dragIndicatorSize)
        }
    }
    
    private func bindActions() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let velocity = panGestureRecognizer.velocity(in: self).y
        let translation = panGestureRecognizer.translation(in: self).y
        
        let newHeight = max(closedHeight, min(expandedHeight, self.frame.height - (translation - lastPanTranslation)))
        
        switch panGestureRecognizer.state {
        case .changed:
            if abs(translation - lastPanTranslation) > 2 {
                controlViewHeight(height: newHeight)
                lastPanTranslation = translation
            }
        case .ended, .cancelled:
            lastPanTranslation = 0
            if abs(velocity) > 700 {
                setState(velocity < 0 ? .expanded : .closed)
            } else {
                snapToNearestHeight(newHeight)
            }
        default:
            break
        }
    }
    
    private func snapToNearestHeight(_ currentHeight: CGFloat) {
        let distances: [(state: PostOnViewState, height: CGFloat)] = [
            (.expanded, expandedHeight),
            (.normal, normalHeight),
            (.closed, closedHeight)
        ]
        
        if let closest = distances.min(by: { abs($0.height - currentHeight) < abs($1.height - currentHeight) }) {
            setState(closest.state)
        }
    }

    func setState(_ state: PostOnViewState) {
        stateRelay.accept(state)
        
        let targetHeight: CGFloat
        switch state {
        case .expanded:
            targetHeight = expandedHeight
        case .normal:
            targetHeight = normalHeight
        case .closed:
            targetHeight = closedHeight
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.controlViewHeight(height: targetHeight)
                self.layoutIfNeeded()
            })
        }
    }
    
    private func controlViewHeight(height: CGFloat) {
        self.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}
