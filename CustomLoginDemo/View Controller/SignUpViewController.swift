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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.numberOfLines = 3
        // Do any additional setup after loading the view.
        setUpElements()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newbg.jpg")!)

    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true

        return true
    }
    
    func setUpElements() {
        //hide the error label
        errorLabel.alpha = 0
        //style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
     //   self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newbg.jpg")!)
    }
    
    //check the field and validate the data is correct if correct this method return nill else return error message
    func validateFields() -> String? {
        //check all fields are filled in
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
            
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { [self] (result, err) in
            //check for errors
                if err != nil {
                    //there was an error creating the user
                    self.showError("Error creating user")
                } else {
                   
                    
                    //user are created sucessfully now stored first name and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //show error message
                            self.showError("Error saving user data")
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                    //transition to home screen
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
    
    
}
