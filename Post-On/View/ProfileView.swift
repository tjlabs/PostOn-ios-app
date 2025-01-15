
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import Then

protocol ProfileViewDelegate: AnyObject {
    func didTapDicisionButton(userProfile: UserProfile)
}

class ProfileView: UIView {
    static var userNickName = BehaviorRelay<String>(value: "")
    static var userProfileImage = BehaviorRelay<UIImage>(value: UIImage(named: "ic_profile_empty")!)
    
    private let disposeBag = DisposeBag()
    weak var delegate: ProfileViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.lemonRegular(size: 40)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "*설정한 프로필은 언제든지 변경할 수 있습니다."
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#616161")
        label.font = UIFont.lemonadaRegular(size: 12)
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
    
    private let profileEditImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_edit")
    }
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#AAAAAA").cgColor
        return view
    }()
    
    private let namePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#AAAAAA")
        label.font = UIFont.lemonadaRegular(size: 16)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.lemonRegular(size: 16)
        textField.textAlignment = .left
        textField.textColor = .black
        return textField
    }()
    
    private let decisionButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(hex: "#333333")
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = true
        return view
    }()
    
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
        // MARK: - Title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.height.equalTo(52)
            make.width.equalTo(152)
            make.top.equalToSuperview().offset(95)
            make.leading.equalToSuperview().offset(60)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints{ make in
            make.height.equalTo(24)
            make.width.equalTo(237)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        // MARK: - Profile (Image)
        addSubview(profileContainerView)
        profileContainerView.snp.makeConstraints{ make in
            make.width.height.equalTo(140)
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(27)
        }
        profileContainerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        profileContainerView.addSubview(profileEditImageView)
        profileEditImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.bottom.trailing.equalToSuperview().inset(7)
        }
        
        // MARK: - Nickname
        addSubview(nameContainerView)
        nameContainerView.snp.makeConstraints{ make in
            make.top.equalTo(profileContainerView.snp.bottom).offset(50)
            make.height.equalTo(58)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        nameContainerView.addSubview(namePlaceholderLabel)
        namePlaceholderLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(18)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nameContainerView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(18)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // MARK: - Decision Button
        addSubview(decisionButton)
        decisionButton.snp.makeConstraints{ make in
            make.top.equalTo(nameContainerView.snp.bottom).offset(64)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        decisionButton.addSubview(decisionLabel)
        decisionLabel.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func bindActions() {
        // Observe userNickName and toggle infoLabel visibility
        ProfileView.userNickName
            .map { !$0.isEmpty }
            .bind(to: namePlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
            
        // Handle text field editing
        nameTextField.rx.text.orEmpty
            .bind(to: ProfileView.userNickName)
            .disposed(by: disposeBag)
            
        // Dismiss keyboard on return key
        nameTextField.delegate = self
        setupKeyboardDismissal()
        setupButtonActions()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
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
                if !ProfileView.userNickName.value.isEmpty {
                    self.delegate?.didTapDicisionButton(userProfile: UserProfile(nickname: ProfileView.userNickName.value, profileImage: ProfileView.userProfileImage.value))
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension ProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
