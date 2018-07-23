//
//  NewEventTagsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/30/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class NewEventTagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Firebase
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //Tags Arrays
    var searchResult = [String]()
    var selectedTags = [String]()

    //UI
    @IBOutlet weak var noResultsLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tag1: UIViewX!
    @IBOutlet weak var tag1Lbl: UILabel!
    @IBOutlet weak var tag2: UIViewX!
    @IBOutlet weak var tag2Lbl: UILabel!
    @IBOutlet weak var tag3: UIViewX!
    @IBOutlet weak var tag3Lbl: UILabel!
    @IBOutlet weak var tag4: UIViewX!
    @IBOutlet weak var tag4Lbl: UILabel!
    @IBOutlet weak var tag5: UIViewX!
    @IBOutlet weak var tag5Lbl: UILabel!
    @IBOutlet weak var tag6: UIViewX!
    @IBOutlet weak var tag6Lbl: UILabel!
    @IBOutlet weak var tagSearchField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Search Field
        tagSearchField.addTarget(self, action: #selector(NewEventTagsViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        getAllTags()
    }
    
    @IBAction func didPressBrowse(_ sender: Any) {
        tagSearchField.text = ""
        getAllTags()
    }
    
    @IBAction func didPressTag1(_ sender: Any) {
        selectedTags.remove(at: 0)
        renderCurrentTags()
    }
    @IBAction func didPressTag2(_ sender: Any) {
        selectedTags.remove(at: 1)
        renderCurrentTags()
    }
    @IBAction func didPressTag3(_ sender: Any) {
        selectedTags.remove(at: 2)
        renderCurrentTags()
    }
    @IBAction func didPressTag4(_ sender: Any) {
        selectedTags.remove(at: 3)
        renderCurrentTags()
    }
    @IBAction func didPressTag5(_ sender: Any) {
        selectedTags.remove(at: 4)
        renderCurrentTags()
    }
    @IBAction func didPressTag6(_ sender: Any) {
        selectedTags.remove(at: 5)
        renderCurrentTags()
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }
    
    //Tag Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        let tagLabel = cell.viewWithTag(1) as! UILabel
        tagLabel.text = searchResult[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = searchResult[indexPath.item]
        if !selectedTags.contains(tag) && selectedTags.count < 6{
            selectedTags.append(searchResult[indexPath.item])
        } else if !selectedTags.contains(tag) && selectedTags.count == 6{
            showBlurAlert(title: "Tag Limit Reached", message: "You Can Only Have 6 Tags for Your Event")
        }
        renderCurrentTags()
    }
    
    //Tag Views
    func renderCurrentTags(){
        if selectedTags.indices.contains(0) {
            tag1.isHidden = false
            tag1Lbl.text = selectedTags[0]
        } else {
            tag1.isHidden = true
        }
        
        if selectedTags.indices.contains(1) {
            tag2.isHidden = false
            tag2Lbl.text = selectedTags[1]
        } else {
            tag2.isHidden = true
        }
        
        if selectedTags.indices.contains(2) {
            tag3.isHidden = false
            tag3Lbl.text = selectedTags[2]
        } else {
            tag3.isHidden = true
        }
        
        if selectedTags.indices.contains(3) {
            tag4.isHidden = false
            tag4Lbl.text = selectedTags[3]
        } else {
            tag4.isHidden = true
        }
        
        if selectedTags.indices.contains(4) {
            tag5.isHidden = false
            tag5Lbl.text = selectedTags[4]
        } else {
            tag5.isHidden = true
        }
        
        if selectedTags.indices.contains(5) {
            tag6.isHidden = false
            tag6Lbl.text = selectedTags[5]
        } else {
            tag6.isHidden = true
        }
        
    }
    func loadingIndicator(){
        noResultsLbl.isHidden = true
        tagCollectionView.isHidden = true
        activityIndicator.isHidden = false
    }
    //Get All Database Tags
    func getAllTags(){
        loadingIndicator()
        let tagCollection = dataBase.collection("tags")
        tagCollection.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("error in finding events")
            } else if (snapshot?.isEmpty)! {
            
            } else {
                for document in (snapshot?.documents)! {
                    let tag = document.documentID
                    self.searchResult.append(tag)
                }
                self.tagCollectionView.reloadData()
                self.tagCollectionView.isHidden = false
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    //Search Tags
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchResult.removeAll()
        self.tagCollectionView.reloadData()
        let text = tagSearchField.text!.lowercased().trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            getAllTags()
        } else {
            loadingIndicator()
            let tagField = "subcategories." + text
            let tagCollection = dataBase.collection("tags").whereField(tagField, isEqualTo: true)
            tagCollection.getDocuments(completion: {(snapshot, error) in
                if error != nil {
                    print("error in finding events")
                } else if (snapshot?.isEmpty)! {
                    self.noResultsLbl.text = "No Results for '" + text + "'"
                    self.noResultsLbl.isHidden = false
                    self.activityIndicator.isHidden = true
                } else {
                    for document in (snapshot?.documents)! {
                        let tag = document.documentID
                        self.searchResult.append(tag)
                    }
                    self.tagCollectionView.reloadData()
                    self.tagCollectionView.isHidden = false
                    self.activityIndicator.isHidden = true
                }
            })
        }
        
    }
    
    //Validation
    func isValid() -> Bool{
        var isValid = true
        if selectedTags.isEmpty {
            isValid = false
        }
        return isValid
    }
    
    func proceed(){
        if isValid() {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.newEvent.tags = selectedTags
                    parentVC.displayPageForIndex(index: 3)
                }
            }
        } else {
            showBlurAlert(title: "Tags Missing", message: "Please Select At Least 1 Tag")
        }
        
    }
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 1)
                }
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        }
    }

}
