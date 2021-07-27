//
//  NoteFireStore.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
class NoteFireStore {
    func userUid(title:String, desc:String){
        print("_____________________________ \(Auth.auth().currentUser?.uid) ______________________________")
        print("this is user id ")
        
//        let db = Firestore.firestore()
//
           let userID = Auth.auth().currentUser?.uid
        //let userName = Auth.auth().currentUser?.email
//
//
//        db.collection("users").document(userID!).setData(["title" : title, "desc" : desc], merge: true)
//
//
//
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        ref.child("users").child(userID!).childByAutoId().setValue(["title": title, "desc": desc])
//        self.ref.child("users").child(userID).setValue(["title": title])
    }
}
