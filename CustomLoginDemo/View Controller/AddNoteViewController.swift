//
//  AddNoteViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 25/07/21.
//

import UIKit

class AddNoteViewController: UIViewController {
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //private var models = [ToDoListItem]()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty || !desc.isEmpty {
            CoreData.coreData.createItems(title: title, desc: desc)

//            CoreData().createItems(title: title , desc: desc)
            NoteFireStore().userUid(title: title, desc: desc)

//            createItems(title: title , desc: desc)
        navigationController?.popViewController(animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }

//    func getAllItem() {
//        do {
//            models = try context.fetch(ToDoListItem.fetchRequest())
//            DispatchQueue.main.async {
//            }
//        } catch  {
//            //error
//        }
//    }
//
//    func createItems(title: String, desc: String) {
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

//
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
