
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then


class ProfileImageSelectView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let disposeBag = DisposeBag()
    var cellItemImageNames: [String] = ["ic_profile_empty"]
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "대표 이미지"
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.lemonadaSemiBold(size: 20)
        return label
    }()
    
    private let profileContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_profile_empty")
    }
    
    var dicisionButtonTapped: Observable<Void> {
        return decisionButton.rx.tap.asObservable()
    }
    
    private let decisionButton = UIButton().then {
        $0.backgroundColor = UIColor(hex: "#333333")
        $0.layer.cornerRadius = 4
        $0.isUserInteractionEnabled = true
    }
    
    private let decisionLabel: UILabel = {
        let label = UILabel()
        label.text = "결정"
        label.textColor = UIColor(hex: "#FFFFFF")
        label.textAlignment = .center
        
        label.font = UIFont.lemonadaBold(size: 16)
        return label
    }()
    
    let HEIGHT_RATIO = 0.64
    
    let TITLE_HEIGHT = 40
    let TITLE_INSET = 16
    
    let WIDTH_INSET = 45
    let SPACING_RATIO = 0.05
    
    let NUM_COLUMNS: Int = 3
    let NUM_ROWS: Int = 4
    
    let BUTTON_HEIGHT = 60
    let BUTTON_INSET = 24
    
    var dynamicSpacing: Double = 1
    var dynamicContainerHeight: Double = 1
    var dynamicCollectionViewHeight: Double = 1
    var dynamicCollectionViewCellSize: CGFloat = 1
    
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calDynamicContainerHeight(w: frame.width, h: frame.height)
        makeCellItemImageNames()
        setupCollectionView()
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        // MARK: - Background View
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        // MARK: - Container View
        addSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(self.WIDTH_INSET)
            make.top.equalToSuperview().inset(110)
            make.height.equalTo(self.dynamicContainerHeight)
        }
        
        // MARK: - Title
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.height.equalTo(self.TITLE_HEIGHT)
            make.top.equalToSuperview().inset(self.TITLE_INSET)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - Profile Image Select Collection View
        containerView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(self.dynamicSpacing)
            make.height.equalTo(self.dynamicCollectionViewHeight)
        }

//        // MARK: - Decision Button
        containerView.addSubview(decisionButton)
        decisionButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(self.BUTTON_INSET)
            make.top.equalTo(collectionView!.snp.bottom).offset(self.dynamicSpacing)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        decisionButton.addSubview(decisionLabel)
        decisionLabel.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func bindActions() {
        setupButtonActions()
    }
    
    private func calDynamicContainerHeight(w: CGFloat, h: CGFloat) {
        let widthForContainer: Double = Double(w - 2*(CGFloat(self.WIDTH_INSET)))
//        print("widthForContainer = \(widthForContainer)")
        let eachSpacing: Double = widthForContainer*SPACING_RATIO
        self.dynamicSpacing = eachSpacing
//        print("eachSpacing = \(eachSpacing)")
        
        let eachSize: Double = Double(widthForContainer - eachSpacing*Double(NUM_COLUMNS+1))/Double(self.NUM_COLUMNS)
//        print("eachSize = \(eachSize)")
        
        self.dynamicCollectionViewHeight = Double(self.TITLE_HEIGHT) + eachSize*Double(self.NUM_ROWS) + (eachSpacing/2)
        self.dynamicCollectionViewCellSize = CGFloat(eachSize)
        
        self.dynamicContainerHeight = dynamicCollectionViewHeight + Double(BUTTON_INSET) + Double(BUTTON_HEIGHT) + eachSpacing*Double(self.NUM_ROWS)
    }
    
    private func makeCellItemImageNames() {
        let prefix: String = "ic_profile_"
        let imageNums = 11
        for i in 1...imageNums {
            let imgName = i < 10 ? prefix + "0" + String(i) : prefix + String(i)
            self.cellItemImageNames.append(imgName)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = self.dynamicSpacing/4
        layout.minimumLineSpacing = self.dynamicSpacing
        layout.itemSize = CGSize(width: self.dynamicCollectionViewCellSize, height: self.dynamicCollectionViewCellSize)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ProfileImageCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
    }
    
    func setupButtonActions() {
        decisionButton.addTarget(self, action: #selector(decisionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func decisionButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.decisionButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.decisionButton.transform = CGAffineTransform.identity
            }) { _ in
            }
        }
        removeFromSuperview()
    }
    
    @objc private func backgroundViewTapped() {
        removeFromSuperview()
    }
    
    // MARK: - ProfileImageCollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellItemImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
        let index = indexPath.item
        let imageName = cellItemImageNames[index]
        cell.configure(imageName: imageName)
        return cell
    }
}
