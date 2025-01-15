
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    var userProfile = UserProfile(nickname: "", profileImage: UIImage(named: "ic_profile_empty")!)
    
    let initialView = InitialView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInitView()
    }
    
    private func setupLayout() {
        
    }
    
    private func showInitView() {
        view.addSubview(initialView)
        initialView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        initialView.onDicisionButtonTapped = { [weak self] in
            if let self = self {
                print("Dicision Button Tapped")
            }
        }
    }
}

