//
//  PermissionsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/23/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert

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
    var uid:String?
    var privateKey:String?
    var userIDIsHidden = true
    var privateKeyIsHidden = true
    
    //Images
    var showEyeImage = UIImage(named: "ic_eye_gray")
    var hiddenEyeImage = UIImage(named: "ic_hidden_eye_gray")
    var uidQRCodeImg:UIImage?
    var uidQRCodeImgLarge:UIImage?
    var privateKeyQRCodeImg:UIImage?
    var privateKeyQRCodeImgLarge:UIImage?

    //QRCODE
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
        uid = currentUser?.uid
        userIDField.text = uid!
        setUIDQRCode(key: uid!)
        setUIDQRCodeLarge(key: uid!)
        
        //Private Key Data
        let userDocRef = self.dataBase.collection("users").document(uid!)
        userDocRef.getDocument(completion: {(snapshot, error) in
            if (snapshot?.exists)! {
                self.privateKey = snapshot?.data()!["private_key"] as? String
                
                if self.privateKey != nil {
                    self.privateKeyField.text = self.privateKey!
                    self.setPrivateKeyQRCode(key: self.privateKey!)
                    self.setPrivateKeyQRCodeLarge(key: self.privateKey!)
                } else {
                    let randomKey = StringMethods.randomString(length: 26)
                    self.privateKey = randomKey
                    self.privateKeyField.text = randomKey
                    self.setPrivateKeyQRCode(key: randomKey)
                    self.setPrivateKeyQRCodeLarge(key: randomKey)
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
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)

        if let output = filter?.outputImage?.applying(transform){
            uidQRCodeImg = UIImage(ciImage: output)
            userIDQRCode.image = uidQRCodeImg
        }
        
    }
    
    func setUIDQRCodeLarge(key: String){
        let uidData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(uidData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.applying(transform){
            uidQRCodeImgLarge = UIImage(ciImage: output)
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
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.applying(transform){
            privateKeyQRCodeImg = UIImage(ciImage: output)
            privateKeyQRCode.image = privateKeyQRCodeImg
        }
    }
    
    func setPrivateKeyQRCodeLarge(key: String){
        let keyData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(keyData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.applying(transform){
            privateKeyQRCodeImgLarge = UIImage(ciImage: output)
        }
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressUIDQRCode(_ sender: Any) {
        let alertController = PCLBlurEffectAlertController(title: "Account ID", message: nil, effect: UIBlurEffect(style: .regular),style: .alert)
        alertController.addImageView(with: uidQRCodeImgLarge!)
        let backAction = PCLBlurEffectAlertAction(title: "Back", style: .default) { _ in}
        let copyAction = PCLBlurEffectAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = self.userIDField.text!
            self.showBlurAlert(title: "Saved to Clipboard!", message: nil)
        }
        alertController.configure(cornerRadius: 15.0)
        alertController.configure(backgroundColor: .white)
        alertController.configure(buttonBackgroundColor: .white)
        alertController.configure(buttonTextColor: [.default: .black, .destructive: .black])
        alertController.addAction(backAction)
        alertController.addAction(copyAction)
        alertController.show()
    }
    
    @IBAction func didPressPrivateKeyQRCode(_ sender: Any) {
        let alertController = PCLBlurEffectAlertController(title: "Private Key", message: nil, effect: UIBlurEffect(style: .regular),style: .alert)
        alertController.addImageView(with: privateKeyQRCodeImgLarge!)
        let backAction = PCLBlurEffectAlertAction(title: "Back", style: .default) { _ in}
        let copyAction = PCLBlurEffectAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = self.privateKeyField.text
            self.showBlurAlert(title: "Saved to Clipboard!", message: nil)
        }
        alertController.configure(cornerRadius: 15.0)
        alertController.configure(backgroundColor: .white)
        alertController.configure(buttonBackgroundColor: .white)
        alertController.configure(buttonTextColor: [.default: .black, .destructive: .black])
        alertController.addAction(backAction)
        alertController.addAction(copyAction)
        alertController.show()
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
