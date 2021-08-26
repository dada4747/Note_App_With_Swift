//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController  {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var selectedImage: UIImage?
    let profileImage: UIButton =  {
            let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
            button.clipsToBounds = true
            button.setBackgroundImage(UIImage(systemName: "person.fill.badge.plus")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.imageView?.contentMode = .scaleToFill
            button.addTarget(self, action: #selector(profileImageSelectorTapped), for: .touchUpInside)
            //button.layer.cornerRadius = 100
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.numberOfLines = 3
        setUpElements()
        view.backgroundColor = Constants.greyColor
        configureProfile()
        
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        return true
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    //check the field and validate the data is correct if correct this method return nill else return error message
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and number."
        }
        return nil
    }
    
    //when sign up tapped action
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            //create clean version of data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           //*********************************************
            guard let image = self.selectedImage else {
                        return
                    }
                    guard let imagedata = image.jpegData(compressionQuality: 0.75) else {
                        return
                    }
            //*********************************************
            
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { [self] (result, err) in
                
                
                
                
                
            //check for errors
                if err != nil {
                    //there was an error creating the user
                    self.showError("Error creating user")
                } else {
                    
                    //*************************
                    let uid = result?.user.uid

                    print("===========================", uid!)
                                let fileName = uid! // NSUUID().uuidString
                    
                    let storageRef = Storage.storage().reference(withPath: "profileImage/\(String(describing: fileName))")
                    
                                    storageRef.putData(imagedata, metadata: nil) { storageMetaData, error in
                                        if let e = error {
                                            print("Error putting image in storage \(e.localizedDescription)")
                                            return
                                        }
                                    }
                                    print("****************")
//                                    storageRef.downloadURL { url, error in
//                                        print("11111111")
//                                        guard let imageURl = url?.absoluteString else { return }
//                                        print("\(String(describing: imageURl))")
//                                    }
                    storageRef.downloadURL(completion: { url, error in
                        if let imageURL = url?.absoluteString {
                            print(imageURL)
                        }
                    })
                    
                    
                    
                    //user are created sucessfully now stored first name and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid, "profilePhoto": "","email": email]) { (error) in
                        if error != nil {
                            //show error message
                            self.showError("Error saving user data")
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    //method for navigate controller to home screen
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    //______________________________________________________________________________________________________//
    
    
    func configureProfile() {
        view.addSubview(profileImage)
//        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70)
//        profileImage. p anchor(top: view.topAnchor, paddingTop: 70, width: 200, height: 200)
//                profileImage.translatesAutoresizingMaskIntoConstraints = false
//                profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    }
    
    
    
    @objc func profileImageSelectorTapped() {
            print("imageview tapped")
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    
    //______________________________________________________________________________________________________//
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImage.setImage(image, for: .normal)
            selectedImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
