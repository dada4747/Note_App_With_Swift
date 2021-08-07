//
//  ArchiveViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 20/07/21.
//

import UIKit
import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore

class ArchiveViewController: SearchController {
    
    // MARK: - Properties
    var loadingView                         : LoadingCollectionReusableView?
    let leadingScreensForBatching:CGFloat   = 3.0
    var isLoading                           = false
    var hasMoreNotes                        = false
    var isListView                          = false
    let relativeFontWelcomeTitle:CGFloat    = 0.045
    let relativeFontButton:CGFloat          = 0.060
    let relativeFontCellTitle:CGFloat       = 0.023
    let relativeFontCellDescription:CGFloat = 0.015
    
    // MARK: - viewDidLoad - ArchiveViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //**************************************************************************
                print("this is view did load method of home")
        fetchArchiveNotes()
        //**************************************************************************
        loadingReusableConfig()
        collectionView.reloadData()
        configureSearchController()
        configureCollectionView()
        title = "Archive"
    }
    
    // MARK: - viewDidLayoutSubviews Archive
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - viewWillAppear - Archive
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.frame = view.bounds
        print("this is view will appear for archive ")
        fetchArchiveNotes()
        collectionView.reloadData()
    }
    // MARK: - Setup LoadingReausable View
    func loadingReusableConfig() {
    let loadingReusableNib = UINib(nibName: "LoadingCollectionReusableView", bundle: nil)
    collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
    }
    
    
    // TODO: - test method
   override func test(text: String) {
        
        print("this is Archive View controller... \(text)")
    }
    
    // MARK: - Fetch Archieved notes
    func fetchArchiveNotes() {
        FireBaseDatabaseService.shared.fetchArchive { notes in
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
    
    // MARK: - FetchMoreArchived notes method
    func fetchMoreArchiveNotes(){
        FireBaseDatabaseService.shared.fetchMoreArchive { notes in
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
    
    // MARK: -SetUp collection view
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource       = self
        collectionView.delegate         = self
        collectionView.backgroundColor  = Constants.greyColor
    }
    
    // MARK: - framsize of cell
    func bestFrameSize() -> CGFloat {
        let frameHeight     = self.view.frame.height
        let frameWidth      = self.view.frame.width
        let bestFrameSize   = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        return bestFrameSize
    }
}
// MARK: - extension for collection view delegate and data source
extension ArchiveViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("seraching is printed herer...\(isSearching)")
        print(searchedNotes.count)
        if isSearching {
            return searchedNotes.count
        } else {
            return notesModel.count
        }
    }
    
    // MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                     = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        let thisNote                 : NoteDataModel
        if isSearching {
            thisNote    = searchedNotes[indexPath.row]
            cell.labelTitle.text     = thisNote.title
            cell.labelDetails.text   = thisNote.desc
        } else {
            thisNote                 = notesModel[indexPath.row]
            cell.labelTitle.text     = thisNote.title
            cell.labelDetails.text   = thisNote.desc
        }
        if !isListView {
            cell.layer.shadowColor   = UIColor.white.cgColor
            cell.layer.shadowOffset  = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius  = 2.0
            cell.layer.shadowOpacity = 1.0
        } else {
            cell.layer.shadowColor   = Constants.greyColor.cgColor
            cell.layer.shadowOffset  = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius  = 2.0
            cell.layer.shadowOpacity = 1.0
        }

        let closeFrameSize           = bestFrameSize()
        cell.labelTitle.font         = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
        cell.labelDetails.font       = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)
        return cell
    }
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let note                     = notesModel[indexPath.row]
        let title                    = note.title
        let desc                     = note.desc
        let noteId                   = note.id
        
        // MARK: - Alert Title
        let sheet                    = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        // MARK: - Alert option - Cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // MARK: - Alert option - UnArchive
        sheet.addAction(UIAlertAction(title: "Un-Archive", style: .default, handler: { _ in
            let isArchive            = false
            let isReminder           = false
            let isNote               = true
            FireBaseDatabaseService.shared.updateDataToFirebase(note: noteId, title: title, desc: desc, isArchive: isArchive, isNote: isNote, isReminder: isReminder)
            self.fetchArchiveNotes()
           // self.collectionView.reloadData()

        }))
        
        // MARK: - Alert option Edit Archive
        sheet.addAction(UIAlertAction(title: "Edit Note", style: .default, handler: { _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController           = storyBoard.instantiateViewController(withIdentifier: "updateFromArchive") as! UpdateArchiveViewController
            viewController.myTitle       = title
            viewController.myDesc        = desc
            viewController.id            = noteId
            viewController.isNote        = false
            viewController.isReminder    = false
            viewController.isArchive     = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        // MARK: - Alert option Delte Archive
        sheet.addAction(UIAlertAction(title: "Delete Archive", style: .destructive, handler: { [weak self] _ in

            FireBaseDatabaseService.shared.deleteDataToFirebase(note: noteId)
            print("item id from button click............\(noteId)")
            print("delelte from archiv ")
            self?.fetchArchiveNotes()
            //self?.collectionView.reloadData()
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - willDisplay- Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if( hasMoreNotes && indexPath.row == notesModel.count-1  ) {
          fetchMoreArchiveNotes()
        } else {
            isLoading = true
        }
    }
    
    // MARK: - referenceSizeForFooterInSection - Loading Seze
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }

    }
    
    // MARK: - viewForSupplementaryElementOfKind - loading view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView              = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingCollectionReusableView
            loadingView                  = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    // MARK: - willDisplaySupplementaryView - loading view
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    // MARK: - didEndDisplayingSupplementaryView - loading view
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - extension for collectionview delegate flowlayout
extension ArchiveViewController : UICollectionViewDelegateFlowLayout {
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
