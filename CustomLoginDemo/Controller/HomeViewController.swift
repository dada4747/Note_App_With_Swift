//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore

protocol HomeViewControllerDelegate : AnyObject {
    func didTappedMenuButton()
}
// MARK: - Search controller
class SearchController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let searchController        = UISearchController(searchResultsController: nil)
    var isSearching             = false
    var searchedNotes           = [NoteDataModel]()
    var notesModel              = [NoteDataModel]()
    let collectionView          : UICollectionView = {
        let collectionView      = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    // MARK: - ViewDidLoad - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUpSearchController
    func configureSearchController() {
        navigationItem.searchController = searchController
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "search"
        searchController.searchBar.searchTextField.textColor = .white
    }
    // MARK: - Update Search Reasult Method
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchText = searchController.searchBar.text!
        print(searchText)
        test(text: searchText)
        
        if !searchText.isEmpty {
            isSearching     = true
            searchedNotes.removeAll()
            for item in notesModel {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true {
                    searchedNotes.append(item)
                    }
            }
        }
        else {
            isSearching     = false
            searchedNotes.removeAll()
            searchedNotes   = notesModel
        }
        print("        collectionView.reloadData()")
        collectionView.reloadData()
    }
    // MARK: - TestDemo method
    func test(text: String) {
        
    }
    // MARK : - Search bar cancel method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchedNotes.removeAll()
        collectionView.reloadData()
    }
}

class HomeViewController: SearchController {
    
    // MARK: - Set Properties
    weak var delegate                       : HomeViewControllerDelegate?
    var loadingView                         : LoadingCollectionReusableView?
    let context                             = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var logout                              = UIBarButtonItem()
    var listView                            = UIBarButtonItem()
    var isListView                          = false
    var isLoading                           = false
    var hasMoreNotes:Bool                   = false
    let checkFirebaseLogin                  = Auth.auth().currentUser?.uid
    let checkGoogleLogin                    = GIDSignIn.sharedInstance.currentUser?.userID
    let checkFacebookLogin                  = AccessToken.current?.userID
    let relativeFontWelcomeTitle:CGFloat    = 0.045
    let relativeFontButton:CGFloat          = 0.060
    let relativeFontCellTitle:CGFloat       = 0.023
    let relativeFontCellDescription:CGFloat = 0.015
    
    // MARK: - @IBOutlet LogoutButton
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - viewDidLoad - HomeViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //**************************************************************************
        print("this is view did load method of home")
        //**************************************************************************
        fetchNotes()
        isUserLoggedIn()
        loadingReusableConfig()
        configureSearchController()
        configureCollectionView()
        addNoteButtonConfiguration()
        title = "Note"
        
        // MARK: - SetUp Navigation Controller Properties
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 17)!, .foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = Constants.greyColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTappedMenuButton))
         logout = UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(self.logOutButtonTapped(_:)))
         listView = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"), style: .done, target: self, action: #selector(listButtonTapped))
        navigationItem.rightBarButtonItems = [logout, listView]
        collectionView.reloadData()
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - ViewWillAppear method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        collectionView.frame = view.bounds
        print("this is view will apeare ")
        collectionView.reloadData()
    }
    
    // MARK: - Test_Method
    override func test(text: String) {
        
        print("this is home view controller... \(text)")
    }
    
    
    
    // MARK: - FetchNotes Method
    func fetchNotes() {
        FireBaseDatabaseService.shared.fetchNotes { notes in
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
    
    // MARK: - FetchMoreNotes Method
    func fetchMoreNotes() {
        FireBaseDatabaseService.shared.fetchMoreNotes { notes in
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
    
    // MARK: - SetUpLoadingReusableView
    func loadingReusableConfig() {
    let loadingReusableNib = UINib(nibName: "LoadingCollectionReusableView", bundle: nil)
    collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
    }
    
    // MARK: - SetUp AddNote UIButton
    func addNoteButtonConfiguration() {
        let image = UIImage(named: "circle2.png")! as UIImage
        let addNoteButton:UIButton          = UIButton(frame: CGRect(x: 320, y: 770, width: 60, height: 60))
        addNoteButton.layer.cornerRadius    = addNoteButton.frame.width / 2
        addNoteButton.layer.masksToBounds   = true
        addNoteButton.setImage(image, for: .normal)
        addNoteButton.addTarget(self, action:#selector(self.addButtonTapped), for: .touchUpInside)
        self.view.addSubview(addNoteButton)
    }

    // MARK: - SetUp List & Grid Button
    @objc func listButtonTapped() {
        if isListView {
            listView    = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"), style: .done, target: self, action: #selector(listButtonTapped))
            isListView  = false
        } else {
            listView    = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .done, target: self, action: #selector(listButtonTapped))
            isListView  = true
        }
        self.navigationItem.setRightBarButtonItems([logout, listView], animated: true)
        collectionView.reloadData()
    }

    // MARK: - @objc Action AddNote Button
    @objc func addButtonTapped() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVc                = storyBoard.instantiateViewController(withIdentifier: "AddNote") as! AddNoteViewController
        navigationController?.pushViewController(addNoteVc, animated: true)
    }
    
    // MARK: - @objc Action Logout Button
    @objc func logOutButtonTapped(_ sender: Any) {
        if AccessToken.current != nil {
            let loginManager = FBSDKLoginKit.LoginManager()
            loginManager.logOut()
            print("Logout Successful From facebook")
            presentLogInScreen()
        } else if (GIDSignIn.sharedInstance.currentUser?.userID) != nil {
            GIDSignIn.sharedInstance.signOut()
            print("Logout Successful From Google")
            presentLogInScreen()
        } else if checkFirebaseLogin != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                    print("Logout Successful From Firebase")
                    presentLogInScreen()
            } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
            }
        }
    }
    
    // MARK: - @objc Action MenuButton
    @objc func didTappedMenuButton() {
        delegate?.didTappedMenuButton()
    }

    // MARK: - SetUp Collectionview
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource       = self
        collectionView.delegate         = self
        collectionView.backgroundColor  = Constants.greyColor
    }
    
    // MARK: - Fram For Cells
    func bestFrameSize() -> CGFloat {
        let frameHeight     = self.view.frame.height
        let frameWidth      = self.view.frame.width
        let bestFrameSize   = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        return bestFrameSize
    }
    
    // MARK: - check user is login methods
    func isUserLoggedIn() {
        if checkFirebaseLogin != nil {
            checkUserLoginWithFirebase()
        } else if checkGoogleLogin != nil {
            checkUserIsLogInWithGoogle()
        } else if checkFacebookLogin != nil {
            checkUserISLogIn()
        } else {
            presentLogInScreen()
        }
    }
    // MARK: - check user is logged in with facebook
    func checkUserISLogIn() {
        if AccessToken.current == nil {
            presentLogInScreen()
        }
   }
    // MARK: - check user is logged in with  firebase
    func checkUserLoginWithFirebase() {
        if checkFirebaseLogin == nil {
           presentLogInScreen()
        }
    }
    
    // MARK: - check user is loggin with google
    func checkUserIsLogInWithGoogle() {
        if GIDSignIn.sharedInstance.currentUser?.userID == nil {
            presentLogInScreen()
        }
    }
    // MARK: - Navigate to LoginViewController
    func presentLogInScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController           = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as! ViewController
        let nav                      = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle   = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
// MARK: extension for collection view delegate and data source
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - numberOfSection Delegate method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - numberOfitemsInSection Delegate method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("home view controller section")
        if isSearching {
            return searchedNotes.count
        } else {
            return notesModel.count
        }
    }

    // MARK: - CellForItemAt method dataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        let thisNote: NoteDataModel
        if isSearching {
            thisNote                 = searchedNotes[indexPath.row]
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
    
    // MARK: - didSelectItemAt method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item    =    notesModel[indexPath.row]
        let title   =    item.title
        let desc    =    item.desc
        let itemId  =    item.id
        // MARK: - Alert Title
        let sheet   =    UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        // MARK: - Alert option Cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // MARK: - Alert option Edit Note
        sheet.addAction(UIAlertAction(title: "Edit Note", style: .default, handler: { _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "UpdateNote") as! UpdateViewController
            viewController.myTitle      = title//item.title
            viewController.myDesc       = desc//item.desc
            viewController.id           = itemId//item.id
            viewController.isNote       = true
            viewController.isReminder   = false
            viewController.isArchive    = false
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        // MARK: - Alert option Archieve
        sheet.addAction(UIAlertAction(title: "Archive", style: .default, handler: { [weak self] _ in
            let isArchive   = true
            let isReminder  = false
            let isNote      = false
            FireBaseDatabaseService.shared.updateDataToFirebase(note: itemId, title: item.title, desc: item.desc, isArchive: isArchive, isNote: isNote, isReminder: isReminder)
            self?.fetchNotes()
        }))
        // MARK: - Alert option Delete Notes
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            FireBaseDatabaseService.shared.deleteDataToFirebase(note: itemId)
            self?.fetchNotes()
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - willDisplay method for Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(hasMoreNotes)
        if( hasMoreNotes && indexPath.row == notesModel.count-1  ) {
            fetchMoreNotes()
        } else {
            isLoading = true
        }
    }
  
    // MARK: - method of reusable view - Loading - footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 60)
        }
    }
    
    // MARK: - method of reusable view - Loading view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingCollectionReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    // MARK: - method of reusable view - Loading - Animation
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    // MARK: - method of reusable view - Loading - stop Animation
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}
// MARK: - extension for collectionview delegate flowlayout
extension HomeViewController : UICollectionViewDelegateFlowLayout {
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
