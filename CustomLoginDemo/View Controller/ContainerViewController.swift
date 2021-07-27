//
//  ContainerViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import FBSDKLoginKit

class ContainerViewController: UIViewController {
    enum MenuState {
        case opened
        case closed
    }
    private var menuState: MenuState = .closed
    
  //for sidebar.......
    let menuVc = MenuViewController()
    let homeVc = HomeViewController()
    var navVc: UINavigationController?
    lazy var reminderVc = ReminderViewController()
    lazy var archiveVc = ArchiveViewController()
    lazy var deletedVc = DeletedViewController()
    lazy var settingVc = SettingViewController()
    lazy var helpDeskVc = HelpAndFeedbackViewController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
       addchildVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //for side bar menu
    private func addchildVCs() {
        //Menu
        menuVc.delegate = self
        addChild(menuVc)
        view.addSubview(menuVc.view)
        menuVc.didMove(toParent: self)
        
        //Home
        homeVc.delegate = self
        let navVc = UINavigationController(rootViewController: homeVc)
        addChild(navVc)
        view.addSubview(navVc.view)
        navVc.didMove(toParent: self)
        self.navVc = navVc
    }
}

//sidebar----------
extension ContainerViewController: HomeViewControllerDelegate {
    func didTappedMenuButton() {
        toogleMenu(completion: nil)
    }
    
    func toogleMenu(completion: (() -> Void)?){
        //animate the menu
        switch menuState {
        case .closed:
            //open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut){
                self.navVc?.view.frame.origin.x = self.homeVc.view.frame.size.width - 100
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            //c;lose it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut){
                self.navVc?.view.frame.origin.x = 0
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toogleMenu(completion: nil)
        switch menuItem {
            case .notes:
                print("Note / Home Controller....")
                self.resetToNotes()
            case .reminders:
                print("Reminder View Controller")
                //add reminder child
                self.addReminder()
            case .archive:
                print("Archive Controller")
                //add reminder
                self.addArchive()
            case .deleted:
                print("Deleted Controller")
                self.addDeleted()
            case .setting:
                print("Setting Controller")
                self.addSetting()
            case .helpFeedback:
                print("Help and FeedBack Controller")
                self.addHelpDesk()
        }
    }
        
    func resetToNotes() {
        reminderVc.view.removeFromSuperview()
        reminderVc.didMove(toParent: nil)
        homeVc.title = "Note"
        
        archiveVc.view.removeFromSuperview()
        archiveVc.didMove(toParent: nil)
        homeVc.title = "Note"
        
        deletedVc.view.removeFromSuperview()
        deletedVc.didMove(toParent: nil)
        homeVc.title = "Note"
        
        settingVc.view.removeFromSuperview()
        settingVc.didMove(toParent: nil)
        homeVc.title = "Note"
        
        helpDeskVc.view.removeFromSuperview()
        helpDeskVc.didMove(toParent: nil)
        homeVc.title = "Note"
        
    }
    
    func addReminder() {
        let vc = reminderVc
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVc)
        homeVc.title = vc.title
    }
    
    func addArchive() {
        let vc = archiveVc
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        homeVc.title = vc.title
    }
    
    func addDeleted() {
        let vc = deletedVc
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        homeVc.title = vc.title
    }
    
    func addSetting() {
        let vc = settingVc
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        homeVc.title = vc.title
    }
    
    func addHelpDesk() {
        let vc = helpDeskVc
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        homeVc.title = vc.title

    }
}
