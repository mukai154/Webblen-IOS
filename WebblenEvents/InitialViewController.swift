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

        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let currentUser = user {
                print("user is signed in")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarControllerView")
                
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
