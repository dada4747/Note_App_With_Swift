//
//  NoteDBService.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class NoteFireBaseService {
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var postData = [NoteDataModel]()
    
    let userID = Auth.auth().currentUser?.uid

    func addNoteFirstore(title:String, desc:String){
     //   let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref?.child("users").child(userID!).childByAutoId().setValue(["title": title, "desc": desc,"id":UUID().uuidString])
    }
    
    func fetchNoteFromdb(complition: @escaping([NoteDataModel])-> Void) {
        postData.removeAll()
        ref = Database.database().reference()
        print("retrive function call here")
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value1 = snap.value as? NSDictionary
                let title = value1?["title"] as? String ?? ""
                let desc = value1?["desc"] as? String ?? ""
               // let id = value1?["id"] as? String ?? ""
                let newNote = NoteDataModel(dictionary: ["title": title ,"desc": desc,"id": key])
                self.postData.append(newNote)
            }
            complition(self.postData)
        }
    }
    
    func updateNoteFromdb(item: String, newtitle: String, newDesc: String) {
        let id = item
        ref = Database.database().reference()
        ref!.child("users").child(userID!).child(id).setValue(["title": newtitle, "desc": newDesc, "id":UUID().uuidString]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    func deleteFromdb(item: String) {
        ref = Database.database().reference()
        let id = item
        print("this id delete finc\(id)")
        ref!.child("users").child(userID!).child(id).removeValue()
    }
    
}
