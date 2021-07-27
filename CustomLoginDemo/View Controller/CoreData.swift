//
//  CoreData.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import CoreData
import UIKit


class CoreData {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    static var coreData = CoreData()

    //core data functionallty
    func getAllItem(complition: @escaping([ToDoListItem]) -> Void ){

        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            print("#####################################")
            complition(models)
//            DispatchQueue.main.async {
//                //self.collectionView.reloadData()
//
//            }
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
            //getAllItem()
            print("item is created sajlkjslkf")
        } catch  {
            print("unable to create note ")
        }
    }
    
    func delete(item: ToDoListItem){
        context.delete(item)
        do {
            try context.save()
           // getAllItem()
        } catch  {
            print("item anable to delete ")
        }
    }
    
    func updateItem(item: ToDoListItem, newtitle: String, newDesc: String) {
        item.title = newtitle
        item.desc = newDesc
        do {
            try context.save()
          //  getAllItem()
        } catch  {
            print("unable to update note")
        }
    }
}
