//
//  FireBaseDatabaseService.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 03/08/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FireBaseDatabaseService {
    var model       =   [NoteDataModel]()
    let db          =   Firestore.firestore()
    var documents   =   [QueryDocumentSnapshot]()
    var lastSnapshot:   QueryDocumentSnapshot?
    static var shared = FireBaseDatabaseService()
    
    //  write Data into firebase database
    func writeToFirebase(title: String,description: String,isRemainder: Bool,isArchieved:Bool, isNote:Bool) {
        let data:[String: Any] = ["title": title , "Description": description,"created":Timestamp.init(date: Date()),"isRemainder":isRemainder,"isArchieved":isArchieved, "isNote": isNote]
           guard let uid = Auth.auth().currentUser?.uid else { return print("Error in saving user id") }
            Firestore.firestore().collection("Notes").document(uid).collection("note").addDocument(data: data)
    }
    
    // Fetch first few Notes from firebase//.whereField("isNote", isEqualTo: true)
    func fetchNotes(complition: @escaping([NoteDataModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: false).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
     }
    
    // Fetch more notes from firebse
    func fetchMoreNotes(complition: @escaping([NoteDataModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: false).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
                
    }
    
    func fetchArchive(complition: @escaping([NoteDataModel])-> Void) {
        print("this is archive fetch call ")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
    }
    func fetchMoreArchive(complition: @escaping([NoteDataModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
    }
    func fetchReminderNotes(complition: @escaping([NoteDataModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isRemainder", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
     }
    
    // Fetch more notes from firebse
    func fetchMoreReminderNotes(complition: @escaping([NoteDataModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isRemainder", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
                
    }
    
    // service for fetching notes and more notes func
    func fetchNotesService(withQuery query : Query , complition: @escaping([NoteDataModel])-> Void) {
        var notes = [NoteDataModel]()
        query.getDocuments { QuerySnapshot,Error in
            if Error != nil{
                print("Error in fetching data")
            }
            else {
                QuerySnapshot!.documents.forEach({ (document) in
                    let data = document.data() as [String: AnyObject]
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let desc = data["Description"] as? String ?? ""
                    let newNote =  NoteDataModel(dictionary: ["title": title ,"desc": desc,"id":id])
                    notes.append(newNote)
                    self.documents.insert(document, at: 0)
                 })
                complition(notes)
            }
        }
    }
    
   //update notes to firebase database
    public func updateDataToFirebase(note: String , title: String, desc: String, isArchive:Bool, isNote:Bool, isReminder:Bool ) {
        print("In update method ")
        print(title)
        print(note)
        let data:[String: Any] = ["title": title , "Description": desc, "isArchieved": isArchive, "isNote":isNote, "isRemainder": isReminder]
        guard let uid  = Auth.auth().currentUser?.uid else {
            print("User is not vallid user")
            return
        }
        print(note)
        Firestore.firestore().collection("Notes").document(uid).collection("note").document(note).updateData(data) { error in
            if let error = error{
                print("Update Failed.......")
            }
        }
    }
    //deleting data from firebase
    public func deleteDataToFirebase(note: String)
    {
        guard let uid =  Auth.auth().currentUser?.uid else{
            return
        }
        Firestore.firestore().collection("Notes").document(uid).collection("note").document(note).delete()
    }
    
    func fetchUserData(completed: @escaping ([UserProfile]) -> ()) {
            let db = Firestore.firestore()
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Error user is not valid user")
                return
            }
            db.collection("users").whereField("uid", isEqualTo: userId).getDocuments { querySnapshot, error in
                    var users: [UserProfile] = []
                    querySnapshot!.documents.forEach({ (document) in
                        let user = UserProfile(dictionary: document.data())
                        users.append(user)
                        print(user)
                    })
                    completed(users)
            }
        }
   
}
