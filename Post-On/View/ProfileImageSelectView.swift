
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then


class ProfileImageSelectView: UIView {
    
    private let disposeBag = DisposeBag()
    
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
        label.font = UIFont.lemonRegular(size: 20)
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
    
    init() {
        super.init(frame: .zero)
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
            make.leading.trailing.equalToSuperview().inset(45)
            make.top.equalToSuperview().inset(110)
            make.height.equalTo(540)
        }
        
        // MARK: - Title
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.height.equalTo(40)
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
        
//        // MARK: - Profile (Image)
//        addSubview(profileContainerView)
//        profileContainerView.snp.makeConstraints{ make in
//            make.width.height.equalTo(140)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(infoLabel.snp.bottom).offset(27)
//        }
//        profileContainerView.addSubview(profileImageView)
//        profileImageView.snp.makeConstraints{ make in
//            make.leading.trailing.top.bottom.equalToSuperview()
//        }
//        
//        profileContainerView.addSubview(profileEditImageView)
//        profileEditImageView.snp.makeConstraints{ make in
//            make.width.height.equalTo(30)
//            make.bottom.trailing.equalToSuperview().inset(7)
//        }
//
//        // MARK: - Decision Button
//        addSubview(decisionButton)
//        decisionButton.snp.makeConstraints{ make in
//            make.top.equalTo(nameContainerView.snp.bottom).offset(64)
//            make.height.equalTo(60)
//            make.leading.trailing.equalToSuperview().inset(10)
//        }
//        
//        decisionButton.addSubview(decisionLabel)
//        decisionLabel.snp.makeConstraints{ make in
//            make.centerX.centerY.equalToSuperview()
//            make.leading.trailing.top.bottom.equalToSuperview()
//        }
    }
    
    func bindActions() {
        setupButtonActions()
    }

    func setupButtonActions() {
        decisionButton.addTarget(self, action: #selector(decisionButtonTapped), for: .touchUpInside)
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
}
