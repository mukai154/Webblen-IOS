//
//  SearchViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    //UI
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchIconImg: UIImageView!
    @IBOutlet weak var searchLbl: UILabel!
    @IBOutlet weak var noResultsLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //Normal Search vs Group Creation
    var normalSearch = false
    var searchResult = [webblenUserBasicData]()

    var isCreatingGroup = false
    var invitedUsers = [webblenUserBasicData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //** SEARCH BAR
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = .white
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResult.removeAll()
        self.resultsTableView.isHidden = true
        let text = searchText
        
        if text.isEmpty {
            searchIconImg.isHidden = false
            searchLbl.isHidden = false
            noResultsLbl.isHidden = true
        } else {
            searchIconImg.isHidden = true
            searchLbl.isHidden = true
            
            let userCollection = dataBase.collection("users").whereField("username", isEqualTo: text.lowercased())
            userCollection.getDocuments(completion: {(snapshot, error) in
                if error != nil {
                    print("error in finding events")
                } else if (snapshot?.isEmpty)! {
                    self.noResultsLbl.text = "No Results for... '" + text + "'"
                    self.noResultsLbl.isHidden = false
                } else {
                    self.noResultsLbl.isHidden = true
                    self.activityIndicator.isHidden = false
                    for document in (snapshot?.documents)! {
                        let username = document.data()["username"] as? String
                        let profile_pic = document.data()["profile_pic"] as? String
                        let uid = document.data()["uid"] as? String
                        
                        if profile_pic != nil {
                            let searchedUser = webblenUserBasicData(username: username!, profile_pic: profile_pic!, uid: uid!)
                            self.searchResult.append(searchedUser)
                        } else {
                            let searchedUser = webblenUserBasicData(username: username!, profile_pic: "", uid: uid!)
                            self.searchResult.append(searchedUser)
                        }
                        
                        self.resultsTableView.reloadData()
                        self.resultsTableView.isHidden = false
                        self.activityIndicator.isHidden = true
                    }
                }
                
            })
        }
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        let usernameResult = "@" + self.searchResult[indexPath.row].username
        let usernamePicPath = self.searchResult[indexPath.row].profile_pic
        
        let usernameLbl = cell?.viewWithTag(1) as! UILabel
        usernameLbl.text = usernameResult
        let userPic = cell?.viewWithTag(2) as! UIImageViewX
        let imageActivityIndicator = cell?.viewWithTag(3) as! UIActivityIndicatorView
        let inviteUserBtn = cell?.viewWithTag(4) as! UIButtonX
        let viewUserBtn = cell?.viewWithTag(5) as! UIButtonX
        if usernamePicPath != "" {
            let url = NSURL(string: usernamePicPath)
            userPic.sd_setImage(with: url! as URL)
            imageActivityIndicator.isHidden = true
        } else {
            userPic.image = UIImage(named: "defaultUserPic")
            imageActivityIndicator.isHidden = true
        }
        userPic.clipsToBounds = true
        userPic.isHidden = false
        
//        inviteUserBtn.addTarget(self, action: "inviteBtnClicked:", for: .touchUpInside)
//        viewUserBtn.addTarget(self, action: "viewUserBtnClicked:", for: .touchUpInside)
        
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectUser(uid: searchResult[indexPath.row].uid)
    }
    
    func selectUser(uid: String){
        performSegue(withIdentifier: "userInfoSegue", sender: uid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userInfoSegue"){
            let userInfoController = segue.destination as! UserInfoViewController
            userInfoController.selectedUserUID = sender as! String
        }
    }
    
    

}
