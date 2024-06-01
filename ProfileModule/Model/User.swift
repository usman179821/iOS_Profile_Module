//
//

import UIKit
class ProfileModuleImpl: ProfileModule {    

    static func getCreateProfileVC(deletate delegate: CreateProfileDelegate) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let createProfileVC = storyboard.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC {
            createProfileVC.delegate = delegate
            return createProfileVC
        }
        return UIViewController() // Fallback in case of failure
    }
    
    static func getProfileVC(given user: User, post: Post?, comment: Comment?, delegate: TheirProfileDelegate) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let fetchProfileVC = storyboard.instantiateViewController(withIdentifier: "FetchProfileVC") as? FetchProfileVC {
            fetchProfileVC.user = user
            fetchProfileVC.delegate = delegate
            return fetchProfileVC
        }
        return UIViewController() // Fallback in case of failure
    }
}

class CreateProfileHandler: CreateProfileDelegate {
    func signOut(completion: @escaping (SimpleResult) -> Void) {
        // Simulate sign out process
        completion(.success)
    }

    func createUser(_ user: User, completion: @escaping (SimpleResult) -> Void) {
        // Simulate user creation process
        completion(.success)
    }

    func screenDismissed() {
        // Handle screen dismissal after profile creation
        print("Create Profile Screen Dismissed")
    }
}

class MyProfileHandler: MyProfileDelegate {
    func userDidUpdate(user: User) {
        // Handle profile update
        print("User profile updated: \(user.name)")
    }
}

class TheirProfileHandler: TheirProfileDelegate {
    func messageButtonTapped(for user: User) {
        // Handle message button tap
        print("Message button tapped for user: \(user.name)")
    }
}
