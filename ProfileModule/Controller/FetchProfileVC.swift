//
//
//
import UIKit
import UIKit


class FetchProfileVC: UIViewController {

    //MARK: - Outlets for UI elements
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var pronounLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var socialView: UIView!

    var instagramLink: String?
    var facebookLink: String?
    var user: User?
    var delegate: TheirProfileDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
           profileImageView.clipsToBounds = true

        mainView.applyCornerRadiusAndBorder(cornerRadius: 10, borderWidth: 0.1, borderColor: UIColor.gray)

        editProfileButton.layer.cornerRadius = 10
        editProfileButton.clipsToBounds = true
        bioTextView.roundCorners(cornerRadius: 20)
        loadProfile()
        applyStylingToViews()
        // Set titles for the labels
        instagramLabel.text = "Instagram"
        facebookLabel.text = "Facebook"

        // Add tap gesture recognizer to Instagram label
        let instagramTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(instagramLabelTapped))
        instagramLabel.isUserInteractionEnabled = true
        instagramLabel.addGestureRecognizer(instagramTapGestureRecognizer)

        // Add tap gesture recognizer to Facebook label
        let facebookTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(facebookLabelTapped))
        facebookLabel.isUserInteractionEnabled = true
        facebookLabel.addGestureRecognizer(facebookTapGestureRecognizer)
    }

    private func applyStylingToViews() {

         socialView.applyCornerRadiusAndShadow(cornerRadius: 10)
     }

    func loadProfile() {
        //MARK: - Fetch profile data from the local database
        if let profile = DatabaseManager.shared.fetchProfile() {
            // Assuming the profile object has properties: image, name, age, zipcode, pronoun, bio, instagramLink, facebookLink
            if let profileImageData = profile.image {
                profileImageView.image = UIImage(data: profileImageData)
            } else {
                profileImageView.image = UIImage(named: "defaultProfileImage") // Placeholder image
            }
            nameLabel.text = profile.name
            ageLabel.text = "\(profile.age)"
            zipcodeLabel.text = "\(profile.zipcode)"
            pronounLabel.text = "\(profile.pronoun)"
            bioTextView.text = profile.bio

            // Store links
            instagramLink = profile.instagramLink
            facebookLink = profile.facebookLink
        }
    }


    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        let createProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
        createProfileVC.modalPresentationStyle = .fullScreen
        createProfileVC.modalTransitionStyle = .crossDissolve

        //MARK: - Pass profile data to CreateProfileVC
        createProfileVC.profileImageData = profileImageView.image?.jpegData(compressionQuality: 1.0)
        createProfileVC.firstName = nameLabel.text ?? ""
        if let ageText = ageLabel.text, let age = Int(ageText.replacingOccurrences(of: "Age ", with: "")) {
            createProfileVC.age = age
        }
        if let zipcodeText = zipcodeLabel.text, let zipcode = Int(zipcodeText.replacingOccurrences(of: "Zip code ", with: "")) {
            createProfileVC.zipcode = zipcode
        }
        createProfileVC.pronoun = pronounLabel.text ?? ""
        createProfileVC.bio = bioTextView.text
        createProfileVC.instagramLink = instagramLink
        createProfileVC.facebookLink = facebookLink

        self.present(createProfileVC, animated: true, completion: nil)
    }


    @objc func instagramLabelTapped() {
        //MARK: - Handle Instagram label tap
        if let instagramURLString = instagramLink, let url = URL(string: instagramURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Handle invalid URL
            print("Invalid Instagram URL")
        }
    }

    @objc func facebookLabelTapped() {
        //MARK: - Handle Facebook label tap
        if let facebookURLString = facebookLink, let url = URL(string: facebookURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Handle invalid URL
            print("Invalid Facebook URL")
        }
    }
}

