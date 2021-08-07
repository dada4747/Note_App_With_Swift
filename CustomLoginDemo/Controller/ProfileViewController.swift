//
//  DeletedViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit

class ProfileViewController: UIViewController {

   
    //MARK: - Variables
        
        var userArray = [UserProfile]()
        //var firebaseManager = FirebaseManager()
        
        // MARK: - Properties
        let newView = UIView()
    
        let profileImage: UIImageView = {
            let image = UIImageView(frame: CGRect(x: 100, y: 150, width: 200, height: 200))
            image.clipsToBounds = true
            image.image = UIImage(systemName: "person.fill.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
            return image
        }()
    
    let profileIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 400, width: 50, height: 50))
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        return image
    }()
    var firstnameLabelField: UILabel = {
        let firstname = UILabel(frame:CGRect(x: 60, y: 400, width: 300, height: 50))
        firstname.clipsToBounds = true
        firstname.textColor = .white
        firstname.backgroundColor = Constants.greyColor
        return firstname
    }()
    
    var lastnameLabelField: UILabel = {
        let firstname = UILabel(frame:CGRect(x: 40, y: 500, width: 300, height: 50))
        firstname.clipsToBounds = true
        firstname.textColor = .white
        firstname.backgroundColor = Constants.greyColor
        return firstname
    }()
    
    var emailLabelField: UILabel = {
        let firstname = UILabel(frame:CGRect(x: 40, y: 700, width: 300, height: 50))
        firstname.clipsToBounds = true
        firstname.textColor = .white
        firstname.backgroundColor = Constants.greyColor
        return firstname
    }()

    // MARK: - Init
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.setNavigationBarHidden(true, animated: true)
            fetchUsers()
            view.backgroundColor = Constants.greyColor
            configureViewComponents()
            addBackButton()
            
        }
    
        //MARK: - Configurations
        
        func configureViewComponents() {
        //    view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
//
            
            view.addSubview(profileImage)
            view.addSubview(firstnameLabelField)
            view.addSubview(emailLabelField)
            view.addSubview(lastnameLabelField)
            view.addSubview(profileIcon)
               
        }
    
    
    func addBackButton() {
        let image = UIImage(systemName: "arrow.backward.circle")! as UIImage
        let but:UIButton          = UIButton(frame: CGRect(x: 10, y: 40, width: 100, height: 100))
        but.layer.cornerRadius    = but.frame.width / 2
        but.layer.masksToBounds   = true
        but.setImage(image, for: .normal)
        but.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
 //       but.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        self.view.addSubview(but)
    }
        
        // MARK: - Handlers
        
        @objc func backButtonTapped() {
            
//            dismiss(animated: true, completion: nil)
        }
        //MARK: - API Methods
        
        func fetchUsers() {
            FireBaseDatabaseService.shared.fetchUserData { [weak self] user in
                self?.userArray = user
                self?.firstnameLabelField.text = self?.userArray[0].firstname
                self?.lastnameLabelField.text = self?.userArray[0].lastname
                self?.emailLabelField.text = self?.userArray[0].email
                self?.profileImage.image = self?.userArray[0].profilePhoto
            }
            print("-----------------------------------------\(userArray)")
        }
    
    }
