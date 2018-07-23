//
//  NewEventAddImageViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import UIImageCropper

class NewEventAddImageViewController: UIViewController {

    //UI
    @IBOutlet weak var eventImg: UIImageViewX!
    
    //Image Picker
    var skipUpload = false
    var uploadedImage: UIImage?
    var picker = UIImagePickerController()
    var cropper = UIImageCropper(cropRatio: 3/2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //image picker
        cropper.picker = picker
        cropper.delegate = self
        
        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }


    @IBAction func didPressImg(_ sender: Any) {
        cropper.picker = picker
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        cropper.cancelButtonText = "Retake"
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default) { _ in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didPressSkip(_ sender: Any) {
        skipUpload = true
        uploadedImage = nil
        proceed()
        eventImg.image = nil
        
    }
    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }
    
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 0)
                }
            }
        } else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        } 
    }
    
    
    func proceed(){
        if let parentVC = self.parent {
            if let parentVC = parentVC as? NewEventPagingViewController {
                if uploadedImage != nil  {
                    parentVC.newEvent.uploadedImage = uploadedImage!
                    parentVC.displayPageForIndex(index: 2)
                } else if skipUpload == true {
                    self.skipUpload = false
                    parentVC.newEvent.uploadedImage = ""
                    parentVC.displayPageForIndex(index: 2)
                } else {
                    showBlurAlert(title: "Image Missing", message: "Please Attach an Image to Your Event or Press 'Skip'")
                }

            }
        }
    }
}

extension NewEventAddImageViewController: UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        uploadedImage = croppedImage
        eventImg.image = uploadedImage
    }
    
    //optional
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
        print("did cancel")
    }
}
