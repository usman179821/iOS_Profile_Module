

import UIKit
import RappleProgressHUD

class CreateProfileVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: - Outlets for UI elements
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var pronounTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var instagramLinkTextField: UITextField!
    @IBOutlet weak var facebookLinkTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var BottomView: UIView!
    
    //MARK: - Variables to hold profile data
    var profileImageData: Data?
    var firstName: String?
    var age: Int?
    var zipcode: Int?
    var pronoun: String?
    var bio: String?
    var instagramLink: String?
    var facebookLink: String?

    let pronouns = ["He/Him", "She/Her", "They/Them", "Other"]
    var pronounPickerView: UIPickerView!
    var delegate: CreateProfileDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegates()
        setupUIComponents()
        setupTapGestures()
        setProfileData()
        // Applying the first shadow
  
    }

    //MARK: - Function to set up delegates
    func setupDelegates() {
        firstNameTextField.delegate = self
        ageTextField.delegate = self
        zipcodeTextField.delegate = self
        pronounTextField.delegate = self
        instagramLinkTextField.delegate = self
        facebookLinkTextField.delegate = self
    }

    //MARK: - Function to set up UI components
    func setupUIComponents() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        setupPronounPicker()
        setupImagePicker()
        setupRoundedCorners()
    }

    //MARK: - Function to set up tap gestures
    func setupTapGestures() {
        if let firstName = firstName {
            titleLabel.text = "Edit Profile"
    
        } else {
            titleLabel.text = "Create Profile"
        
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //MARK: - Function to set profile data
    func setProfileData() {
        if let imageData = profileImageData {
            profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = UIImage(named: "ProfileImg") // Placeholder image
        }

        firstNameTextField.text = firstName
        ageTextField.text = age != nil ? "\(age!)" : ""
        zipcodeTextField.text = zipcode != nil ? "\(zipcode!)" : ""
        pronounTextField.text = pronoun
        bioTextView.text = bio
        instagramLinkTextField.text = instagramLink
        facebookLinkTextField.text = facebookLink
    }


    //MARK: - Function to set up picker view for pronouns
    func setupPronounPicker() {
        pronounPickerView = UIPickerView()
        pronounPickerView.dataSource = self
        pronounPickerView.delegate = self

        pronounTextField.inputView = pronounPickerView

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)

        pronounTextField.inputAccessoryView = toolbar
    }

    func setupImagePicker() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)

        addImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
    }

    @objc func doneButtonTapped() {
        let selectedRow = pronounPickerView.selectedRow(inComponent: 0)
        pronounTextField.text = pronouns[selectedRow]
        pronounTextField.resignFirstResponder()
    }

    @objc func addImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Save data functionality


    func saveProfile() {
        let newUser = User(id: "1", image: UIImage(), name: "John Doe", age: 30, pronoun: .Man, location: "New York", bio: "Hello!")
        delegate?.createUser(newUser) { result in
            switch result {
            case .success:
                self.dismiss(animated: true) {
                    self.delegate?.screenDismissed()
                }
            case .error(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard validateFields() else {
            return
        }

        let profileImageData = profileImageView.image?.jpegData(compressionQuality: 0.8) // Optional compression
        RappleActivityIndicatorView.startAnimating()

        DatabaseManager.shared.saveProfile(image: profileImageData, name: firstNameTextField.text!, age: Int(ageTextField.text!)!, zipcode: zipcodeTextField.text!, pronoun: pronounTextField.text!, bio: bioTextView.text, instagramLink: instagramLinkTextField.text ?? "", facebookLink: facebookLinkTextField.text ?? "")
        RappleActivityIndicatorView.stopAnimating()

        clearFields()

        // Transition to FetchProfileVC
        if let fetchProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "FetchProfileVC") as? FetchProfileVC {
            fetchProfileVC.modalPresentationStyle = .fullScreen
            fetchProfileVC.modalTransitionStyle = .crossDissolve
            self.present(fetchProfileVC, animated: true, completion: nil)
        }
    }

    private func validateFields() -> Bool {
        if firstNameTextField.text?.isEmpty ?? true {
            showAlert(message: "Please enter your first name.")
            return false
        }
        if ageTextField.text?.isEmpty ?? true {
            showAlert(message: "Please enter your age.")
            return false
        }
        if zipcodeTextField.text?.isEmpty ?? true {
            showAlert(message: "Please enter your zipcode.")
            return false
        }
        if pronounTextField.text?.isEmpty ?? true {
            showAlert(message: "Please select your pronoun.")
            return false
        }
        if bioTextView.text.isEmpty {
            showAlert(message: "Please enter your bio.")
            return false
        }
        if profileImageView.image == UIImage(named: "ProfileImg") {
            showAlert(message: "Please select a profile image.")
            return false
        }
        return true
    }

    private func clearFields() {
        firstNameTextField.text = ""
        ageTextField.text = ""
        zipcodeTextField.text = ""
        pronounTextField.text = ""
        bioTextView.text = ""
        instagramLinkTextField.text = ""
        facebookLinkTextField.text = ""
        profileImageView.image = UIImage(named: "ProfileImg")
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        // Handle sign out
        print("Sign out button tapped")
    }

    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pronouns.count
    }

    // UIPickerViewDelegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pronouns[row]
    }


    func setupRoundedCorners() {
        firstNameTextField.roundCorners(cornerRadius: 18)
        ageTextField.roundCorners(cornerRadius: 18)
        zipcodeTextField.roundCorners(cornerRadius: 18)
        pronounTextField.roundCorners(cornerRadius: 18)
        instagramLinkTextField.roundCorners(cornerRadius: 18)
        facebookLinkTextField.roundCorners(cornerRadius: 18)
        bioTextView.roundCorners(cornerRadius: 20)
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        
        BottomView.applyShadow(offset: CGSize(width: 0, height: 0),
                               radius: 4,
                               color: UIColor.black.withAlphaComponent(0.08),
                               opacity: 3.0)
        
//        // Applying the second shadow
//        BottomView.applyShadow(offset: CGSize(width: 0, height: 0),
//                               radius: 6,
//                               color: UIColor.black.withAlphaComponent(0.02),
//                               opacity: 1.0)
    }
}


