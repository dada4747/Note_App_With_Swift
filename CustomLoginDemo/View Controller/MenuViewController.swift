//
//  MenuViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 19/07/21.
//

import UIKit
protocol MenuViewControllerDelegate:AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    weak var delegate: MenuViewControllerDelegate?
    
        enum MenuOptions: String, CaseIterable {
        case notes = "Notes"
        case reminders = "Reminders"
        case archive = "Archive"
        case deleted = "Deleted"
        case setting = "Setting"
        case helpFeedback = "Help And Feedback"
        
        var imageName: String {
            switch self {
            
            case .notes:
                return "note.text"
            case .reminders:
                return "stopwatch"
            case .archive:
                return "archivebox"
            case .deleted:
                return "trash"
            case .setting:
                return "gear"
            case .helpFeedback:
                return "questionmark.circle"
            }
                
        }
    }
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    let greyColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = greyColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = greyColor
        cell.contentView.backgroundColor = greyColor
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}
