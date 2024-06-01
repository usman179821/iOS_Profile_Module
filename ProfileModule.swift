//
//  ProfileModule.swift
//  Flare
//
//  Created by Eric Solberg on 5/23/24.
//

import UIKit

// MARK: - Profile Module

/// The user-profile sections of the app.
protocol ProfileModule {
    
    /// Create and return the "Create Profile" view controller, which is presented to a new user when they sign in for the first time.
    /// - Parameter deletate: An object to be notified of events in the "Create Profile" screen.
    /// - Returns: The "Create Profile" view controller, which will be presented modally, full-screen.
    static func getCreateProfileVC(deletate: CreateProfileDelegate) -> UIViewController
    
    /// Create and return the profile tab's root view controller (representing the current user's profile).
    /// - Parameters:
    ///   - user: The current user's `User` object.
    ///   - delegate: An object to be notified of events in the current user's profile flow.
    /// - Returns: The profile tab's root view controller.
//    static func getRootProfileVC(given user: User?, delegate: MyProfileDelegate) -> UIViewController
    
    /// Create and return the profile view controller for someone else's profile (i.e. "their profile" in the Figma).
    /// - Parameters:
    ///   - user: The user to populate the profile screen with.
    ///   - delegate: An object to be notified of events in the profile screen.
    /// - Returns: The profile view controller.
    static func getProfileVC(given user: User, post: Post?, comment: Comment?, delegate: TheirProfileDelegate) -> UIViewController
}

// MARK: - Delegates

/// Delegate for the "Create Profile" screen.
protocol CreateProfileDelegate {
    
    /// Call this to sign out the user when the "sign out" button is tapped.
    /// - Parameter completion: Called with the simple result of the sign out process. On success, dismiss the profile screen (which was modally presented). On failure, present to the user the accompanying user-friendly error message.
    func signOut(completion: @escaping (_ result: SimpleResult) -> Void)
    
    /// Call this when the user fills in their profile information and taps "Save".
    /// - Parameters:
    ///   - user: The user object to be created.
    ///   - completion: Called with `.success` if the user is created successfully, or `.error` if it fails. On error, present the user-readable error message (if not nil) to the user, in an alert controller. On success, dismiss the screen and call the `screenDismissed`delegate method in the dismiss completion.
    func createUser(_ user: User, completion: @escaping (_ result: SimpleResult) -> Void)
    
    /// Call this if the user was created successfully and the screen is dismissed. Call this AFTER the dismiss animation has completed.
    func screenDismissed()
}

/// Delegate for the "My Profile" screens.
protocol MyProfileDelegate {
    
    /// Called when the user edits their profile and taps "save".
    /// - Parameter user: The updated user object.
    func userDidUpdate(user: User)
}

/// Delegate when viewing someone else's profile.
protocol TheirProfileDelegate {
    
    /// Called when the message button is tapped. Call this AFTER you dismiss the screen, inside the dismiss function's completion handler.
    /// - Parameters:
    ///   - user: The user whose message button was tapped.
    func messageButtonTapped(for user: User)
}

// MARK: - Models

class User {
    let id: String
    var image: UIImage
    var name: String
    var age: Int
    var pronoun: Pronoun
    var location: String
    var bio: String
    
    init(id: String, image: UIImage, name: String, age: Int, pronoun: Pronoun, location: String, bio: String) {
        self.id = id
        self.image = image
        self.name = name
        self.age = age
        self.pronoun = pronoun
        self.location = location
        self.bio = bio
    }
}

// MARK: - Enums

enum Pronoun {
    case Man
    case Woman
    // more will likely be added later
}

enum SimpleResult {
    case success
    /// The accompanying String (if not nil) is a user-friendly error message you can present to the user in a UIAlertController.
    case error(String?)
}

class Post {
    let id: String = ""
    // Additional properties and initializers
}

class Comment {
    let id: String = ""
    // Additional properties and initializers
}
