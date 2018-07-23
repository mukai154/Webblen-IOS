//
//  InitialViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {


    @IBOutlet weak var welcomeHeadText: UILabel!
    @IBOutlet weak var welcomeSubtext: UILabel!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let currentUser = user {
                print("user is signed in")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DashboardViewController")
                self.present(homeViewController, animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 2.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.welcomeHeadText.alpha = 1.0
                }, completion: nil)
                UIView.animate(withDuration: 2.0, delay: 3.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.welcomeSubtext.alpha = 1.0
                }, completion: nil)
                UIView.animate(withDuration: 1.0, delay: 5.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.loginBtn.alpha = 1.0
                }, completion: nil)
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
