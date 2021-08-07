//
//  UserProfile.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 05/08/21.
//

import Foundation
import Firebase
struct UserProfile {
    
    var firstname: String
    var lastname: String
    var email: String
    var profilePhoto: UIImage?
    var loggedInUserID: String?
    
    init(dictionary : [String:Any]) {
        self.firstname = dictionary["firstname"] as! String? ?? ""
        self.lastname = dictionary["lastname"] as! String? ?? ""
        self.email = dictionary["email"] as! String? ?? ""
        self.loggedInUserID = dictionary["uid"] as? String
        self.profilePhoto = dictionary["profilePhoto"] as? UIImage 
    }

    
}
