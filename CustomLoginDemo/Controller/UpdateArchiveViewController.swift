//
//  UpdateArchiveViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 01/08/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class UpdateArchiveViewController: UIViewController {

    @IBOutlet weak var archiveNoteTitle: UILabel!
    @IBOutlet weak var archiveNoteTextField: UITextField!
    private var models2     = [NoteDataModel]()
    var myTitle             : String?
    var myDesc              : String?
    //var item: Int?
    var id                  : String?
    var ref                 : DatabaseReference?
    let userID              = Auth.auth().currentUser?.uid
    
    var isArchive: Bool     = true
    var isReminder: Bool    = false
    var isNote: Bool        = false
    
    @IBOutlet weak var archiveDescLabel     : UILabel!
    
    @IBOutlet weak var archiveDescTextView  : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.greyColor
        archiveNoteTextField.text = myTitle!
        archiveDescTextView.text = myDesc!
    }

    @IBAction func cancleButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func updateButton(_ sender: Any) {
        let title = archiveNoteTextField.text!
        let desc = archiveDescTextView.text!
        FireBaseDatabaseService.shared.updateDataToFirebase(note: id!, title: title, desc: desc, isArchive: isArchive, isNote: isNote, isReminder: isReminder)
        navigationController?.popViewController(animated: true)
    }
}
