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
    var currentUserData: DatabaseReference!
    
    var dataBaseRef: DatabaseReference!
    var events = [Event]()
    var eventCount = 0
    
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        dataBaseRef = Database.database().reference()
        
        self.currentUser = Auth.auth().currentUser
        

        
        configureDatabase()
        
        
        
        
    
        
        
    }
    
    func configureDatabase(){
        
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

    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
