import UIKit

struct UserProfile {
    var nickname: String = ""
    var imageName: String = ""
    
    init(nickname: String, imageName: String) {
        self.nickname = nickname
        self.imageName = imageName
    }
}
