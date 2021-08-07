//
//  ViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    var window: UIWindow?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "signupview.jpg")!)
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let sc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUpViewController) as! SignUpViewController
        navigationController?.pushViewController(sc, animated: true)
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.logViewController) as! LogInViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(logInButton)
    }
}
