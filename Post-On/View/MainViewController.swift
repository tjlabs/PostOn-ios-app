
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    var userProfile = UserProfile(nickname: "", profileImage: UIImage(named: "ic_profile_empty")!)
    
    var initialView = InitialView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(initialView)
        initialView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

