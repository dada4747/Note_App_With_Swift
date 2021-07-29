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

protocol HomeViewControllerDelegate : AnyObject {
    func didTappedMenuButton()
}

class HomeViewController: UIViewController {
    //list and grid
    var isListView = false
    var logout = UIBarButtonItem()
    var listView = UIBarButtonItem()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    private var coreDataModel = [ToDoListItem]()
    private var fireBaseModel = [NoteDataModel]()
    
    
    
    var totalPage = 1
    var currentPage = 1
    
    
    
   // private var
    var searching = false
//    var searchedItems = [ToDoListItem]()
    var searchedItemsFromdb = [NoteDataModel]()
    let checkFirebaseLogin = Auth.auth().currentUser?.uid
    let checkGoogleLogin = GIDSignIn.sharedInstance.currentUser?.userID
    let checkFacebookLogin = AccessToken.current?.userID
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    // multiple number to creat font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.060
    let relativeFontCellTitle:CGFloat = 0.023
    let relativeFontCellDescription:CGFloat = 0.015
    weak var delegate: HomeViewControllerDelegate?

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        
        
        
        print("*******************************retrive func call******************************")
        print("this is UID \(Auth.auth().currentUser?.email ?? "")")
     //   fetchFirebaseNote()
     //   fetchCoreDataNote()
        collectionView.reloadData()
        isUserLoggedIn()
        configureSearchController()
        configureCollectionView()
        title = "Note"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 17)!, .foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = Constants.greyColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTappedMenuButton))
        
         logout = UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(self.logOutButtonTapped(_:)))
         listView = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"), style: .done, target: self, action: #selector(listButtonTapped))
        navigationItem.rightBarButtonItems = [logout, listView]
        
        //Add Button
        let image = UIImage(named: "circle2.png")! as UIImage
        let addNoteButton:UIButton = UIButton(frame: CGRect(x: 320, y: 770, width: 60, height: 60))
        addNoteButton.layer.cornerRadius = addNoteButton.frame.width / 2
        addNoteButton.layer.masksToBounds = true
        addNoteButton.setImage(image, for: .normal)
        addNoteButton.addTarget(self, action:#selector(self.addButtonClicked), for: .touchUpInside)
        self.view.addSubview(addNoteButton)
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.frame = view.bounds
      //  fetchCoreDataNote()
        fetchFirebaseNote()

        collectionView.reloadData()
    }
    
    @objc func listButtonTapped() {
        if isListView {
            listView = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"), style: .done, target: self, action: #selector(listButtonTapped))
            isListView = false
        } else {
            listView = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .done, target: self, action: #selector(listButtonTapped))
            isListView = true
        }
        self.navigationItem.setRightBarButtonItems([logout, listView], animated: true)
        collectionView.reloadData()
    }
    //Add New Note Button
    @objc func addButtonClicked() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVc = storyBoard.instantiateViewController(withIdentifier: "AddNote") as! AddNoteViewController
        navigationController?.pushViewController(addNoteVc, animated: true)
 
    }
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

    //LogOut Button
//    @IBAction func logOutButtonTapped(_ sender: Any) {
//        if AccessToken.current != nil {
//            let loginManager = FBSDKLoginKit.LoginManager()
//            loginManager.logOut()
//            print("Logout Successful From facebook")
//            presentLogInScreen()
//        } else if (GIDSignIn.sharedInstance.currentUser?.userID) != nil {
//            GIDSignIn.sharedInstance.signOut()
//            print("Logout Successful From Google")
//            presentLogInScreen()
//        } else if checkFirebaseLogin != nil {
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//                    print("Logout Successful From Firebase")
//                    presentLogInScreen()
//            } catch let signOutError as NSError {
//                    print("Error signing out: %@", signOutError)
//            }
//        }
//    }
    //Menu Button
    @objc func didTappedMenuButton() {
        delegate?.didTappedMenuButton()
    }
    
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
    //fetch itemes from core data
    func fetchCoreDataNote() {
        NoteCoreDataService.coreData.getAllItem { models in
            self.coreDataModel = models
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    func fetchFirebaseNote() {
        DatabaseLayer.dblayerManeger.getNotes { model in
            self.fireBaseModel = model
            self.collectionView.reloadData()
        }
    }

    //collectionview configuration
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Constants.greyColor
    }

    func bestFrameSize() -> CGFloat {
        let frameHeight = self.view.frame.height
        let frameWidth = self.view.frame.width
        let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        return bestFrameSize
    }
    //check user is login
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
    
    //check user is logged in with facebook
    func checkUserISLogIn() {
        if AccessToken.current == nil {
            presentLogInScreen()
        }
   }
    //check user is logged in with  firebase
    func checkUserLoginWithFirebase() {
        if checkFirebaseLogin == nil {
           presentLogInScreen()
        }
    }
    //check user is loggin with google
    func checkUserIsLogInWithGoogle() {
        if GIDSignIn.sharedInstance.currentUser?.userID == nil {
            presentLogInScreen()
        }
    }
    //method for navigate to the Login View Controller
    func presentLogInScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as! ViewController
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    
    private func fetchData(page : Int, refresh : Bool = false){
    }
    
    
    
}

//extencsion for collection view delegate and data source
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            //return searchItems.count
            return searchedItemsFromdb.count
        } else {
//            return coreDataModel.count
            return fireBaseModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        //let thisNote: ToDoListItem!
        let thisNote: NoteDataModel
        if searching {
            //thisNote = searchItems[indexPath.row]
            thisNote = searchedItemsFromdb[indexPath.row]
            cell.labelTitle.text = thisNote.title
            cell.labelDetails.text = thisNote.desc
        } else {
            //thisNote = coreDataModel[indexPath.row]
            thisNote = fireBaseModel[indexPath.row]
            cell.labelTitle.text = thisNote.title
            cell.labelDetails.text = thisNote.desc
        }
        
        if !isListView {
            cell.layer.shadowColor = UIColor.white.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
        } else {
            cell.layer.shadowColor = Constants.greyColor.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
        }

        let closeFrameSize = bestFrameSize()
        cell.labelTitle.font = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
        cell.labelDetails.font = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       // var selectrow: Int?
        let item = fireBaseModel[indexPath.row] //let item = coreDataModel[indexPath.row]
        let sheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit Note", style: .default, handler: { _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "UpdateNote") as! UpdateViewController
           // selectrow = indexPath.row
            //viewController.item = selectrow
            viewController.myTitle = item.title
            viewController.myDesc = item.desc
            viewController.id = item.id
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            let itemId = item.id
            print("item id from button click............\(itemId)")
            NoteFireBaseService().deleteFromdb(item: itemId)//            NoteCoreDataService.coreData.delete(item: item)
            self?.fetchFirebaseNote()
//            self?.fetchCoreDataNote()
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    
    //*****************************************************

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("this is index path fro will display : \(indexPath)")
        if current_page < total_page && indexPath.row == cars.count - 1 {
                    current_page = current_page + 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.fetchData(page: self.current_page)
                    }
                }
    }

    
    
    
    
}

//extension for collectionview delegate flowlayout
extension HomeViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        if !isListView {
            let bounds = collectionView.bounds
            let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
            return CGSize(width: cellsize - 15   , height:  cellsize - 15  )
        } else {
            return CGSize(width: widthVal, height: 120)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
//extension for search controller updating and search bar delegate
extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            searching = true
            searchedItemsFromdb.removeAll() //searchedItems.removeAll()
            for item in fireBaseModel //coreDataModel
            {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||   //item.title?.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true   //item.desc?.lowercased().contains(searchText.lowercased()) == true
                {
                    searchedItemsFromdb.append(item) // searchedItems.append(item)
                }
            }
        }
        else
        {
            searching = false
            searchedItemsFromdb.removeAll()    // searchedItems.removeAll()
            searchedItemsFromdb = fireBaseModel      // searchedItems = coreDataModel
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedItemsFromdb.removeAll()  //searchedItems.removeAll()
        collectionView.reloadData()
    }
}

