//
//  SettingsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/17/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert

class SettingsViewController: UIViewController {



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        let alertController = PCLBlurEffectAlertController(title: "Are You Sure Want to Logout?", message: nil, style: .alert)
        
        // Adds actions
        let confirm = PCLBlurEffectAlertAction(title: "Yes", style: .destructive) { _ in
            if (Auth.auth().currentUser != nil){
                do{
                    try Auth.auth().signOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                    self.present(vc, animated: true, completion: nil)
                } catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
        }
        let cancel = PCLBlurEffectAlertAction(title: "No", style: .default) { _ in }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        
        // Presented
        self.present(alertController, animated: true, completion: nil)
    }
    

}
