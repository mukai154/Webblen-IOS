//
//  BlockedUsersViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/26/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class BlockedUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var blockTableView: UITableView!
    
    var currentUser: AnyObject?
    var dataBaseRef: DatabaseReference!
    var blockQ: DatabaseReference!
    var blockUid: String?
    var blockName: String?
    var blockList = [String]()
    var blockNameList = [String]()
    var toDelete: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBaseRef = Database.database().reference()
        
        self.currentUser = Auth.auth().currentUser

        
        blockQ = dataBaseRef.child("Users").child(self.currentUser!.uid).child("Blocked Users")
        
        self.blockQ.queryOrderedByValue().queryEqual(toValue: true).observe( .value, with: { (snap) in
            if let snapDict = snap.value as? [String:AnyObject]{
                for each in snapDict{
                    self.blockList.append(each.key)
                    print(self.blockList)
                }
            }
            self.configureDatabase()
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase(){
        for each in blockList{
            dataBaseRef.child("Users").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
            if let blockD = snapshot.value as? [String: AnyObject]{
                self.blockName = blockD["Name"] as? String
                self.blockNameList.append(self.blockName!)
                print(self.blockNameList)
            }
            self.blockTableView.reloadData()
          })
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockNameList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "blockCell")
        
        

        cell.textLabel?.text = self.blockNameList[indexPath.row]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            toDelete = self.blockList[indexPath.row]

            let alert = UIAlertController(title: "Unblock User", message: "Are you sure you want to unblock this user?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                self.blockQ.child(self.toDelete!).removeValue()
                self.blockList.remove(at: indexPath.row)
                self.blockNameList.remove(at: indexPath.row)
                self.performSegue(withIdentifier: "anotherSegue", sender: nil)
                
            })
            let alertAction2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            alert.addAction(alertAction2)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
