//
//  AddNoteViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 25/07/21.
//

import UIKit

class AddNoteViewController: UIViewController {
    var isArchive  = false
    var isReminder = false
    var isNote     = true
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var titleTextField : UITextField!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var descTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.greyColor
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty || !desc.isEmpty {
            FireBaseDatabaseService.shared.writeToFirebase(title: title, description: desc, isRemainder: isReminder, isArchieved: isArchive, isNote: isNote)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
