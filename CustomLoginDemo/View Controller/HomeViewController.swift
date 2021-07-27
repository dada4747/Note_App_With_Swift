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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    private var models = [ToDoListItem]()
    var searching = false
    var searchedItems = [ToDoListItem]()
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
//        NoteFireStore().userUid()
        //****************************************************************************
        
        print("****************************************************************************")
        print(" this is uid \(Auth.auth().currentUser?.uid ?? "")")
        print("this is UID \(Auth.auth().currentUser?.email ?? "")")
        //****************************************************************************
        fetchItem()
        collectionView.reloadData()
        //getAllItem()
        isUserLoggedIn()
        configureSearchController()

        view.addSubview(collectionView)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       // collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .gray
      //  myCollectionView.delegate = self
      //  myCollectionView.dataSource = self
     //   title = "Search"
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
        //title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTappedMenuButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "escape"), style: .done, target: self, action: #selector(self.logOutButtonTapped(_:)))

        let button:UIButton = UIButton(frame: CGRect(x: 320, y: 770, width: 60, height: 60))
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .black
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action:#selector(self.addButtonClicked), for: .touchUpInside)
        self.view.addSubview(button)

    }

    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.frame = view.bounds
        getAllItem()
        collectionView.reloadData()
        // self.navigationController?.isNavigationBarHidden = true
    }
    func fetchItem() {
        CoreData.coreData.getAllItem { models in
            print("in fetch item================================")
            self.models = models
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
       
    }
    
    
    
    @objc func addButtonClicked() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVc = storyBoard.instantiateViewController(withIdentifier: "AddNote") as! AddNoteViewController
        navigationController?.pushViewController(addNoteVc, animated: true)
 
    }
    
    //Action button for logout
    @IBAction func logOutButtonTapped(_ sender: Any) {
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
    
    //*************************************
    @objc func didTappedMenuButton() {
        delegate?.didTappedMenuButton()
        
    }
    //**************************************
    
    func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "search"
    }

    func bestFrameSize() -> CGFloat {
        let frameHeight = self.view.frame.height
        let frameWidth = self.view.frame.width
        let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        return bestFrameSize
    }
    
    //core data functionallty
    func getAllItem(){

        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch  {
            //error
        }
    }
    
//    func createItems(title: String, desc: String){
//        let newItem = ToDoListItem(context: context)
//        newItem.title = title
//        newItem.desc = desc
//        do {
//            try context.save()
//            getAllItem()
//            print("item is created sajlkjslkf")
//        } catch  {
//            print("unable to create note ")
//        }
//    }
    
    func delete(item: ToDoListItem){
        context.delete(item)
        do {
            try context.save()
            getAllItem()
        } catch  {
            print("item anable to delete ")
        }
    }
    
//    func updateItem(item: ToDoListItem, newtitle: String, newDesc: String) {
//        item.title = newtitle
//        item.desc = newDesc
//        do {
//            try context.save()
//            getAllItem()
//        } catch  {
//            print("unable to update note")
//        }
//    }

    func isUserLoggedIn() {
        print("user logged in from firebase ************** \(String(describing: checkFirebaseLogin)) **************")
        print("user logged in from google ************** \(String(describing: checkGoogleLogin)) **************")
        print("user logged in from facebook ************ \(String(describing: checkFacebookLogin)) *****************")
        
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
    
    //method for navigate to the viewController 
    func presentLogInScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as! ViewController
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedItems.count
        } else {
            return models.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        let thisNote: ToDoListItem!
        if searching {
            thisNote = searchedItems[indexPath.row]
            cell.labelTitle.text = thisNote.title
            cell.labelDetails.text = thisNote.desc
        } else {
            thisNote = models[indexPath.row]
            cell.labelTitle.text = thisNote.title
            cell.labelDetails.text = thisNote.desc
        }

        //let thisElement = colectionArr[indexPath.item]
        let cellIndex = indexPath.item
        let closeFrameSize = bestFrameSize()
        //cell.backgroundColor = .red
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = UIColor.gray
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var selectrow: Int?
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Choose Option",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit Note", style: .default, handler: { _ in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "UpdateNote") as! UpdateViewController
            let nav = UINavigationController(rootViewController: viewController)
            selectrow = indexPath.row
            viewController.item = selectrow
            viewController.myTitle = item.title
            viewController.myDesc = item.desc
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            CoreData.coreData.delete(item: item)
            //self!.getAllItem()
            self?.fetchItem()
           
            
            //self?.delete(item: item)
//            CoreData().delete(item: item)
            
        }))
        present(sheet, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
        return CGSize(width: cellsize - 15   , height:  cellsize - 15  )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            //searchText.lowercased())
            searching = true
            searchedItems.removeAll()
            //print("searched item\(searchedItem)")
            for item in models
            {
                if item.title?.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc?.lowercased().contains(searchText.lowercased()) == true
                {
                    searchedItems.append(item)
                }
            }
            print(searchedItems)
        }
        else
        {
            searching = false
            searchedItems.removeAll()
            searchedItems = models
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedItems.removeAll()
        collectionView.reloadData()
    }
}

