
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then

class PostOnViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Layout
    private func setupLayout() {
        self.setupTitle()
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTitle() {
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.lemonRegular(size: 20)
        self.titleLabel.layer.shadowOpacity = 0.5
        self.titleLabel.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    // MARK: - Action
    private func goToBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        goToBack()
    }
}
