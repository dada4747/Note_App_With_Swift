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
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, paddingTop: 88,
                                width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(messageButton)
        messageButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: 64, paddingLeft: 32, width: 32, height: 32)
        
        view.addSubview(firstnameLabelField)
        firstnameLabelField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstnameLabelField.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        view.addSubview(emailLabel)
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.anchor(top: firstnameLabelField.bottomAnchor, paddingTop: 4)
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill.badge.plus")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let firstnameLabelField: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Eddie Brock"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "venom@gmail.com"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    // MARK: - Init
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.setNavigationBarHidden(true, animated: true)
            fetchUsers()
            view.backgroundColor = Constants.greyColor
            view.addSubview(containerView)
            containerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                 right: view.rightAnchor, height: 300)
        }
    
        //MARK: - Configurations
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
            //let vc = HomeViewController.self
            dismiss(animated: true, completion: nil)
        }
        //MARK: - API Methods
        
        func fetchUsers() {
            FireBaseDatabaseService.shared.fetchUserData { [weak self] user in
                self?.userArray = user
                self?.firstnameLabelField.text = self?.userArray[0].firstname
                //self?.lastnameLabelField.text = self?.userArray[0].lastname
                self?.emailLabel.text = self?.userArray[0].email
                self?.profileImageView.image = self?.userArray[0].profilePhoto
            }
            print("-----------------------------------------\(userArray)")
        }
    }

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

