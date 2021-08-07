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
    //static var shared = NoteFireBaseService()
    var postData      = [NoteDataModel]()
    let userID        = Auth.auth().currentUser?.uid
    var queryKey      = String()
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference?
   
    func addNoteFirstore(title:String, desc:String, isArchive:Bool, isReminder:Bool ,isNote:Bool){
        ref = Database.database().reference()
        ref?.child("users").child(userID!).child("note").childByAutoId().setValue(["title": title, "desc": desc,"id":UUID().uuidString,"isArchive": isArchive ,"isReminder":  isReminder, "isNote" : isNote, "createdAt": ServerValue.timestamp()])
    }
    
    func fetchNoteFromdb(complition: @escaping([NoteDataModel])-> Void) {
        postData.removeAll()
        ref = Database.database().reference()
        Database.database().reference().child("users").child(userID!).child("note").queryOrdered(byChild: "isNote").queryEqual(toValue: true).observeSingleEvent(of: .value) { snapshot in
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
    
    func updateNoteFromdb(item: String, newtitle: String, newDesc: String, isArchive : Bool, isReminder : Bool,isNote: Bool) {
        let id = item
        ref = Database.database().reference()
        ref!.child("users").child(userID!).child("note").child(id).setValue(["title": newtitle, "desc": newDesc, "id":UUID().uuidString, "isArchive": isArchive ,"isReminder":  isReminder, "isNote" : isNote]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    func deleteFromdb(item: String) {
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let id = item
        print("this id delete finc\(id)")
        ref!.child(id).removeValue()
    }
    
    func countData() {
        ref = Database.database().reference().child("users").child(userID!).child("note")
        ref!.observe(DataEventType.value, with: { (snapshot) in
            print("this is count datat fojs s fj \(snapshot.childrenCount)")
        })
    }
    
    func readData(complition: @escaping([NoteDataModel])-> Void) {
        postData.removeAll()
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let query = ref!.queryLimited(toFirst: 8)
        query.queryOrdered(byChild: "isNote").queryEqual(toValue: true).observe(DataEventType.value) { snapshot in
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else{
                return
            }
            guard let last = snapshot.children.allObjects.last as? DataSnapshot else{
                return
            }
            if snapshot.childrenCount > 1 {
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    let obj = items.value as! [String: AnyObject]
                    let title = obj["title"] as! String
                    let desc = obj["desc"] as! String
                    let key = items.key
                    let myobj = NoteDataModel(dictionary: ["title": title ,"desc": desc, "id": key])
                    self.postData.append(myobj)
                }
                
                complition(self.postData)
                self.queryKey = last.key
            }
            
        }
    }
    
    func readMoreData(complition: @escaping([NoteDataModel])-> Void) {
        print("this method call readMoreData")
       // self.postData.removeLast()
        print("qureryky \(queryKey)")
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let query = ref!.queryOrderedByKey().queryStarting(afterValue: queryKey).queryLimited(toFirst: 8)//11
        query.queryOrdered(byChild: "isNote").queryEqual(toValue: true).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else{
                    return
                }
                guard let last = snapshot.children.allObjects.last as? DataSnapshot else{
                    return
                }
                if snapshot.childrenCount > 1 {
                    for items in snapshot.children.allObjects as! [DataSnapshot] {
                        let obj = items.value as! [String: AnyObject]
                        let title = obj["title"] as! String
                        let desc = obj["desc"] as! String
                        let key = items.key
                        let myobj = NoteDataModel(dictionary: ["title": title ,"desc": desc,"id": key])
                        self.postData.append(myobj)
                    }
                    complition(self.postData)
                    self.queryKey = last.key
                }
            })
        }
    
    func addArchiveFirstore(title:String, desc:String){
        ref = Database.database().reference()
        ref?.child("users").child(userID!).child("archive").childByAutoId().setValue(["title": title, "desc": desc,"id":UUID().uuidString])
    }
    
    func readArchiveFirstData(complition: @escaping([NoteDataModel])-> Void) {
        postData.removeAll()
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let query = ref!.queryLimited(toFirst: 8)
        query.queryOrdered(byChild: "isArchive").queryEqual(toValue: true).observe(DataEventType.value) { snapshot in
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else{
                return
            }
            guard let last = snapshot.children.allObjects.last as? DataSnapshot else{
                return
            }
            if snapshot.childrenCount > 1 {
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    let obj = items.value as! [String: AnyObject]
                    let title = obj["title"] as! String
                    let desc = obj["desc"] as! String
                    let key = items.key
                    let myobj = NoteDataModel(dictionary: ["title": title ,"desc": desc, "id": key])
                    self.postData.append(myobj)
                }
                complition(self.postData)
                self.queryKey = last.key
            }
        }
    }
    
    func readMoreArchiveData(complition: @escaping([NoteDataModel])-> Void) {
        print("this method call readMoreData")
       // self.postData.removeLast()isArchive
        print("qureryky \(queryKey)")
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let query = ref!.queryOrderedByKey().queryStarting(afterValue: queryKey).queryLimited(toFirst: 8)//11
        query.queryOrdered(byChild: "isArchive").queryEqual(toValue: true).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else{
                    return
                }
                guard let last = snapshot.children.allObjects.last as? DataSnapshot else{
                    return
                }
                if snapshot.childrenCount > 1 {
                    for items in snapshot.children.allObjects as! [DataSnapshot] {
                        let obj = items.value as! [String: AnyObject]
                        let title = obj["title"] as! String
                        let desc = obj["desc"] as! String
                        let key = items.key
                        let myobj = NoteDataModel(dictionary: ["title": title ,"desc": desc,"id": key])
                        self.postData.append(myobj)
                    }
                    complition(self.postData)
                    self.queryKey = last.key
                }
            })
    }
    
    func deleteFromArchive(item: String) {
            ref = Database.database().reference().child("users").child(userID!).child("archive")
            let id = item
            print("this id delete finc\(id)")
            ref!.child(id).removeValue()
    }
    
    func updateToArchive(item: String, newtitle: String, newDesc: String) {
        let id = item
        ref = Database.database().reference()
        ref!.child("users").child(userID!).child("archive").child(id).setValue(["title": newtitle, "desc": newDesc, "id":UUID().uuidString]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    
    
    
    func fetchNote(complition: @escaping([NoteDataModel])-> Void) {
        
        ref = Database.database().reference().child("users").child(userID!).child("note")
        let query = ref!.queryLimited(toFirst: 8)
        query.queryOrdered(byChild: "createdAt").observe(DataEventType.value) { snapshot in
            guard let first = snapshot.children.allObjects.first as? DataSnapshot else{
                return
            }
            guard let last = snapshot.children.allObjects.last as? DataSnapshot else{
                return
            }
            if snapshot.childrenCount > 1 {
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    let obj = items.value as! [String: AnyObject]
                    let title = obj["title"] as! String
                    let desc = obj["desc"] as! String
                    let key = items.key
                    let myobj = NoteDataModel(dictionary: ["title": title ,"desc": desc, "id": key])
                    self.postData.append(myobj)
                }
                
                complition(self.postData)
                self.queryKey = last.key
            }
            
        }
        
    }
    
    
    func fetchMoreNotes(complition: @escaping([NoteDataModel])-> Void) {
        
        
    }
    
    
    
    
    
    
}
