//
//  HelpAndFeedbackViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit

class HelpAndFeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "This is helpAndfeedback "
        view.backgroundColor = .systemGray
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "I'm a Help And Feedback label"
        self.view.addSubview(label)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
