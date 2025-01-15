import UIKit

struct UserProfile {
    var nickname: String = ""
    var profileImage: UIImage = UIImage(named: "ic_profile_empty")!
    
    init(nickname: String, profileImage: UIImage) {
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
