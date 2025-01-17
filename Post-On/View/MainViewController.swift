
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    let initialView = InitialView()
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        checkInitialUser()
//        showInitView()
    }
    
    private func setupLayout() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        mainView.isHidden = false
    }
    
    private func checkInitialUser() {
        ProfileManager.shared.loadProfileFromCache()
        if ProfileManager.shared.isLoadFromCache {
            // 기존 사용자
            print("Legacy User")
        } else {
            // 최초 사용자
            print("Initial User")
            ProfileManager.shared.setInitialProfile()
        }
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
    
//    func checkToken() {
//        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM3MDkxNzA1LCJpYXQiOjE3MzcwOTE0MDUsImp0aSI6Ijc1ZWE4OGYwODUzZDQzNTBiYWFlMmQ4MGRiOTJkOWExIiwidGVuYW50X2lkIjoiMmEwMjVlMTQtYzI0Ni00YmY0LThhNjItMDdkMTY5NDJkYTYyIn0.M8Hpdf1-RKFkeO_4KauxUq9qd_48_dE5dOVtZeaFVKE"
//
//        if let expirationDate = JWTDecoder.getExpirationDate(from: accessToken) {
//            print("accessToken expires on: \(expirationDate)")
//        } else {
//            print("Failed to get expiration date")
//        }
//        
//        let refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTczNzE3NzgwNSwiaWF0IjoxNzM3MDkxNDA1LCJqdGkiOiIzZmRiZGU1ZTI0MDY0M2U0OGU5OTdjZTA1MjlhMmRjZSIsInRlbmFudF9pZCI6IjJhMDI1ZTE0LWMyNDYtNGJmNC04YTYyLTA3ZDE2OTQyZGE2MiJ9.ij4oDWbvzNbXmlKZpXAiNnF6lBFZyZjwPJEt05OZ3jk"
//
//        if let expirationDate = JWTDecoder.getExpirationDate(from: refreshToken) {
//            print("refreshToken expires on: \(expirationDate)")
//        } else {
//            print("Failed to get expiration date")
//        }
//    }
}



//struct JWTDecoder {
//    static func decodeJWT(token: String) -> [String: Any]? {
//        let segments = token.split(separator: ".")
//        guard segments.count == 3 else {
//            print("Invalid JWT structure")
//            return nil
//        }
//        
//        let payloadSegment = segments[1]
//        
//        // Base64 decode the payload
//        var base64 = String(payloadSegment)
//        base64 = base64.replacingOccurrences(of: "-", with: "+")
//        base64 = base64.replacingOccurrences(of: "_", with: "/")
//        while base64.count % 4 != 0 {
//            base64 += "="
//        }
//        
//        guard let payloadData = Data(base64Encoded: base64) else {
//            print("Invalid Base64 string")
//            return nil
//        }
//        
//        do {
//            if let json = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
//                return json
//            }
//        } catch {
//            print("Error decoding JSON: \(error)")
//        }
//        
//        return nil
//    }
//
//    static func getExpirationDate(from token: String) -> Date? {
//        guard let payload = decodeJWT(token: token),
//              let exp = payload["exp"] as? TimeInterval else {
//            print("Expiration claim not found")
//            return nil
//        }
//        
//        return Date(timeIntervalSince1970: exp)
//    }
//}
