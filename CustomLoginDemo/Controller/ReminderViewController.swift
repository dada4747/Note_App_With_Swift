//
//  ReminderViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore
import UserNotifications

class ReminderViewController: SearchController {
    var loadingView                         : LoadingCollectionReusableView?
    let leadingScreensForBatching:CGFloat   = 3.0
    var isListView                          = false
    var isLoading                           = false
    var hasMoreNotes:Bool                   = false
    
    // multiple number to creat font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat    = 0.045
    let relativeFontButton:CGFloat          = 0.060
    let relativeFontCellTitle:CGFloat       = 0.023
    let relativeFontCellDescription:CGFloat = 0.015
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("reminder viw did load")
        title =  "Reminders"
        fetchReminderNotes()
        configureCollectionView()
        addRemindButton()
        loadingReusableConfig()
        collectionView.reloadData()
    }

    func addRemindButton() {
        let image                           = UIImage(named: "remind1.png")! as UIImage
        let addNoteButton:UIButton          = UIButton(frame: CGRect(x: 300, y: 740, width: 80, height: 80))
        addNoteButton.layer.cornerRadius    = addNoteButton.frame.width / 2
        addNoteButton.layer.masksToBounds   = true
        addNoteButton.setImage(image, for: .normal)
        addNoteButton.addTarget(self, action:#selector(self.addRemiderClick), for: .touchUpInside)
        self.view.addSubview(addNoteButton)
    }
    
    func loadingReusableConfig() {
    let loadingReusableNib                  = UINib(nibName: "LoadingCollectionReusableView", bundle: nil)
    collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
    }
    
    @objc func addRemiderClick() {
        let storyBoard: UIStoryboard                   = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVc                                  = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.addReminderController) as! AddReminderViewController
        addNoteVc.title                                = "AddNewReminder"
        addNoteVc.navigationItem.largeTitleDisplayMode = .never
        addNoteVc.complition                           = { title, desc, date in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                    //save note to firebase database with date and use func update okay?
                let content     = UNMutableNotificationContent()
                content.title   = title
                content.sound   = .default
                content.body    = desc
                
                let targetDate  = date
                let trigger     = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request     = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("something went wrong")
                    }
                }
            }
        }
        navigationController?.pushViewController(addNoteVc, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.frame = view.bounds
        print("this is view will appear for reminder ")
        fetchReminderNotes()
        collectionView.reloadData()
    }
    
    func fetchReminderNotes() {
        FireBaseDatabaseService.shared.fetchReminderNotes { notes in
            if notes.count < 10 {
                self.hasMoreNotes = false
            }
            else {
                self.hasMoreNotes = true
            }
            self.notesModel       = notes
            self.collectionView.reloadData()
        }
        
    }
    func fetchMoreReminderNotes(){
        FireBaseDatabaseService.shared.fetchMoreReminderNotes { notes in
            if notes.count < 10 {
                self.hasMoreNotes = false
            }
            else {
                self.hasMoreNotes = true
            }
            self.notesModel.append(contentsOf: notes)
            self.collectionView.reloadData()
        }
    }
    
    
    func demoTestReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound],completionHandler: {  success, error in
            if success {
                self.scheduleReminder()
            } else if error != nil {
                
                print("error Occure")
            }
        })
        }
    
    func scheduleReminder() {
        let content     = UNMutableNotificationContent()
        content.title   = "Hello World"
        content.sound   = .default
        content.body    = "My Reminder Body,My Reminder Body,My Reminder Body,My Reminder Body"
        
        let targetDate  = Date().addingTimeInterval(10)
        let trigger     = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request     = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("something went wrong")
            }
        }
    }
    
    //collectionview configuration
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource       = self
        collectionView.delegate         = self
        collectionView.backgroundColor  = Constants.greyColor
    }

    func bestFrameSize() -> CGFloat {
        let frameHeight                 = self.view.frame.height
        let frameWidth                  = self.view.frame.width
        let bestFrameSize               = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        return bestFrameSize
    }
  
}

//extencsion for collection view delegate and data source
extension ReminderViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            //return searchItems.count
            return searchedNotes.count
        } else {
            //return coreDataModel.count
            return notesModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                      = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        let thisNote                  : NoteDataModel
        if isSearching {
            thisNote                  = searchedNotes[indexPath.row]
            cell.labelTitle.text      = thisNote.title
            cell.labelDetails.text    = thisNote.desc
        } else {
            thisNote                  = notesModel[indexPath.row]
            cell.labelTitle.text      = thisNote.title
            cell.labelDetails.text    = thisNote.desc
        }
        if !isListView {
            cell.layer.shadowColor    = UIColor.white.cgColor
            cell.layer.shadowOffset   = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius   = 2.0
            cell.layer.shadowOpacity  = 1.0
        } else {
            cell.layer.shadowColor    = Constants.greyColor.cgColor
            cell.layer.shadowOffset   = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius   = 2.0
            cell.layer.shadowOpacity  = 1.0
        }

        let closeFrameSize            = bestFrameSize()
        cell.labelTitle.font          = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
        cell.labelDetails.font        = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = notesModel[indexPath.row]
        let itemId = item.id
        let sheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Delete Remider Note", style: .destructive, handler: { [weak self] _ in
            print("item id from button click............\(itemId)")
            print("delelte from archiv ")
            FireBaseDatabaseService.shared.deleteDataToFirebase(note: itemId)
            self?.fetchReminderNotes()
            //self?.collectionView.reloadData()
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if( hasMoreNotes && indexPath.row == notesModel.count-1  ) {
          fetchMoreReminderNotes()
        } else {
            isLoading = true
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView                 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingCollectionReusableView
            loadingView                     = aFooterView
            loadingView?.backgroundColor    = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }

    }
}

//extension for collectionview delegate flowlayout
extension ReminderViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightVal       = self.view.frame.height
        let widthVal        = self.view.frame.width
        if !isListView {
            let bounds      = collectionView.bounds
            let cellsize    = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
            return CGSize(width: cellsize - 15   , height:  cellsize - 15  )
        } else {
            return CGSize(width: widthVal - 15 , height: 120)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
