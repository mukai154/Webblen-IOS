//
//  MyEventsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/6/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView


class MyEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var currentUser = Auth.auth().currentUser
    var currentUserData: DatabaseReference!
    var username: String?
    
    var dataBaseRef: DatabaseReference!
    var database = Firestore.firestore()
    var events = [Event]()
    var webblenEvents = [webblenEvent]()
    var aeventCount = 0
    
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
       var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myEventsTableView.alpha = 0
        myEventsTableView.isUserInteractionEnabled = false

        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-147), y: (yAxis-135), width: 300, height: 300)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 0.7), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        dataBaseRef = Database.database().reference()
        
        configureDatabase()
        
    
        
    }
    
    func configureDatabase(){
        let userRef = database.collection("users").document((currentUser?.uid)!)
        userRef.getDocument(completion: {(document, error) in
            if let document = document {
                let eventCreator = (document.data()!["username"] as? String)
                let eventRef = self.database.collection("events").getDocuments(completion: {(snapshot, error) in
                    if let error = error {
                        print("error in finding events")
                    }
                    else {
                        for event in snapshot!.documents {
                            let author = (event.data()["author"] as? String)!
                            if eventCreator == author {
                                var createdEvent = webblenEvent(
                                    title: event.data()["title"] as! String,
                                    address: event.data()["address"] as! String,
                                    categories: event.data()["categories"] as! [String],
                                    date: event.data()["date"] as! String,
                                    description: event.data()["description"] as! String,
                                    eventKey: event.data()["eventKey"] as! String,
                                    lat: event.data()["lat"] as! Double,
                                    lon: event.data()["lon"] as! Double,
                                    paid: event.data()["paid"] as! Bool,
                                    pathToImage: event.data()["pathToImage"] as! String,
                                    radius: event.data()["radius"] as! Double,
                                    time: event.data()["time"] as! String,
                                    author: event.data()["author"] as! String,
                                    verified: event.data()["verified"] as! Bool,
                                    views: event.data()["views"] as! Int,
                                    event18: event.data()["event18"] as! Bool,
                                    event21: event.data()["event21"] as! Bool,
                                    notificationOnly: event.data()["notificationOnly"] as! Bool,
                                    distanceFromUser: 0
                                )
                                self.webblenEvents.append(createdEvent)
                                print(self.webblenEvents)
                            }
                        }
                        self.myEventsTableView.reloadData()
                        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                            self.myEventsTableView.alpha = 1.0
                        }, completion: { _ in
                            self.loadingView.stopAnimating()
                            self.myEventsTableView.isUserInteractionEnabled = true
                        })
                    }
                })
            }
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.webblenEvents.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsTableViewCell", for: indexPath) as! MyEventsTableViewCell
        

        
        if (self.webblenEvents[indexPath.row].description.characters.count > 100){
            
            let index = self.webblenEvents[indexPath.row].description.index(self.webblenEvents[indexPath.row].description.startIndex, offsetBy: 100)
            
                cell.interestCategory.image = UIImage(named: self.webblenEvents[indexPath.row].categories[0])
                cell.eventTitle.text = self.webblenEvents[indexPath.row].title
                cell.eventDate.text = self.webblenEvents[indexPath.row].date
                cell.eventDescription.text = self.webblenEvents[indexPath.row].description.substring(to: index) + "..."
        }
        
        else {
    
                cell.interestCategory.image = UIImage(named: self.webblenEvents[indexPath.row].categories[0])
                cell.eventTitle.text = self.webblenEvents[indexPath.row].title
                cell.eventDate.text = self.webblenEvents[indexPath.row].date
                cell.eventDescription.text = self.webblenEvents[indexPath.row].description
            }
        if (self.webblenEvents[indexPath.row].paid == false){
            cell.eventDescription.text = "Event Draft"
            
        }
        

                return (cell)
        
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "myEventInfoSegue", sender: webblenEvents[indexPath.row].eventKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myEventInfoSegue"){
        let eventIn = segue.destination as! EventInfoViewController
        eventIn.eventKey = sender as! String
        eventIn.isEditing = true
        }
    }

    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
