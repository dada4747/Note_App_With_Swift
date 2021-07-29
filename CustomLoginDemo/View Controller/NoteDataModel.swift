//
//  Note.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 28/07/21.
//

import Foundation
struct NoteDataModel {
    let id: String
    let title: String
    let desc: String
    
    init(dictionary:[String:Any])
    {
        self.title = (dictionary["title"] as? String) ?? ""
        self.desc =  (dictionary["desc"] as? String) ?? ""
        self.id = (dictionary["id"] as? String) ?? ""

    }
}
