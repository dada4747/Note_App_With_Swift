//
//  AddReminderViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 03/08/21.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet var titleField:UITextField!
    @IBOutlet var descField:UITextView!
    @IBOutlet var datePicker:UIDatePicker!
    
    public var complition: ((String, String, Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.greyColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didSaveButton))
    }
    
    @objc func didSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let descText = descField.text, !descText.isEmpty {
            let targetDate = datePicker.date
            complition?(titleText, descText, targetDate )
            print("note is added to ")
            FireBaseDatabaseService.shared.writeToFirebase(title: titleText, description: descText, isRemainder: true, isArchieved: false, isNote: true)
        }
    }
}
