
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then
import NMapsMap

struct NavigationItem {
    let title: String
    let imageName: String
}

class MainView: UIView {
    var navigationItems = [NavigationItem]()
    var navigationItemViews = [UIView]()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let mapView = NMFMapView()
    
    private let bottomNavigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let bottomNavigationTopLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#EFEFF0")
        return view
    }()
    
    private let bottomNavigationItemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
//        stackView.backgroundColor = .systemMint
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        makeNavigationBarItems()
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(mapView)
        mapView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(bottomNavigationView)
        bottomNavigationView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(110)
        }
        
        bottomNavigationView.addSubview(bottomNavigationTopLine)
        bottomNavigationTopLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
        }
        
        bottomNavigationView.addSubview(bottomNavigationItemStackView)
        bottomNavigationItemStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        for view in self.navigationItemViews {
            bottomNavigationItemStackView.addArrangedSubview(view)
        }
    }
    
    private func bindActions() {
    }
    
    private func makeNavigationBarItems() {
        navigationItems.append(NavigationItem(title: "Home", imageName: "ic_home"))
        navigationItems.append(NavigationItem(title: "Post-On", imageName: "ic_inbox"))
        navigationItems.append(NavigationItem(title: "Profile", imageName: "ic_user"))
        
        for item in navigationItems {
            navigationItemViews.append(NavigationBarItem(title: item.title, imageName: item.imageName))
        }
    }
}

class NavigationBarItem: UIView {
    
    private var itemImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Unknown"
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#61646B")
        label.font = UIFont.lemonadaRegular(size: 12)
        return label
    }()
    
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        itemImageView.image = UIImage(named: imageName)!
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        snp.makeConstraints{ make in
            make.height.equalTo(75)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(itemImageView)
        itemImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(5)
            make.bottom.equalTo(titleLabel.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindActions() {
        
    }
}
