import Foundation
import UIKit

class ProfileManager {
    static let shared = ProfileManager()
    
    var isLoadFromCache: Bool = false
    var userProfile = UserProfile(nickname: "", imageName: "")
    
    private init() { }

    func loadProfileFromCache() {
        let defaults = UserDefaults.standard
        if let nickname = defaults.string(forKey: "PostOnProfileNickname"),
           let imageName = defaults.string(forKey: "PostOnProfileImageName") {

            userProfile.nickname = nickname
            userProfile.imageName = imageName
            isLoadFromCache = true
        } else {
            isLoadFromCache = false
        }
        print("ProfileManager (Load From Cahce) : userProfile = \(userProfile)")
    }
    
    func saveProfileToCache() {
        let defaults = UserDefaults.standard
        defaults.set(userProfile.nickname, forKey: "PostOnProfileNickname")
        defaults.set(userProfile.imageName, forKey: "PostOnProfileImageName")
        
        print("ProfileManager (Save To Cahce) : userProfile = \(userProfile)")
        defaults.synchronize()
    }
    
    func setInitialProfile() {
        userProfile.imageName = "ic_profile_empty"
    }
}
