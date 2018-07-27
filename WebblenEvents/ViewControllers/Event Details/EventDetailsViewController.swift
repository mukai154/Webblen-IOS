//
//  EventDetailsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 7/21/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert
import MapKit
import Hero

class EventDetailsViewController: UIViewController {

    //Firebase
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //Event
    var event:EventPost?
    var myEvents = false
    
    //UI
    @IBOutlet weak var navigationBackground: UIView!
    @IBOutlet weak var navigationLbl: UILabel!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var eventImage: UIImageViewX!
    @IBOutlet weak var eventImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var eventYearLbl: UILabel!
    @IBOutlet weak var eventMonthDayLbl: UILabel!
    @IBOutlet weak var eventTitleLbl: UILabel!
    @IBOutlet weak var eventAuthorImage: UIImageViewX!
    @IBOutlet weak var eventUsernameLbl: UILabel!
    @IBOutlet weak var eventCaptionLable: UILabel!
    //Details
    @IBOutlet weak var eventAddressLbl: UILabel!
    @IBOutlet weak var eventDescriptionLbl: UILabel!
    
    @IBOutlet weak var eventDateTimeLbl: UILabel!
    
    @IBOutlet weak var fbLinkLbl: UILabel!
    @IBOutlet weak var twitterLinkLbl: UILabel!
    
    @IBOutlet weak var websiteLinkLbl: UILabel!
    
    @IBOutlet weak var fbLinkView: UIView!
    @IBOutlet weak var twitterLinkView: UIView!
    @IBOutlet weak var websiteLinkView: UIView!
    @IBOutlet weak var noAdditionalDetailsLbl: UILabel!
    
    var myEventsColor = UIColor(red: 104/255, green: 109/255, blue: 224/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        if myEvents {
            navigationLbl.text = "My Events"
            navigationBackground.backgroundColor = myEventsColor
        }
        loadEventData()
    }
    
    //Override Status Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    

    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressFullDescription(_ sender: Any) {
        if self.eventDescriptionLbl.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.eventDescriptionLbl.isHidden = false
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.eventDescriptionLbl.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func didClickEventsAddress(_ sender: Any) {
        setupMaps()
    }
    
    func setHeroIDs(){
        //Set Hero
        self.hero.isEnabled = true
        eventImage.hero.id = "eventImageView"
        eventAuthorImage.hero.id = "eventAuthorImage"
        eventTitleLbl.hero.id = "eventTitle"
        eventUsernameLbl.hero.id = "eventAuthorName"
        eventCaptionLable.hero.id = "eventCaption"
        if myEvents {
            navigationBackground.hero.id = "calendar"
        } else {
            navigationBackground.hero.id = "list"
        }
    }
    
    func loadEventData(){
        if event != nil {
            var eventDateTime = ""
            let eventDate = Date(fromString: (event?.startDate)!, format: .webblenFormat)
            let eventDateString = eventDate?.toString(dateStyle: .long, timeStyle: .none)
            let eventDateComponents = eventDateString?.components(separatedBy: ",")
            if (event?.startTime)! != "" && (event?.endTime)! != "" {
                eventDateTime = (event?.startTime)! + "-" + (event?.endTime)!
            } else {
                eventDateTime = (event?.startTime)!
            }
            eventTitleLbl.text = event?.title
            eventUsernameLbl.text = "@" + (event?.author)!
            eventCaptionLable.text = event?.caption
            eventMonthDayLbl.text = eventDateComponents?[0]
            eventYearLbl.text = eventDateComponents?[1]
            eventDescriptionLbl.text = event?.description
            eventDateTimeLbl.text = eventDateTime
            eventAddressLbl.text = event?.address
            //Author Image
            let authorURL = NSURL(string: (event?.authorImagePath)!)
            eventAuthorImage.sd_addActivityIndicator()
            eventAuthorImage.sd_setShowActivityIndicatorView(true)
            eventAuthorImage.sd_setIndicatorStyle(.gray)
            eventAuthorImage.sd_setImage(with: authorURL! as URL, placeholderImage: nil)
            //Event Image
            if event?.pathToImage == "" {
                detailsScrollView.isScrollEnabled = false
                eventImageAspectRatio.isActive = false
                eventImageHeightConstraint.isActive = true
            } else {
                let imageURL = NSURL(string: (event?.pathToImage)!)
                eventImage.sd_addActivityIndicator()
                eventImage.sd_setShowActivityIndicatorView(true)
                eventImage.sd_setIndicatorStyle(.gray)
                eventImage.sd_setImage(with: imageURL! as URL, placeholderImage: nil)
            }
            //Site Links
            if event?.fbSite != "" {
                self.noAdditionalDetailsLbl.isHidden = true
                fbLinkLbl.text = event?.fbSite
                fbLinkView.isHidden = false
            }
            if event?.twitterSite != "" {
                self.noAdditionalDetailsLbl.isHidden = true
                twitterLinkLbl.text = event?.fbSite
                twitterLinkView.isHidden = false
            }
            if event?.website != "" {
                self.noAdditionalDetailsLbl.isHidden = true
                websiteLinkLbl.text = event?.website
                websiteLinkView.isHidden = false
            }
        }
    }
    @IBAction func didPressFBLink(_ sender: Any) {
        let isValidURL = StringMethods.verifyUrl(urlString: event?.fbSite)
        if isValidURL {
            let settingsUrl = NSURL(string: (event?.fbSite)!) as! URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didPressTwitterLink(_ sender: Any) {
        let isValidURL = StringMethods.verifyUrl(urlString: event?.twitterSite)
        if isValidURL {
            let settingsUrl = NSURL(string: (event?.twitterSite)!) as! URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    @IBAction func didPressWebsiteLink(_ sender: Any) {
        let isValidURL = StringMethods.verifyUrl(urlString: event?.website)
        if isValidURL {
            let settingsUrl = NSURL(string: (event?.website)!)! as! URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    func setupMaps(){
        let eventLat = (event?.lat)!
        let eventLon = (event?.lon)!
        let eventTitle = (event?.title)!
        let coordinate = CLLocationCoordinate2DMake(eventLat, eventLon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = eventTitle
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

}
