
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class PostOnView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    
    static var parentViewController: UIViewController?
    
    let screenHeight = UIScreen.main.bounds.height
    let expandedHeight: CGFloat
    let normalHeight: CGFloat
    let closedHeight: CGFloat = 108
    
    private var lastPanTranslation: CGFloat = 0
    private let stateRelay = BehaviorRelay<PostOnViewState>(value: .normal)
    var currentState: Observable<PostOnViewState> { stateRelay.asObservable() }
    
    let dragIndicatorSize = CGSize(width: UIScreen.main.bounds.width * 0.2, height: 5.0)
    
    // MARK: Collection View Cell
    var sectorCellItemList = [SectorCellItem]()
    
    var dragIndicatorView: UIView = {
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.isPrefetchingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PostOnSectorCell.self, forCellWithReuseIdentifier: PostOnSectorCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_my_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init() {
        self.expandedHeight = 0.8 * (screenHeight - 110)
        self.normalHeight = max(0.4 * (screenHeight - 110), 210)
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        updateSectorCellItemList()
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
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(44)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(containerView.snp.top)
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
    
    func updateSectorCellItemList() {
        let item = SectorCellItem(title: "TipsTown", available: true, message: "입장 가능", distance: 10, address: "Yeoksom-ro")
        let item2 = SectorCellItem(title: "COEX", available: false, message: "입장 불가", distance: 1000, address: "Samsung-ro")
        let item3 = SectorCellItem(title: "Test", available: false, message: "입장 불가", distance: 100000, address: "Unknown-ro")
        self.sectorCellItemList.append(item)
        self.sectorCellItemList.append(item2)
        self.sectorCellItemList.append(contentsOf: Array(repeating: item3, count: 3))
        
        let emptyCell = SectorCellItem(title: "EMPTY", available: false, message: "EMPTY", distance: 0, address: "EMPTY")
        self.sectorCellItemList.append(emptyCell)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
    private func goToPostOnVC(sectorCell: SectorCellItem) {
        guard let parentVC = PostOnView.parentViewController else {
            print("(PostOnView) Error : Parent view controller is nil")
            return
        }

        guard let postOnVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostOnViewController") as? PostOnViewController else {
            print("(PostOnView) Error : Failed to instantiate PostOnViewController")
            return
        }
        parentVC.navigationController?.pushViewController(postOnVC, animated: true)
    }

    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectorCellItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostOnSectorCell.reuseIdentifier, for: indexPath) as! PostOnSectorCell
        let item = self.sectorCellItemList[indexPath.row]
        cell.configure(data: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.sectorCellItemList[indexPath.row]
        if item.available {
            self.goToPostOnVC(sectorCell: item)
        } else {
            // TODO
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 111
        return CGSize(width: width, height: height)
    }
}
