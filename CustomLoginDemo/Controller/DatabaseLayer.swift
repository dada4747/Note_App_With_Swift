//
//  databaseLayer.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 29/07/21.
//

import Foundation
struct DatabaseLayer {
    static let dblayerManeger = DatabaseLayer()
    let firebaseManeger = NoteFireBaseService()
    let coreDataManeger = NoteCoreDataService()
    
    
    func getNotes(complition: @escaping([NoteDataModel])-> Void)
        {
        firebaseManeger.fetchNoteFromdb{ models in
                complition(models)
            }
        }
    func getStartNote(complition: @escaping([NoteDataModel])-> Void){
        firebaseManeger.readData { notes in
            complition(notes)
        }
    }
}
