//
//  NoteCoreDataService.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import CoreData
import UIKit


class NoteCoreDataService {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    static var coreData = NoteCoreDataService()

    func getAllItem(complition: @escaping([ToDoListItem]) -> Void ){
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            complition(models)
        } catch  {
            //error
        }
    }
    
    func createItems(title: String, desc: String){
        let newItem = ToDoListItem(context: context)
        newItem.title = title
        newItem.desc = desc
        do {
            try context.save()
        } catch  {
            print("unable to create note ")
        }
    }
    
    func delete(item: ToDoListItem){
        context.delete(item)
        do {
            try context.save()
        } catch  {
            print("item anable to delete ")
        }
    }
    
    func updateItem(item: ToDoListItem, newtitle: String, newDesc: String) {
        item.title = newtitle
        item.desc = newDesc
        do {
            try context.save()
        } catch  {
            print("unable to update note")
        }
    }
}
