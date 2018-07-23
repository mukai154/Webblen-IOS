//
//  NewEventExternalSitesViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 7/13/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit

class NewEventExternalSitesViewController: UIViewController {

    @IBOutlet weak var facebookLink: UITextField!
    @IBOutlet weak var twitterLink: UITextField!
    @IBOutlet weak var websitLink: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }

    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }

    func proceed(){
        let fb = facebookLink.text!
        let twitter = twitterLink.text!
        let website = websitLink.text!
        
        if let parentVC = self.parent {
            if let parentVC = parentVC as? NewEventPagingViewController {
                parentVC.newEvent.fbSite = fb
                parentVC.newEvent.twitterSite = twitter
                parentVC.newEvent.website = website
                parentVC.displayPageForIndex(index: 6)
            }
        }
    }
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 4)
                }
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            
        }
    }

}
