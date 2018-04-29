
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
    @IBOutlet weak var interestsScrollView: UIScrollView!
    @IBOutlet weak var navBackground: UIView!
    @IBOutlet weak var cancelOption: UIBarButtonItem!
    @IBOutlet weak var amusementBtn: UIButtonX!
    @IBOutlet weak var artBtn: UIButtonX!
    @IBOutlet weak var collegeBtn: UIButtonX!
    @IBOutlet weak var communityBtn: UIButtonX!
    @IBOutlet weak var competitionBtn: UIButtonX!
    @IBOutlet weak var cultureBtn: UIButtonX!
    @IBOutlet weak var educationBtn: UIButtonX!
    @IBOutlet weak var entertainmentBtn: UIButtonX!
    @IBOutlet weak var familyBtn: UIButtonX!
    @IBOutlet weak var foodDrinkBtn: UIButtonX!
    @IBOutlet weak var gamingBtn: UIButtonX!
    @IBOutlet weak var healthFitnessBtn: UIButtonX!
    @IBOutlet weak var musicBtn: UIButtonX!
    @IBOutlet weak var networkingBtn: UIButtonX!
    @IBOutlet weak var outdoorsBtn: UIButtonX!
    @IBOutlet weak var partyDanceBtn: UIButtonX!
    @IBOutlet weak var shoppingBtn: UIButtonX!
    @IBOutlet weak var sportsBtn: UIButtonX!
    @IBOutlet weak var techBtn: UIButtonX!
    @IBOutlet weak var theatreBtn: UIButtonX!
    @IBOutlet weak var wineBrewBtn: UIButtonX!
    
    //Icons
    var amuseIcon = UIImage(named: "AMUSEMENT")?.withRenderingMode(.alwaysTemplate)
    var artIcon = UIImage(named: "ART")?.withRenderingMode(.alwaysTemplate)
    var collegeIcon = UIImage(named: "COLLEGELIFE")?.withRenderingMode(.alwaysTemplate)
    var communIcon = UIImage(named: "COMMUNITY")?.withRenderingMode(.alwaysTemplate)
    var compIcon = UIImage(named: "COMPETITION")?.withRenderingMode(.alwaysTemplate)
    var cultIcon = UIImage(named: "CULTURE")?.withRenderingMode(.alwaysTemplate)
    var edIcon = UIImage(named: "EDUCATION")?.withRenderingMode(.alwaysTemplate)
    var entIcon = UIImage(named: "ENTERTAINMENT")?.withRenderingMode(.alwaysTemplate)
    var famIcon = UIImage(named: "FAMILY")?.withRenderingMode(.alwaysTemplate)
    var foodIcon = UIImage(named: "FOODDRINK")?.withRenderingMode(.alwaysTemplate)
    var gameIcon = UIImage(named: "GAMING")?.withRenderingMode(.alwaysTemplate)
    var healthIcon = UIImage(named: "HEALTHFITNESS")?.withRenderingMode(.alwaysTemplate)
    var musicIcon = UIImage(named: "MUSIC")?.withRenderingMode(.alwaysTemplate)
    var netIcon = UIImage(named: "NETWORKING")?.withRenderingMode(.alwaysTemplate)
    var outIcon = UIImage(named: "OUTDOORS")?.withRenderingMode(.alwaysTemplate)
    var partyIcon = UIImage(named: "PARTYDANCE")?.withRenderingMode(.alwaysTemplate)
    var shopIcon = UIImage(named: "SHOPPING")?.withRenderingMode(.alwaysTemplate)
    var sportsIcon = UIImage(named: "SPORTS")?.withRenderingMode(.alwaysTemplate)
    var techIcon = UIImage(named: "TECHNOLOGY")?.withRenderingMode(.alwaysTemplate)
    var theatreIcon = UIImage(named: "THEATRE")?.withRenderingMode(.alwaysTemplate)
    var wineIcon = UIImage(named: "WINEBREW")?.withRenderingMode(.alwaysTemplate)


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
    
    //Extras
    var btnBackground = UIImage(named: "pastelOrange")
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    interestsScrollView.alpha = 0.0
    //Activity indicator starts
    let xAxis = self.view.center.x
    let yAxis = self.view.center.y
    
    let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
    loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0), padding: 0)
    self.view.addSubview(loadingView)
    loadingView.startAnimating()
        
    //Set Btn Icons
        amusementBtn.setImage(amuseIcon, for: .normal)
        amusementBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        artBtn.setImage(artIcon, for: .normal)
        artBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        collegeBtn.setImage(collegeIcon, for: .normal)
        collegeBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        communityBtn.setImage(communIcon, for: .normal)
        communityBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        competitionBtn.setImage(compIcon, for: .normal)
        competitionBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        cultureBtn.setImage(cultIcon, for: .normal)
        cultureBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        educationBtn.setImage(edIcon, for: .normal)
        educationBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        entertainmentBtn.setImage(entIcon, for: .normal)
        entertainmentBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        familyBtn.setImage(famIcon, for: .normal)
        familyBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        foodDrinkBtn.setImage(foodIcon, for: .normal)
        foodDrinkBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        gamingBtn.setImage(gameIcon, for: .normal)
        gamingBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        healthFitnessBtn.setImage(healthIcon, for: .normal)
        healthFitnessBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        musicBtn.setImage(musicIcon, for: .normal)
        musicBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        networkingBtn.setImage(netIcon, for: .normal)
        networkingBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        outdoorsBtn.setImage(outIcon, for: .normal)
        outdoorsBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        partyDanceBtn.setImage(partyIcon, for: .normal)
        partyDanceBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        shoppingBtn.setImage(shopIcon, for: .normal)
        shoppingBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        sportsBtn.setImage(sportsIcon, for: .normal)
        sportsBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        techBtn.setImage(techIcon, for: .normal)
        techBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        theatreBtn.setImage(theatreIcon, for: .normal)
        theatreBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        wineBrewBtn.setImage(wineIcon, for: .normal)
        wineBrewBtn.tintColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        
    //If first time...
        if settingUp == true {
            cancelOption.isEnabled = false
        }
    //Get current interests
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
    @IBAction func didTapAmusement(_ sender: Any) {
        if (amusement == true){
            amusement = false
            self.userInterests = self.userInterests.filter(){$0 != "AMUSEMENT"}
            self.amusementBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.amusementBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            amusement = true
            self.userInterests.append("AMUSEMENT")
            self.amusementBtn.tintColor = UIColor.white
            self.amusementBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapArt(_ sender: Any) {
        if (art == true){
            art = false
            self.userInterests = self.userInterests.filter(){$0 != "ART"}
            self.artBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.artBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            art = true
            self.userInterests.append("ART")
            self.artBtn.tintColor = UIColor.white
            self.artBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapCollege(_ sender: Any) {
        if (collegeLife == true){
            collegeLife = false
            self.userInterests = self.userInterests.filter(){$0 != "COLLEGELIFE"}
            self.collegeBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.collegeBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            collegeLife = true
            self.userInterests.append("COLLEGELIFE")
            self.collegeBtn.tintColor = UIColor.white
            self.collegeBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapCommunity(_ sender: Any) {
        if (community == true){
            community = false
            self.userInterests = self.userInterests.filter(){$0 != "COMMUNITY"}
            self.communityBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.communityBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            community = true
            self.userInterests.append("COMMUNITY")
            self.communityBtn.tintColor = UIColor.white
            self.communityBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapCompetition(_ sender: Any) {
        if (competition == true){
            competition = false
            self.userInterests = self.userInterests.filter(){$0 != "COMPETITION"}
            self.competitionBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.competitionBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            competition = true
            self.userInterests.append("COMPETITION")
            self.competitionBtn.tintColor = UIColor.white
            self.competitionBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapCulture(_ sender: Any) {
        if (culture == true){
            culture = false
            self.userInterests = self.userInterests.filter(){$0 != "CULTURE"}
            self.cultureBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.cultureBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            culture = true
            self.userInterests.append("CULTURE")
            self.cultureBtn.tintColor = UIColor.white
            self.cultureBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapEducation(_ sender: Any) {
        if (education == true){
            education = false
            self.userInterests = self.userInterests.filter(){$0 != "EDUCATION"}
            self.educationBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.educationBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            education = true
            self.userInterests.append("EDUCATION")
            self.educationBtn.tintColor = UIColor.white
            self.educationBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapEntertainment(_ sender: Any) {
        if (entertainment == true){
            entertainment = false
            self.userInterests = self.userInterests.filter(){$0 != "ENTERTAINMENT"}
            self.entertainmentBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.entertainmentBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            entertainment = true
            self.userInterests.append("ENTERTAINMENT")
            self.entertainmentBtn.tintColor = UIColor.white
            self.entertainmentBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        
    }
    
    @IBAction func didTapFam(_ sender: Any) {
        if (family == true){
            family = false
            self.userInterests = self.userInterests.filter(){$0 != "FAMILY"}
            self.familyBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.familyBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            family = true
            self.userInterests.append("FAMILY")
            self.familyBtn.tintColor = UIColor.white
            self.familyBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapFoodDrink(_ sender: Any) {
        if (foodDrink == true){
            foodDrink = false
            self.userInterests = self.userInterests.filter(){$0 != "FOODDRINK"}
            self.foodDrinkBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.foodDrinkBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            foodDrink = true
            self.userInterests.append("FOODDRINK")
            self.foodDrinkBtn.tintColor = UIColor.white
            self.foodDrinkBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapGaming(_ sender: Any) {
        if (gaming == true){
            gaming = false
            self.userInterests = self.userInterests.filter(){$0 != "GAMING"}
            self.gamingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.gamingBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            gaming = true
            self.userInterests.append("GAMING")
            self.gamingBtn.tintColor = UIColor.white
            self.gamingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapHealthFit(_ sender: Any) {
        if (healthFitness == true){
            healthFitness = false
            self.userInterests = self.userInterests.filter(){$0 != "HEALTHFITNESS"}
            self.healthFitnessBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.healthFitnessBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            healthFitness = true
            self.userInterests.append("HEALTHFITNESS")
            self.healthFitnessBtn.tintColor = UIColor.white
            self.healthFitnessBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapMusic(_ sender: Any) {
        if (music == true){
            music = false
            self.userInterests = self.userInterests.filter(){$0 != "MUSIC"}
            self.musicBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.musicBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            music = true
            self.userInterests.append("MUSIC")
            self.musicBtn.tintColor = UIColor.white
            self.musicBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    
    @IBAction func didTapNetworking(_ sender: Any) {
        if (networking == true){
            networking = false
            self.userInterests = self.userInterests.filter(){$0 != "NETWORKING"}
            self.networkingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.networkingBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            networking = true
            self.userInterests.append("NETWORKING")
            self.networkingBtn.tintColor = UIColor.white
            self.networkingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapOutdoors(_ sender: Any) {
        if (outdoors == true){
            outdoors = false
            self.userInterests = self.userInterests.filter(){$0 != "OUTDOORS"}
            self.outdoorsBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.outdoorsBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            outdoors = true
            self.userInterests.append("OUTDOORS")
            self.outdoorsBtn.tintColor = UIColor.white
            self.outdoorsBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapParty(_ sender: Any) {
        if (partyDance == true){
            partyDance = false
            self.userInterests = self.userInterests.filter(){$0 != "PARTYDANCE"}
            self.partyDanceBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.partyDanceBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            partyDance = true
            self.userInterests.append("PARTYDANCE")
            self.partyDanceBtn.tintColor = UIColor.white
            self.partyDanceBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }

    @IBAction func didTapShopping(_ sender: Any) {
        if (shopping == true){
            shopping = false
            self.userInterests = self.userInterests.filter(){$0 != "SHOPPING"}
            self.shoppingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.shoppingBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            shopping = true
            self.userInterests.append("SHOPPING")
            self.shoppingBtn.tintColor = UIColor.white
            self.shoppingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }

    @IBAction func didTapSports(_ sender: Any) {
        if (sports == true){
            sports = false
            self.userInterests = self.userInterests.filter(){$0 != "SPORTS"}
            self.sportsBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.sportsBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            sports = true
            self.userInterests.append("SPORTS")
            self.sportsBtn.tintColor = UIColor.white
            self.sportsBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    
    @IBAction func didTapTech(_ sender: Any) {
        if (technology == true){
            technology = false
            self.userInterests = self.userInterests.filter(){$0 != "TECHNOLOGY"}
            self.techBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.techBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            technology = true
            self.userInterests.append("TECHNOLOGY")
            self.techBtn.tintColor = UIColor.white
            self.techBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }
    

    @IBAction func didTapTheatre(_ sender: Any) {
        if (theatre == true){
            theatre = false
            self.userInterests = self.userInterests.filter(){$0 != "THEATRE"}
            self.theatreBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.theatreBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            theatre = true
            self.userInterests.append("THEATRE")
            self.theatreBtn.tintColor = UIColor.white
            self.theatreBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }

    @IBAction func didTapWineBrew(_ sender: Any) {
        if (wineBrew == true){
            wineBrew = false
            self.userInterests = self.userInterests.filter(){$0 != "WINEBREW"}
            self.wineBrewBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.wineBrewBtn.setBackgroundImage(nil, for: .normal)
        }
        else{
            wineBrew = true
            self.userInterests.append("WINEBREW")
            self.wineBrewBtn.tintColor = UIColor.white
            self.wineBrewBtn.setBackgroundImage(btnBackground, for: .normal)
        }
    }

//-------INTEREST BUTTONS

    
    @IBAction func didTapUpdate(_ sender: Any) {
        loadingView.startAnimating()
        database.collection("users").document((currentUser?.uid)!).setData(["interests": userInterests], options: SetOptions.merge())
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
            self.amusementBtn.tintColor = UIColor.white
            self.amusementBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.amusementBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.amusementBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.art == true){
            userInterests.append("ART")
            self.artBtn.tintColor = UIColor.white
            self.artBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.artBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.artBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.community == true){
            userInterests.append("COMMUNITY")
            self.communityBtn.tintColor = UIColor.white
            self.communityBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.communityBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.communityBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.culture == true){
            userInterests.append("CULTURE")
            self.cultureBtn.tintColor = UIColor.white
            self.cultureBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.cultureBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.cultureBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.competition == true){
            userInterests.append("COMPETITION")
            self.competitionBtn.tintColor = UIColor.white
            self.competitionBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.competitionBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.competitionBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.education == true){
            userInterests.append("EDUCATION")
            self.educationBtn.tintColor = UIColor.white
            self.educationBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.educationBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.educationBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.entertainment == true){
            userInterests.append("ENTERTAINMENT")
            self.entertainmentBtn.tintColor = UIColor.white
            self.entertainmentBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.entertainmentBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.entertainmentBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.family == true){
            userInterests.append("FAMILY")
            self.familyBtn.tintColor = UIColor.white
            self.familyBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.familyBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.familyBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.foodDrink == true){
            userInterests.append("FOODDRINK")
            self.foodDrinkBtn.tintColor = UIColor.white
            self.foodDrinkBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.foodDrinkBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.foodDrinkBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.gaming == true){
            userInterests.append("GAMING")
            self.gamingBtn.tintColor = UIColor.white
            self.gamingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.gamingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.gamingBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.healthFitness == true){
            userInterests.append("HEALTHFITNESS")
            self.healthFitnessBtn.tintColor = UIColor.white
            self.healthFitnessBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.healthFitnessBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.healthFitnessBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.music == true){
            userInterests.append("MUSIC")
            self.musicBtn.tintColor = UIColor.white
            self.musicBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.musicBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.musicBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.networking == true){
            userInterests.append("NETWORKING")
            self.networkingBtn.tintColor = UIColor.white
            self.networkingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.networkingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.networkingBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.outdoors == true){
            userInterests.append("OUTDOORS")
            self.outdoorsBtn.tintColor = UIColor.white
            self.outdoorsBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.outdoorsBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.outdoorsBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.shopping == true){
            userInterests.append("SHOPPING")
            self.shoppingBtn.tintColor = UIColor.white
            self.shoppingBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.shoppingBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.shoppingBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.sports == true){
            userInterests.append("SPORTS")
            self.sportsBtn.tintColor = UIColor.white
            self.sportsBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.sportsBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.sportsBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.technology == true){
            userInterests.append("TECHNOLOGY")
            self.techBtn.tintColor = UIColor.white
            self.techBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.techBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.techBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.theatre == true){
            userInterests.append("THEATRE")
            self.theatreBtn.tintColor = UIColor.white
            self.theatreBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.theatreBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.theatreBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.collegeLife == true){
            userInterests.append("COLLEGELIFE")
            self.collegeBtn.tintColor = UIColor.white
            self.collegeBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.collegeBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.collegeBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.partyDance == true){
            userInterests.append("PARTYDANCE")
            self.partyDanceBtn.tintColor = UIColor.white
            self.partyDanceBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.partyDanceBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.partyDanceBtn.setBackgroundImage(nil, for: .normal)
        }
        
        if (self.wineBrew == true){
            userInterests.append("WINEBREW")
            self.wineBrewBtn.tintColor = UIColor.white
            self.wineBrewBtn.setBackgroundImage(btnBackground, for: .normal)
        }
        else{
            self.wineBrewBtn.tintColor = UIColor(red: 66/300, green: 66/300, blue: 66/300, alpha: 1.0)
            self.wineBrewBtn.setBackgroundImage(nil, for: .normal)
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.interestsScrollView.alpha = 1.0
        }, completion: { _ in
            self.interestsScrollView.isHidden = false
            self.loadingView.stopAnimating()
        })
    }


}
