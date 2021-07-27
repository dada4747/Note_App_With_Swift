//
//  UpdateViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 25/07/21.
//

import UIKit

class UpdateViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    var myTitle: String?
    var myDesc: String?
    var item: Int?


    @IBOutlet weak var NewTitleLabel: UILabel!
    @IBOutlet weak var newDescLabel: UILabel!
    @IBOutlet weak var newTitleTextField: UITextField!
    @IBOutlet weak var newDescTextViewField: UITextView!
    override func viewDidLoad() {
        //CoreData().getAllItem()

        getAllItem()
        newTitleTextField.text = myTitle!
        newDescTextViewField.text = myDesc!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        let title = newTitleTextField.text!
        let desc = newDescTextViewField.text!
        let index = models[item!]
        print(title)
        print(desc)
        CoreData.coreData.updateItem(item: index, newtitle: title, newDesc: desc)
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    
    func getAllItem(){
        print("this is get all function................... ")
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
            }
        } catch  {
            //error
        }
    }
//
//    func createItems(title: String, desc: String){
//        let newItem = ToDoListItem(context: context)
//        newItem.title = title
//        newItem.desc = desc
//        do {
//            try context.save()
//            getAllItem()
//            print("item is created sajlkjslkf")
//        } catch  {
//            print("unable to create note ")
//        }
//    }
    
//    func delete(item: ToDoListItem){
//        context.delete(item)
//        do {
//            try context.save()
//            getAllItem()
//        } catch  {
//            print("item anable to delete ")
//        }
//    }
    
//    func updateItem(item: ToDoListItem, newtitle: String, newDesc: String) {
//        item.title = newtitle
//        item.desc = newDesc
//        do {
//            try context.save()
//            getAllItem()
//        } catch  {
//            print("unable to update note")
//        }
//    }
}
