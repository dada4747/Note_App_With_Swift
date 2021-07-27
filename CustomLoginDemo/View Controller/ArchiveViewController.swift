//
//  ArchiveViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit

class ArchiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "This is Archives "
        view.backgroundColor = .systemBlue
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "I'm a Archive label"
        self.view.addSubview(label)
    }
}
