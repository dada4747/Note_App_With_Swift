//
//  AddNoteViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 25/07/21.
//

import UIKit

class AddNoteViewController: UIViewController {
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //private var coreDataModel = [ToDoListItem]()
    let greyColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = greyColor
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty || !desc.isEmpty {
         //   NoteCoreDataService.coreData.createItems(title: title, desc: desc)
            NoteFireBaseService().addNoteFirstore(title: title, desc: desc)
            navigationController?.popViewController(animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
