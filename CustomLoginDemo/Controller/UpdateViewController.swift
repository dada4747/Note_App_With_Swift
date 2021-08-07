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
    var id: String?
    var ref:DatabaseReference?
    let userID = Auth.auth().currentUser?.uid
    var isArchive: Bool?
    var isReminder: Bool?
    var isNote: Bool?
    
    @IBOutlet weak var NewTitleLabel: UILabel!
    @IBOutlet weak var newDescLabel: UILabel!
    @IBOutlet weak var newTitleTextField: UITextField!
    @IBOutlet weak var newDescTextViewField: UITextView!
    
    override func viewDidLoad() {
        view.backgroundColor = greyColor
        newTitleTextField.text = myTitle!
        newDescTextViewField.text = myDesc!
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        let title = newTitleTextField.text!
        let desc = newDescTextViewField.text!
        print(title)
        print(desc)
        FireBaseDatabaseService.shared.updateDataToFirebase(note: id!, title: title, desc: desc, isArchive: isArchive!, isNote: isNote!, isReminder: isReminder!)
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 }
