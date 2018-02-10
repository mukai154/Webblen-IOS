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

    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let currentUser = user {
                print("user is signed in")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RevealViewController")
                
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
