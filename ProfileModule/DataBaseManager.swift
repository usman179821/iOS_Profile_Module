

import Foundation
import UIKit

class DatabaseManager {
    static let shared = DatabaseManager()

    private let profileKey = "profileKey"

    private init() {}

    func saveProfile(image: Data?, name: String, age: Int, zipcode: String, pronoun: String, bio: String, instagramLink: String, facebookLink: String) {
        let profile = Profile(image: image, name: name, age: age, zipcode: zipcode, pronoun: pronoun, bio: bio, instagramLink: instagramLink, facebookLink: facebookLink)
        
        if let encodedProfile = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encodedProfile, forKey: profileKey)
        }
    }

    func fetchProfile() -> Profile? {
        guard let savedProfileData = UserDefaults.standard.data(forKey: profileKey) else {
            return nil
        }

        if let profile = try? JSONDecoder().decode(Profile.self, from: savedProfileData) {
            return profile
        }
        return nil
    }
}

// Define the Profile model
struct Profile: Codable {
    let image: Data?
    let name: String
    let age: Int
    let zipcode: String
    let pronoun: String
    let bio: String
    let instagramLink: String
    let facebookLink: String
}



