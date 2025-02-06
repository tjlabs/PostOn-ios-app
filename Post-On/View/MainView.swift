
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
    
    var postOnView = PostOnView()
    var profileView: ProfileView?
    
    private let disposeBag = DisposeBag()
    var currentViewName: String = ""
    
    // Subviews
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
        return stackView
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
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
        
        containerView.addSubview(postOnView)
        postOnView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
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
        
        containerView.addSubview(topView)
        topView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavigationView.snp.top)
        }
    }
    
    private func bindActions() {
        for (index, itemView) in navigationItemViews.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigationBarItemTapped(_:)))
            itemView.tag = index
            itemView.addGestureRecognizer(tapGesture)
            itemView.isUserInteractionEnabled = true
        }
    }
        
    @objc private func navigationBarItemTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? NavigationBarItem else { return }
        handleNavigationAction(for: navigationItems[tappedView.tag].title)
    }
    
    private func handleNavigationAction(for title: String) {
        if self.currentViewName != title {
            switch title {
            case "Home":
                if currentViewName == "Post-On" {
                    // Post-On -> Home
                    closePostOnView()
                } else if currentViewName == "Profile" {
                    // Profile -> Home
                    self.topView.isHidden = true
                    self.profileView?.removeFromSuperview()
                }
                updateNavigationBarItems(with: title)
                print("Home tapped")
            case "Post-On":
                if currentViewName == "Home" {
                    // Home -> Post-On
                    controlPostOnView()
                } else if currentViewName == "Profile" {
                    // Profile -> Post-On
                    self.topView.isHidden = true
                    self.profileView?.removeFromSuperview()
                    controlPostOnView()
                }
                updateNavigationBarItems(with: title)
                print("Post-On tapped")
            case "Profile":
                if currentViewName == "Home" {
                    // Home -> Profile
                } else if currentViewName == "Post-On" {
                    // Post-On -> Profile
                    closePostOnView()
                }
                updateNavigationBarItems(with: title)
                self.controlProfileView()
                print("Profile tapped")
            default:
                print("Unknown navigation item tapped")
            }
            self.currentViewName = title
        }
    }
    // MARK: Control PostOnView
    private func controlPostOnView() {
        postOnView.snp.updateConstraints { make in
            make.height.equalTo(210)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    private func closePostOnView() {
        postOnView.snp.updateConstraints { make in
            make.height.equalTo(50)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    
    // MARK: Control ProfileView
    private func controlProfileView() {
        profileView = ProfileView(imageName: "img_bottom_waves_v2")
        topView.addSubview(profileView!)
        profileView!.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        topView.isHidden = false
        
        profileView!.dicisionButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.profileView!.removeFromSuperview()
                self?.topView.isHidden = true
        }).disposed(by: disposeBag)
    }
    
    private func makeNavigationBarItems() {
        navigationItems.append(NavigationItem(title: "Home", imageName: "ic_home"))
        navigationItems.append(NavigationItem(title: "Post-On", imageName: "ic_inbox"))
        navigationItems.append(NavigationItem(title: "Profile", imageName: "ic_user"))
        
        for item in navigationItems {
            navigationItemViews.append(NavigationBarItem(title: item.title, imageName: item.imageName))
        }
        
        // Set Initial View
        self.currentViewName = "Home"
        updateNavigationBarItems(with: self.currentViewName)
    }
    
    private func updateNavigationBarItems(with title: String) {
        for (index, itemView) in navigationItemViews.enumerated() {
            guard let navigationBarItem = itemView as? NavigationBarItem else { continue }
            let currentImageName = navigationItems[index].imageName
            if navigationItems[index].title == title {
                let updatedImageName = currentImageName + "_fill"
                navigationBarItem.updateImage(named: updatedImageName)
            } else {
                if currentImageName.contains("_fill") {
                    let updatedImageName = currentImageName.replacingOccurrences(of: "_fill", with: "")
                    navigationBarItem.updateImage(named: updatedImageName)
                } else {
                    navigationBarItem.updateImage(named: currentImageName)
                }
            }
        }
        bottomNavigationItemStackView.layoutIfNeeded()
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
    
    func updateImage(named imageName: String) {
        itemImageView.image = UIImage(named: imageName)
    }
}
