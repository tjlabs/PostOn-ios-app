import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

enum PostOnViewState {
    case expanded, closed, normal
}

class PostOnView: UIView {
    private let disposeBag = DisposeBag()
    
    let screenHeight = UIScreen.main.bounds.height
    let expandedHeight: CGFloat
    let normalHeight: CGFloat = 210
    let closedHeight: CGFloat = 50
    
    private var currentState: PostOnViewState = .closed
    private var heightConstraint: Constraint?

    let dragIndicatorSize = CGSize(width: UIScreen.main.bounds.width * 0.2, height: 5.0)
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .darkGray
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowRadius = 4
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        self.expandedHeight = 0.8 * (screenHeight - 110)
        super.init(frame: .zero)
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        dragIndicatorView.isUserInteractionEnabled = true
        dragIndicatorView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Handle Dragging
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let newHeight = max(closedHeight, min(expandedHeight, self.frame.height - translation.y))
        
        switch recognizer.state {
        case .changed:
            heightConstraint?.update(offset: newHeight)
            recognizer.setTranslation(.zero, in: self)
            UIView.animate(withDuration: 0.1) {
                self.layoutIfNeeded()
            }
        case .ended, .cancelled:
            snapToNearestHeight(newHeight)
        default:
            break
        }
    }
    
    // MARK: Snap to Nearest Height
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

    // MARK: Set State with Animation
    func setState(_ state: PostOnViewState) {
        currentState = state
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
            self.heightConstraint?.update(offset: targetHeight)
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}
