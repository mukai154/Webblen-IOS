//
//  MessagesViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/27/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Firebase
    var currentUser = Auth.auth().currentUser
    var username: String!
    var dataBaseRef: DatabaseReference!
    var database = Firestore.firestore()
    var chatID: String!
    var chatMessages = [chatMessage]()
    
    //UI
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var newMessageField: UITextFieldX!
    @IBOutlet weak var sendMessageBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func loadMessagesFromChat(chatID: String){
        let chatRef = database.collection("chats").document(chatID).collection("messages")
        
        chatRef.addSnapshotListener { querySnapshot, error in
            
            if error != nil {
                print("Error fetching documents: \(error!)")
            } else {
                let messages = querySnapshot?.documents
                self.chatMessages.removeAll()
                
                for messsage in messages! {
                    let messageData = chatMessage(messageText: messsage.data()["messageText"] as! String,
                                                  messagePicUrl: messsage.data()["messagePicUrl"] as! String,
                                                  senderUID: messsage.data()["senderUID"] as! String,
                                                  senderPicUrl: messsage.data()["senderPicUrl"] as! String,
                                                  messageKey: messsage.data()["messageKey"] as! String,
                                                  messageChatID: messsage.data()["messageChatID"] as! String,
                                                  timeSent: messsage.data()["timeSent"] as! String)
                    self.chatMessages.append(messageData)
                }
               
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if chatMessages[indexPath.row].senderUID == currentUser?.uid {
            cell = messagesTableView.dequeueReusableCell(withIdentifier: "groupMemberTextBubble")!
            let senderPic = cell.viewWithTag(1) as! UIImageView
            let messageText = cell.viewWithTag(3) as! UILabel
            let url = NSURL(string: chatMessages[indexPath.row].senderPicUrl)
            let text = chatMessages[indexPath.row].messageText
            senderPic.sd_setImage(with: url! as URL)
            messageText.text = text
            
        } else {
            cell = messagesTableView.dequeueReusableCell(withIdentifier: "userTextBubble")!
            let senderPic = cell.viewWithTag(1) as! UIImageView
            let messageText = cell.viewWithTag(3) as! UILabel
            let url = NSURL(string: chatMessages[indexPath.row].senderPicUrl)
            let text = chatMessages[indexPath.row].messageText
            senderPic.sd_setImage(with: url! as URL)
            messageText.text = text
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func didPressOptions(_ sender: Any) {
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
