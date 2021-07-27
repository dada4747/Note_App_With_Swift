//
//  DeletedViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit

class DeletedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "This is deleted  "
        view.backgroundColor = .systemPink
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "I'm a Deleted label"
        self.view.addSubview(label)
    }
}
