//
//  MyEventsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/6/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase


class MyEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var currentUser:  AnyObject?
    var currentUserData: FIRDatabaseReference!
    
    var dataBaseRef: FIRDatabaseReference!
    var events = [Event]()
    var eventCount = 0
    
    
    @IBOutlet weak var myEventsTableView: UITableView!
    @IBOutlet weak var noEventsView: UILabel!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aivLoading.startAnimating()
        noEventsView.isHidden = true

        dataBaseRef = FIRDatabase.database().reference()
        
        self.currentUser = FIRAuth.auth()?.currentUser
        

        
        configureDatabase()
        
        
        aivLoading.isHidden = true
        
    
        
        
    }
    
    func configureDatabase(){
        
        self.dataBaseRef.child("Event").queryOrderedByKey().observe(.value, with: {(snap) in
            
            let eventSnap = snap.value as! [String: AnyObject]
            for (_,event) in eventSnap {
                if let eventCreator = event["uid"] as? String {
                        if (self.currentUser?.uid == eventCreator){
                            let eventPost = Event()
                            if let category = event["category"] as? String, let date = event["date"] as? String, let evDescription = event["evDescription"] as? String, let time = event["time"] as? String, let title = event["title"] as? String, let uid = event["uid"] as? String, let username = event["username"] as? String, let eventKey = event["eventKey"] as? String{
                                eventPost.category = category
                                eventPost.date = date
                                eventPost.evDescription = evDescription
                                eventPost.title = title
                                eventPost.time = time
                                eventPost.uid = uid
                                eventPost.username = username
                                eventPost.eventKey = eventKey
                                
                                self.events.append(eventPost)
                                print(self.events)
                            }
                        
                    }
                    self.myEventsTableView.reloadData()
                }
            }
            
        })
        dataBaseRef.removeAllObservers()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsTableViewCell", for: indexPath) as! MyEventsTableViewCell
        

        
        if (self.events[indexPath.row].evDescription.characters.count > 100){
            
            let index = self.events[indexPath.row].evDescription.index(self.events[indexPath.row].evDescription.startIndex, offsetBy: 100)
            
                cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
                cell.eventTitle.text = self.events[indexPath.row].title
                cell.eventDate.text = self.events[indexPath.row].date
                cell.eventDescription.text = self.events[indexPath.row].evDescription.substring(to: index) + "..."
        }
        
        else {
    
                cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
                cell.eventTitle.text = self.events[indexPath.row].title
                cell.eventDate.text = self.events[indexPath.row].date
                cell.eventDescription.text = self.events[indexPath.row].evDescription
            }
        

                return (cell)
        
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "myEventInfoSegue", sender: events[indexPath.row].eventKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myEventInfoSegue"){
        let eventIn = segue.destination as! EventInfoViewController
        eventIn.eventKey = sender as! String
        }
    }

    @IBAction func didPressHeart(_ sender: Any) {
        performSegue(withIdentifier: "interestSegue2", sender: nil)
    }

}
