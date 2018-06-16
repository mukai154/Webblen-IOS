//
//  GroupsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/27/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert
import NVActivityIndicatorView

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupsTable: UITableView!
    
    //Database Variables
    var database = Firestore.firestore()
    var webblenGroups = [webblenGroup]()
    var currentUser = Auth.auth().currentUser
    var currentUserGroupKeys:[String]?
    
    //UI
    var btnTintColor = UIColor(red: 83/255, green: 92/255, blue: 104/255, alpha: 0.8)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Activity indicator starts
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: btnTintColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        //Firebase
        loadGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroups(){
        let userRef = database.collection("users").document((currentUser?.uid)!)
        
        //User Data
        userRef.getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            } else if error != nil{
                self.showBlurAlert(title: "Server Error", message: "There was an error connecting to our server")
            } else {
                self.currentUserGroupKeys = snapshot?.data()!["groups"] as? [String]
                
                if self.currentUserGroupKeys != nil {
                    for groupName in self.currentUserGroupKeys! {
                        let groupRef = self.database.collection("groups").document(groupName)
                        groupRef.getDocument(completion: {(snapshot, error) in
                            if !(snapshot?.exists)! {
                                
                            } else if error != nil{
                                self.showBlurAlert(title: "Server Error", message: "There was an error connecting to our server")
                            } else {
                                let groupData = snapshot?.data()!
                                let userGroup = webblenGroup(groupName: groupData!["groupName"] as! String,
                                                             members: groupData!["members"] as! [String],
                                                             invited: groupData!["invited"] as! [String],
                                                             suggestedEvents: groupData!["suggestedEvents"] as! [String],
                                                             totalWebPower: groupData!["totalWebPower"] as! Double,
                                                             chatID: groupData!["chatID"] as! String)
                                
                                self.webblenGroups.append(userGroup)
                                self.groupsTable.reloadData()
                            }
                        })
                    }
                }
            }
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.webblenGroups.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupsTable.dequeueReusableCell(withIdentifier: "groupCell")
        let group = self.webblenGroups[indexPath.row]
        let groupName = group.groupName
        let members = group.members
        
        
        let groupNameLbl = cell?.viewWithTag(1) as! UILabel
        groupNameLbl.text = groupName
        let userPic1 = cell?.viewWithTag(2) as! UIImageViewX
        let userPic2 = cell?.viewWithTag(3) as! UIImageViewX
        let userPic3 = cell?.viewWithTag(4) as! UIImageViewX
        let userPic4 = cell?.viewWithTag(5) as! UIImageViewX
        let userPic5 = cell?.viewWithTag(6) as! UIImageViewX
        let additionalUsers = cell?.viewWithTag(7) as! UILabel
        let activityIndicator = cell?.viewWithTag(8) as! UIActivityIndicatorView
        
        var additionalCount = 0
        
        for member in members {
            let memberKey = member
            if memberKey != (currentUser?.uid)! {
                self.database.collection("users").document(memberKey).getDocument(completion: {(snapshot, error) in
                    if (snapshot?.exists)! {
                        let imageURL = snapshot?.data()!["profile_pic"] as! String
                        if imageURL != nil || imageURL != "" {
                            let url = NSURL(string: imageURL)
                            if additionalCount == 0 {
                                userPic1.sd_setImage(with: url! as URL)
                                userPic1.clipsToBounds = true
                                userPic1.isHidden = false
                            } else if additionalCount == 1 {
                                userPic2.sd_setImage(with: url! as URL)
                                userPic2.clipsToBounds = true
                                userPic2.isHidden = false
                            } else if additionalCount == 3 {
                                userPic3.sd_setImage(with: url! as URL)
                                userPic3.clipsToBounds = true
                                userPic3.isHidden = false
                            } else if additionalCount == 4 {
                                userPic4.sd_setImage(with: url! as URL)
                                userPic4.clipsToBounds = true
                                userPic4.isHidden = false
                            } else if additionalCount == 5 {
                                userPic5.sd_setImage(with: url! as URL)
                                userPic5.clipsToBounds = true
                                userPic5.isHidden = false
                            }
                            
                            if let lastGroup = self.webblenGroups.last {
                                if lastGroup.groupName == groupName {
                                    self.loadingView.stopAnimating()
                                    self.groupsTable.isHidden = false
                                }
                            }
                            
                            additionalCount += 1
                            
                        }
                    } else {
                        //Firebase Error
                    }
                })
            }
        }
        
        if additionalCount > 5 {
            additionalUsers.text = "+" + String(additionalCount)
            additionalUsers.isHidden = false
        }
        activityIndicator.isHidden = true
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatSegue", sender: self.webblenGroups[indexPath.row].chatID)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "chatSegue"){
            let messagesViewController = segue.destination as! MessagesViewController
            messagesViewController.chatID = sender as! String
        }
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressNew(_ sender: Any) {
    }
    
}
