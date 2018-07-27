//
//  UserTagsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 7/22/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert
import NVActivityIndicatorView
import Hero

class UserTagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    //Firebase
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var settingUp = false
    
    //Tags Arrays
    var eventTags = [String]()
    var userTags = [String]()
    
    //UI
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    //Colors & LoadingView
    var activeTagColor = UIColor(red: 255/255, green: 121/255, blue: 121/255, alpha: 1.0)
    var inactiveTagColor = UIColor.clear
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        if settingUp {
            cancelButton.isHidden = true
        }
        tagCollectionView.alpha = 0.0
        //Activity indicator starts
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: .darkGray, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        getTagData()
    }
    
    //Override Status Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setHeroIDs(){
        self.hero.isEnabled = true
        backgroundView.hero.id = "heart"
    }

    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressUpdate(_ sender: Any) {
        updateUserTags()
    }
    
    //Get All Database Tags
    func getTagData(){
        let userCollection = dataBase.collection("users")
        let tagCollection = dataBase.collection("tags")
        userCollection.document((currentUser?.uid)!).getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            } else if error != nil{
                print(error)
            } else {
                let userInterests = snapshot?.data()!["tags"] as? [String]
                if userInterests != nil {
                    self.userTags = userInterests!
                }
                tagCollection.getDocuments(completion: {(snapshot, error) in
                    if error != nil {
                        print("error in finding events")
                    } else if (snapshot?.isEmpty)! {
                        
                    } else {
                        for document in (snapshot?.documents)! {
                            let tag = document.documentID
                            self.eventTags.append(tag)
                            print(tag)
                        }
                        self.tagCollectionView.reloadData()
                        self.loadingView.stopAnimating()
                        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                            self.tagCollectionView.alpha = 1.0
                        }, completion: nil)
                    }
                })
            }
        })
    }
    
    //Update Tags
    func updateUserTags(){
        loadingView.startAnimating()
        let userCollection = dataBase.collection("users")
        userCollection.document((currentUser?.uid)!).setData(["tags": userTags], options: SetOptions.merge())
        dismissBlurController()
    }
    
    func dismissBlurController(){
        let alertController = PCLBlurEffectAlertController(title: "Interests Updated!", message: nil, effect: UIBlurEffect(style: .regular),style: .alert)
        let backAction = PCLBlurEffectAlertAction(title: "Ok", style: .default) { _ in
           self.dismiss(animated: true, completion: nil)
        }
        alertController.configure(cornerRadius: 15.0)
        alertController.configure(backgroundColor: .white)
        alertController.configure(buttonBackgroundColor: .white)
        alertController.configure(buttonTextColor: [.default: .black, .destructive: .black])
        alertController.addAction(backAction)
        alertController.show()
    }
    
    //Tag Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = eventTags[indexPath.item]
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        let background = cell.viewWithTag(1) as! UIViewX
        let tagLabel = cell.viewWithTag(2) as! UILabel
        tagLabel.text = tag
        
        if !userTags.contains(tag){
            background.backgroundColor = inactiveTagColor
            tagLabel.textColor = .white
        } else if userTags.contains(tag){
            background.backgroundColor = activeTagColor
            tagLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        let background = cell?.viewWithTag(1) as! UIViewX
        let tagLabel = cell?.viewWithTag(2) as! UILabel
        let tag = eventTags[indexPath.item]
        if !userTags.contains(tag){
            background.backgroundColor = activeTagColor
            tagLabel.textColor = .white
            userTags.append(eventTags[indexPath.item])
        } else if userTags.contains(tag){
            background.backgroundColor = inactiveTagColor
            tagLabel.textColor = .darkGray
            self.userTags = self.userTags.filter {$0 != tag}
        }
        print(userTags)
    }


}
