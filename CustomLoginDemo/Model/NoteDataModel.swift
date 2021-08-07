//
//  Note.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 28/07/21.
//

import Foundation
import Firebase
struct NoteDataModel {
    let id          : String
    let title       : String
    let desc        : String
    var isArchive   : Bool
    var isNote      : Bool
    var isReminder  : Bool
    var date = Date()

    init(dictionary : [String:Any])
    {
        self.title      = (dictionary["title"] as? String) ?? ""
        self.desc       = (dictionary["desc"] as? String) ?? ""
        self.id         = (dictionary["id"] as? String) ?? ""
        self.isArchive  = (dictionary["isArchive"] != nil)
        self.isReminder = (dictionary["isReminder"] != nil)
        self.isNote     = (dictionary["isNote"] != nil)
    }
}
