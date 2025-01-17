
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import NMapsMap

class MainViewController: UIViewController {
    
    var userProfile = UserProfile(nickname: "", profileImage: UIImage(named: "ic_profile_empty")!)
    
    let initialView = InitialView()
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showInitView()
    }
    
    private func setupLayout() {
//        let mapView = NMFMapView(frame: view.frame)
//        view.addSubview(mapView)
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        mainView.isHidden = true
    }
    
    private func showInitView() {
        view.addSubview(initialView)
        initialView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        initialView.onDicisionButtonTapped = { [weak self] in
            if let self = self {
                if ProfileView.isValidNickname {
                    self.transitionToMainView()
                }
            }
        }
    }
    
    private func transitionToMainView() {
        // Show mainView first, then remove initialView
        mainView.isHidden = false
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.initialView.alpha = 0
        }) { _ in
            self.initialView.removeFromSuperview()
        }
    }
}

