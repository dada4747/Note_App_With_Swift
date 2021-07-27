//
//  LogInViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LogInViewController: UIViewController, LoginButtonDelegate {
    let signInConfig = GIDConfiguration.init(clientID: "48649686610-tnc5hhbun8dm3cr3lrsha7q551sbh7dj.apps.googleusercontent.com")

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        btnFacebook.delegate = self
        btnFacebook.permissions = ["public_profile", "email"]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    //method for login button for facebook login
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    
        if error != nil {
            print(error?.localizedDescription as Any)
            return
        }
        if (result?.token) != nil {
            let token: AccessToken = (result?.token)!
            print(token)
            print("token is = \(AccessToken.current!) ")
            print("User Id = \((AccessToken.current?.userID)!) ")
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        
        }
    }
    //method for logout facebook default
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("user is logged out ")
    }
    
    func setUpElements() {
        //hide the error bar
        errorLabel.alpha = 0
        //style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    //button for login with firebase email and password
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    // button for login with google
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        // Create Google Sign In configuration object.
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
