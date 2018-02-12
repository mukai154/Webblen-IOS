
//
//  InterestSetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class InterestSetupViewController: UIViewController {


//Outlets
    @IBOutlet weak var navBackground: UIView!
    
    @IBOutlet weak var cancelOption: UIBarButtonItem!
    
    @IBOutlet weak var amusementView: UIView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var artView: UIView!
    @IBOutlet weak var collegeView: UIView!
    @IBOutlet weak var competitionView: UIView!
    @IBOutlet weak var cultureView: UIView!
    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var entertainmentView: UIView!
    @IBOutlet weak var familyView: UIView!
    @IBOutlet weak var foodDrinkView: UIView!
    @IBOutlet weak var gamingView: UIView!
    @IBOutlet weak var healthFitnessView: UIView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var networkingView: UIView!
    @IBOutlet weak var outdoorsView: UIView!
    @IBOutlet weak var partyDanceView: UIView!
    @IBOutlet weak var sportsView: UIView!
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var techView: UIView!
    @IBOutlet weak var theatreView: UIView!
    @IBOutlet weak var wineBrewView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    //Variables
    var amusement = false
    var art = false
    var collegeLife = false
    var community = false
    var competition = false
    var culture = false
    var education = false
    var entertainment = false
    var family = false
    var foodDrink = false
    var gaming = false
    var healthFitness = false
    var music = false
    var networking = false
    var outdoors = false
    var partyDance = false
    var shopping = false
    var sports = false
    var technology = false
    var theatre = false
    var wineBrew = false
    
    var settingUp = false

    var userInterests = [""]
    
    //Firebase references
    var database = Firestore.firestore()
    var dataBaseRef = Database.database().reference()
    var currentUser = Auth.auth().currentUser
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //Activity indicator starts
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-147), y: (yAxis-135), width: 300, height: 300)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 0.9), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
    
    //Check for current user
        
    
        if settingUp == true {
            cancelOption.isEnabled = false
        }
    //Set up current interests
            
            let userRef = database.collection("users").document((currentUser?.uid)!)
            userRef.getDocument(completion: {(document, error) in
                if let document = document {
                    let interests = document.data()!["interests"] as? [String]
                    if  (interests?.contains("AMUSEMENT"))!{
                        self.amusement = true
                    }
                    if  (interests?.contains("ART"))!{
                        self.art = true
                    }
                    if  (interests?.contains("COLLEGELIFE"))!{
                        self.collegeLife = true
                    }
                    if  (interests?.contains("COMMUNITY"))!{
                        self.community = true
                    }
                    if  (interests?.contains("COMPETITION"))!{
                        self.competition = true
                    }
                    if  (interests?.contains("CULTURE"))!{
                        self.culture = true
                    }
                    if  (interests?.contains("EDUCATION"))!{
                        self.education = true
                    }
                    if  (interests?.contains("ENTERTAINMENT"))!{
                        self.entertainment = true
                    }
                    if  (interests?.contains("FAMILY"))!{
                        self.family = true
                    }
                    if  (interests?.contains("FOODDRINK"))!{
                        self.foodDrink = true
                    }
                    if  (interests?.contains("GAMING"))!{
                        self.gaming = true
                    }
                    if  (interests?.contains("HEALTHFITNESS"))!{
                        self.healthFitness = true
                    }
                    if  (interests?.contains("MUSIC"))!{
                        self.music = true
                    }
                    if  (interests?.contains("NETWORKING"))!{
                        self.networking = true
                    }
                    if  (interests?.contains("OUTDOORS"))!{
                        self.outdoors = true
                    }
                    if  (interests?.contains("PARTYDANCE"))!{
                        self.partyDance = true
                    }
                    if  (interests?.contains("SHOPPING"))!{
                        self.shopping = true
                    }
                    if  (interests?.contains("SPORTS"))!{
                        self.sports = true
                    }
                    if  (interests?.contains("TECHNOLOGY"))!{
                        self.technology = true
                    }
                    if  (interests?.contains("THEATRE"))!{
                        self.theatre = true
                    }
                    if  (interests?.contains("WINEBREW"))!{
                        self.wineBrew = true
                    }
                    UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                        self.renderInterests()
                    }, completion: nil)
                }
                else {
                    print("document does not exist")
                }
            })
   
            
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

//-------INTEREST BUTTONS
    @IBAction func didPressAmusment(_ sender: Any) {
        if (amusement == true){
            amusement = false
            self.userInterests = self.userInterests.filter(){$0 != "AMUSEMENT"}
            self.amusementView.layer.borderColor = UIColor.lightGray.cgColor
            self.amusementView.layer.borderWidth = 0.1
        }
        else{
            amusement = true
            self.userInterests.append("AMUSEMENT")
            self.amusementView.layer.borderColor = UIColor.orange.cgColor
            self.amusementView.layer.borderWidth = 1
    }
    }
    
    @IBAction func didPressArt(_ sender: Any) {
        if (art == true){
            art = false
            self.userInterests = self.userInterests.filter(){$0 != "ART"}
            self.artView.layer.borderColor = UIColor.lightGray.cgColor
            self.artView.layer.borderWidth = 0.1
        }
        else{
            art = true
            self.userInterests.append("ART")
            self.artView.layer.borderColor = UIColor.orange.cgColor
            self.artView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressCollege(_ sender: Any) {
        if (collegeLife == true){
            collegeLife = false
            self.userInterests = self.userInterests.filter(){$0 != "COLLEGELIFE"}
            self.collegeView.layer.borderColor = UIColor.lightGray.cgColor
            self.collegeView.layer.borderWidth = 0.1
        }
        else{
            collegeLife = true
            self.userInterests.append("COLLEGELIFE")
            self.collegeView.layer.borderColor = UIColor.orange.cgColor
            self.collegeView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressCommunity(_ sender: Any) {
        if (community == true){
            community = false
            self.userInterests = self.userInterests.filter(){$0 != "COMMUNITY"}
            self.communityView.layer.borderColor = UIColor.lightGray.cgColor
            self.communityView.layer.borderWidth = 0.1
        }
        else{
            community = true
            self.userInterests.append("COMMUNITY")
            self.communityView.layer.borderColor = UIColor.orange.cgColor
            self.communityView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressCompetition(_ sender: Any) {
        if (competition == true){
            competition = false
            self.userInterests = self.userInterests.filter(){$0 != "COMPETITION"}
            self.competitionView.layer.borderColor = UIColor.lightGray.cgColor
            self.competitionView.layer.borderWidth = 0.1
        }
        else{
            competition = true
            self.userInterests.append("COMPETITION")
            self.competitionView.layer.borderColor = UIColor.orange.cgColor
            self.competitionView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressCulture(_ sender: Any) {
        if (culture == true){
            culture = false
            self.userInterests = self.userInterests.filter(){$0 != "CULTURE"}
            self.cultureView.layer.borderColor = UIColor.lightGray.cgColor
            self.cultureView.layer.borderWidth = 0.1
        }
        else{
            culture = true
            self.userInterests.append("CULTURE")
            self.cultureView.layer.borderColor = UIColor.orange.cgColor
            self.cultureView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressEducation(_ sender: Any) {
        if (education == true){
            education = false
            self.userInterests = self.userInterests.filter(){$0 != "EDUCATION"}
            self.educationView.layer.borderColor = UIColor.lightGray.cgColor
            self.educationView.layer.borderWidth = 0.1
        }
        else{
            education = true
            self.userInterests.append("EDUCATION")
            self.educationView.layer.borderColor = UIColor.orange.cgColor
            self.educationView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressEntertainment(_ sender: Any) {
        if (entertainment == true){
            entertainment = false
            self.userInterests = self.userInterests.filter(){$0 != "ENTERTAINMENT"}
            self.entertainmentView.layer.borderColor = UIColor.lightGray.cgColor
            self.entertainmentView.layer.borderWidth = 0.1
        }
        else{
            entertainment = true
            self.userInterests.append("ENTERTAINMENT")
            self.entertainmentView.layer.borderColor = UIColor.orange.cgColor
            self.entertainmentView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressFamily(_ sender: Any) {
        if (family == true){
            family = false
            self.userInterests = self.userInterests.filter(){$0 != "FAMILY"}
            self.familyView.layer.borderColor = UIColor.lightGray.cgColor
            self.familyView.layer.borderWidth = 0.1
        }
        else{
            family = true
            self.userInterests.append("FAMILY")
            self.familyView.layer.borderColor = UIColor.orange.cgColor
            self.familyView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressFoodDrink(_ sender: Any) {
        if (foodDrink == true){
            foodDrink = false
            self.userInterests = self.userInterests.filter(){$0 != "FOODDRINK"}
            self.foodDrinkView.layer.borderColor = UIColor.lightGray.cgColor
            self.foodDrinkView.layer.borderWidth = 0.1
        }
        else{
            foodDrink = true
            self.userInterests.append("FOODDRINK")
            self.foodDrinkView.layer.borderColor = UIColor.orange.cgColor
            self.foodDrinkView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressGaming(_ sender: Any) {
        if (gaming == true){
            gaming = false
            self.userInterests = self.userInterests.filter(){$0 != "GAMING"}
            self.gamingView.layer.borderColor = UIColor.lightGray.cgColor
            self.gamingView.layer.borderWidth = 0.1
        }
        else{
            gaming = true
            self.userInterests.append("GAMING")
            self.gamingView.layer.borderColor = UIColor.orange.cgColor
            self.gamingView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressHealthFitness(_ sender: Any) {
        if (healthFitness == true){
            healthFitness = false
            self.userInterests = self.userInterests.filter(){$0 != "HEALTHFITNESS"}
            self.healthFitnessView.layer.borderColor = UIColor.lightGray.cgColor
            self.healthFitnessView.layer.borderWidth = 0.1
        }
        else{
            healthFitness = true
            self.userInterests.append("HEALTHFITNESS")
            self.healthFitnessView.layer.borderColor = UIColor.orange.cgColor
            self.healthFitnessView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressMusic(_ sender: Any) {
        if (music == true){
            music = false
            self.userInterests = self.userInterests.filter(){$0 != "MUSIC"}
            self.musicView.layer.borderColor = UIColor.lightGray.cgColor
            self.musicView.layer.borderWidth = 0.1
        }
        else{
            music = true
            self.userInterests.append("MUSIC")
            self.musicView.layer.borderColor = UIColor.orange.cgColor
            self.musicView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressNetworking(_ sender: Any) {
        if (networking == true){
            networking = false
            self.userInterests = self.userInterests.filter(){$0 != "NETWORKING"}
            self.networkingView.layer.borderColor = UIColor.lightGray.cgColor
            self.networkingView.layer.borderWidth = 0.1
        }
        else{
            networking = true
            self.userInterests.append("NETWORKING")
            self.networkingView.layer.borderColor = UIColor.orange.cgColor
            self.networkingView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressOutdoors(_ sender: Any) {
        if (outdoors == true){
            outdoors = false
            self.userInterests = self.userInterests.filter(){$0 != "OUTDOORS"}
            self.outdoorsView.layer.borderColor = UIColor.lightGray.cgColor
            self.outdoorsView.layer.borderWidth = 0.1
        }
        else{
            outdoors = true
            self.userInterests.append("OUTDOORS")
            self.outdoorsView.layer.borderColor = UIColor.orange.cgColor
            self.outdoorsView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressPartyDance(_ sender: Any) {
        if (partyDance == true){
            partyDance = false
            self.userInterests = self.userInterests.filter(){$0 != "PARTYDANCE"}
            self.partyDanceView.layer.borderColor = UIColor.lightGray.cgColor
            self.partyDanceView.layer.borderWidth = 0.1
        }
        else{
            partyDance = true
            self.userInterests.append("PARTYDANCE")
            self.partyDanceView.layer.borderColor = UIColor.orange.cgColor
            self.partyDanceView.layer.borderWidth = 1
        }
    }

    @IBAction func didPressShopping(_ sender: Any) {
        if (shopping == true){
            shopping = false
            self.userInterests = self.userInterests.filter(){$0 != "SHOPPING"}
            self.shoppingView.layer.borderColor = UIColor.lightGray.cgColor
            self.shoppingView.layer.borderWidth = 0.1
        }
        else{
            shopping = true
            self.userInterests.append("SHOPPING")
            self.shoppingView.layer.borderColor = UIColor.orange.cgColor
            self.shoppingView.layer.borderWidth = 1
        }
    }

    @IBAction func pressedSports(_ sender: Any) {
        
        if (sports == true){
            sports = false
            self.userInterests = self.userInterests.filter(){$0 != "SPORTS"}
            self.sportsView.layer.borderColor = UIColor.lightGray.cgColor
            self.sportsView.layer.borderWidth = 0.1
        }
        else{
            sports = true
            self.userInterests.append("SPORTS")
            self.sportsView.layer.borderColor = UIColor.orange.cgColor
            self.sportsView.layer.borderWidth = 1
            
        }
        
    }
    @IBAction func didPressTechnology(_ sender: Any) {
        if (technology == true){
            technology = false
            self.userInterests = self.userInterests.filter(){$0 != "TECHNOLOGY"}
            self.techView.layer.borderColor = UIColor.lightGray.cgColor
            self.techView.layer.borderWidth = 0.1
        }
        else{
            technology = true
            self.userInterests.append("TECHNOLOGY")
            self.techView.layer.borderColor = UIColor.orange.cgColor
            self.techView.layer.borderWidth = 1
            
        }
    }
    @IBAction func didPressTheatre(_ sender: Any) {
        if (theatre == true){
            theatre = false
            self.userInterests = self.userInterests.filter(){$0 != "THEATRE"}

            self.theatreView.layer.borderColor = UIColor.lightGray.cgColor
            self.theatreView.layer.borderWidth = 0.1
        }
        else{
            theatre = true
            self.userInterests.append("THEATRE")
            self.theatreView.layer.borderColor = UIColor.orange.cgColor
            self.theatreView.layer.borderWidth = 1
        }
    }

    @IBAction func didPressWineBrew(_ sender: Any) {
        if (wineBrew == true){
            wineBrew = false
            self.userInterests = self.userInterests.filter(){$0 != "WINEBREW"}
            self.wineBrewView.layer.borderColor = UIColor.lightGray.cgColor
            self.wineBrewView.layer.borderWidth = 0.1
        }
        else{
            wineBrew = true
            self.userInterests.append("WINEBREW")
            self.wineBrewView.layer.borderColor = UIColor.orange.cgColor
            self.wineBrewView.layer.borderWidth = 1
        }
    }
//-------INTEREST BUTTONS

    
    @IBAction func didTapUpdate(_ sender: Any) {

        //Activity Indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        database.collection("users").document((currentUser?.uid)!).setData(["interests": userInterests], options: SetOptions.merge())
        
        activityIndicator.stopAnimating()
        
        returnHome()
    }

    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func returnHome(){
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    //MODIFY VIEWS AFTER LOADING
    func renderInterests(){
        if (self.amusement == true){
            userInterests.append("AMUSEMENT")
            self.amusementView.layer.borderColor = UIColor.orange.cgColor
            self.amusementView.layer.borderWidth = 1
            self.amusementView.layer.cornerRadius = CGFloat(Float(25.0))
            
        }
        else{
            self.amusementView.layer.borderColor = UIColor.lightGray.cgColor
            self.amusementView.layer.borderWidth = 0.1
            self.amusementView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.art == true){
            userInterests.append("ART")
            self.artView.layer.borderColor = UIColor.orange.cgColor
            self.artView.layer.borderWidth = 1
            self.artView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.artView.layer.borderColor = UIColor.lightGray.cgColor
            self.artView.layer.borderWidth = 0.1
            self.artView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.community == true){
            userInterests.append("COMMUNITY")
            self.communityView.layer.borderColor = UIColor.orange.cgColor
            self.communityView.layer.borderWidth = 1
            self.communityView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.communityView.layer.borderColor = UIColor.lightGray.cgColor
            self.communityView.layer.borderWidth = 0.1
            self.communityView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.culture == true){
            userInterests.append("CULTURE")
            self.cultureView.layer.borderColor = UIColor.orange.cgColor
            self.cultureView.layer.borderWidth = 1
            self.cultureView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.cultureView.layer.borderColor = UIColor.lightGray.cgColor
            self.cultureView.layer.borderWidth = 0.1
            self.cultureView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.competition == true){
            userInterests.append("COMPETITION")
            self.competitionView.layer.borderColor = UIColor.orange.cgColor
            self.competitionView.layer.borderWidth = 1
            self.competitionView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.competitionView.layer.borderColor = UIColor.lightGray.cgColor
            self.competitionView.layer.borderWidth = 0.1
            self.competitionView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.education == true){
            userInterests.append("EDUCATION")
            self.educationView.layer.borderColor = UIColor.orange.cgColor
            self.educationView.layer.borderWidth = 1
            self.educationView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.educationView.layer.borderColor = UIColor.lightGray.cgColor
            self.educationView.layer.borderWidth = 0.1
            self.educationView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.entertainment == true){
            userInterests.append("ENTERTAINMENT")
            self.entertainmentView.layer.borderColor = UIColor.orange.cgColor
            self.entertainmentView.layer.borderWidth = 1
            self.entertainmentView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.entertainmentView.layer.borderColor = UIColor.lightGray.cgColor
            self.entertainmentView.layer.borderWidth = 0.1
            self.entertainmentView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.family == true){
            userInterests.append("FAMILY")
            self.familyView.layer.borderColor = UIColor.orange.cgColor
            self.familyView.layer.borderWidth = 1
            self.familyView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.familyView.layer.borderColor = UIColor.lightGray.cgColor
            self.familyView.layer.borderWidth = 0.1
            self.familyView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.foodDrink == true){
            userInterests.append("FOODDRINK")
            self.foodDrinkView.layer.borderColor = UIColor.orange.cgColor
            self.foodDrinkView.layer.borderWidth = 1
            self.foodDrinkView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.foodDrinkView.layer.borderColor = UIColor.lightGray.cgColor
            self.foodDrinkView.layer.borderWidth = 0.1
            self.foodDrinkView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.gaming == true){
            userInterests.append("GAMING")
            self.gamingView.layer.borderColor = UIColor.orange.cgColor
            self.gamingView.layer.borderWidth = 1
            self.gamingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.gamingView.layer.borderColor = UIColor.lightGray.cgColor
            self.gamingView.layer.borderWidth = 0.1
            self.gamingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.healthFitness == true){
            userInterests.append("HEALTHFITNESS")
            self.healthFitnessView.layer.borderColor = UIColor.orange.cgColor
            self.healthFitnessView.layer.borderWidth = 1
            self.healthFitnessView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.healthFitnessView.layer.borderColor = UIColor.lightGray.cgColor
            self.healthFitnessView.layer.borderWidth = 0.1
            self.healthFitnessView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.music == true){
            userInterests.append("MUSIC")
            self.musicView.layer.borderColor = UIColor.orange.cgColor
            self.musicView.layer.borderWidth = 1
            self.musicView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.musicView.layer.borderColor = UIColor.lightGray.cgColor
            self.musicView.layer.borderWidth = 0.1
            self.musicView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.networking == true){
            userInterests.append("NETWORKING")
            self.networkingView.layer.borderColor = UIColor.orange.cgColor
            self.networkingView.layer.borderWidth = 1
            self.networkingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.networkingView.layer.borderColor = UIColor.lightGray.cgColor
            self.networkingView.layer.borderWidth = 0.1
            self.networkingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.outdoors == true){
            userInterests.append("OUTDOORS")
            self.outdoorsView.layer.borderColor = UIColor.orange.cgColor
            self.outdoorsView.layer.borderWidth = 1
            self.outdoorsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.outdoorsView.layer.borderColor = UIColor.lightGray.cgColor
            self.outdoorsView.layer.borderWidth = 0.1
            self.outdoorsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.shopping == true){
            userInterests.append("SHOPPING")
            self.shoppingView.layer.borderColor = UIColor.orange.cgColor
            self.shoppingView.layer.borderWidth = 1
            self.shoppingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.shoppingView.layer.borderColor = UIColor.lightGray.cgColor
            self.shoppingView.layer.borderWidth = 0.1
            self.shoppingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.sports == true){
            userInterests.append("SPORTS")
            self.sportsView.layer.borderColor = UIColor.orange.cgColor
            self.sportsView.layer.borderWidth = 1
            self.sportsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.sportsView.layer.borderColor = UIColor.lightGray.cgColor
            self.sportsView.layer.borderWidth = 0.1
            self.sportsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.technology == true){
            userInterests.append("TECHNOLOGY")
            self.techView.layer.borderColor = UIColor.orange.cgColor
            self.techView.layer.borderWidth = 1
            self.techView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.techView.layer.borderColor = UIColor.lightGray.cgColor
            self.techView.layer.borderWidth = 0.1
            self.techView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.theatre == true){
            userInterests.append("THEATRE")
            self.theatreView.layer.borderColor = UIColor.orange.cgColor
            self.theatreView.layer.borderWidth = 1
            self.theatreView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.theatreView.layer.borderColor = UIColor.lightGray.cgColor
            self.theatreView.layer.borderWidth = 0.1
            self.theatreView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.collegeLife == true){
            userInterests.append("COLLEGELIFE")
            self.collegeView.layer.borderColor = UIColor.orange.cgColor
            self.collegeView.layer.borderWidth = 1
            self.collegeView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.collegeView.layer.borderColor = UIColor.lightGray.cgColor
            self.collegeView.layer.borderWidth = 0.1
            self.collegeView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.partyDance == true){
            userInterests.append("PARTYDANCE")
            self.partyDanceView.layer.borderColor = UIColor.orange.cgColor
            self.partyDanceView.layer.borderWidth = 1
            self.partyDanceView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.partyDanceView.layer.borderColor = UIColor.lightGray.cgColor
            self.partyDanceView.layer.borderWidth = 0.1
            self.partyDanceView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        if (self.wineBrew == true){
            userInterests.append("WINEBREW")
            self.wineBrewView.layer.borderColor = UIColor.orange.cgColor
            self.wineBrewView.layer.borderWidth = 1
            self.wineBrewView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.wineBrewView.layer.borderColor = UIColor.lightGray.cgColor
            self.wineBrewView.layer.borderWidth = 0.1
            self.wineBrewView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        self.loadingView.stopAnimating()
    }


}
