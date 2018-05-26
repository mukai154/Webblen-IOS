//
//  PermissionsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/23/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase


class PermissionsViewController: UIViewController {

    @IBOutlet weak var userIDQRCode: UIImageView!
    @IBOutlet weak var privateKeyQRCode: UIImageView!
    @IBOutlet weak var userIDField: UITextFieldX!
    @IBOutlet weak var privateKeyField: UITextFieldX!
    @IBOutlet weak var userIDEye: UIButton!
    @IBOutlet weak var privateKeyEye: UIButton!
    
    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //User Keys
    var userIDIsHidden = true
    var privateKeyIsHidden = true
    
    //Images
    var showEyeImage = UIImage(named: "ic_eye_gray")
    var hiddenEyeImage = UIImage(named: "ic_hidden_eye_gray")
    var QRCodeImage:UIImage?
    
    var filter = CIFilter(name: "CIQRCodeGenerator")
    var scaleX:CGFloat?
    var scaleY:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func loadData(){
        
        //UID DATA
        let uid = currentUser?.uid
        userIDField.text = uid!
        setUIDQRCode(key: uid!)
        
        //Private Key Data
        let userDocRef = self.dataBase.collection("users").document((currentUser?.uid)!)
        userDocRef.getDocument(completion: {(snapshot, error) in
            if (snapshot?.exists)! {
                let privateKey = snapshot?.data()!["private_key"] as? String
                
                if privateKey != nil {
                    self.privateKeyField.text = privateKey!
                    self.setPrivateKeyQRCode(key: privateKey!)
                } else {
                    let randomKey = StringMethods.randomString(length: 26)
                    self.privateKeyField.text = randomKey
                    self.setPrivateKeyQRCode(key: randomKey)
                    userDocRef.updateData(["private_key": randomKey]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                
            } else {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            }
        })
        
    }
    
    func setUIDQRCode(key: String){
        let uidData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(uidData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = userIDQRCode.frame.width / (generatedImg?.extent.size.width)!
            scaleY = userIDQRCode.frame.height / (generatedImg?.extent.size.height)!
        } else {
            scaleX = 100
            scaleY = 100
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)

        if let output = filter?.outputImage?.applying(transform){
            QRCodeImage = UIImage(ciImage: output)
            userIDQRCode.image = QRCodeImage
        }
        
    }
    
    func setPrivateKeyQRCode(key: String){
        let keyData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(keyData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = privateKeyQRCode.frame.width / (generatedImg?.extent.size.width)!
            scaleY = privateKeyQRCode.frame.height / (generatedImg?.extent.size.height)!
        } else {
            scaleX = 100
            scaleY = 100
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.applying(transform){
            QRCodeImage = UIImage(ciImage: output)
            privateKeyQRCode.image = QRCodeImage
        }
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressUIDQRCode(_ sender: Any) {
    }
    
    @IBAction func didPressPrivateKeyQRCode(_ sender: Any) {
    }
    
    
    @IBAction func didPressUIDEye(_ sender: Any) {
        if userIDIsHidden {
            userIDField.isSecureTextEntry = false
            userIDEye.setImage(hiddenEyeImage, for: .normal)
            userIDIsHidden = false
        } else {
            userIDField.isSecureTextEntry = true
            userIDEye.setImage(showEyeImage, for: .normal)
            userIDIsHidden = true
        }
    }
    
    @IBAction func didPressPrivateKeyEye(_ sender: Any) {
        if privateKeyIsHidden {
            privateKeyField.isSecureTextEntry = false
            privateKeyEye.setImage(hiddenEyeImage, for: .normal)
            privateKeyIsHidden = false
        } else {
            privateKeyField.isSecureTextEntry = true
            privateKeyEye.setImage(showEyeImage, for: .normal)
            privateKeyIsHidden = true
        }
    }
}
