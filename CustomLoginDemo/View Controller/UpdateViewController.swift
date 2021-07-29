//
//  UpdateViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 25/07/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class UpdateViewController: UIViewController {
    let greyColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    private var models2 = [NoteDataModel]()
    var myTitle: String?
    var myDesc: String?
    //var item: Int?
    var id: String?
    var ref:DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    


    @IBOutlet weak var NewTitleLabel: UILabel!
    @IBOutlet weak var newDescLabel: UILabel!
    @IBOutlet weak var newTitleTextField: UITextField!
    @IBOutlet weak var newDescTextViewField: UITextView!
    override func viewDidLoad() {
        view.backgroundColor = greyColor
//        NoteCoreDataService.coreData.getAllItem {  coreDataModel in
//            self.coreDataModel = coreDataModel
//        }
        NoteFireBaseService().fetchNoteFromdb { models2 in
            self.models2 = models2
        }
        newTitleTextField.text = myTitle!
        newDescTextViewField.text = myDesc!
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        let title = newTitleTextField.text!
        let desc = newDescTextViewField.text!
//        let index = coreDataModel[item!]
        print(title)
        print(desc)
        NoteFireBaseService().updateNoteFromdb(item: id!, newtitle: title, newDesc: desc)
//        NoteCoreDataService.coreData.updateItem(item: index, newtitle: title, newDesc: desc)
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
 }
