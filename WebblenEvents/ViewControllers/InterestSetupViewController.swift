
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
    var btnBackground = UIImage(named: "orangeBackground")
    var activeBtnColor = UIColor(red: 254/255, green: 202/255, blue: 87/255, alpha: 1.0)
    var inactiveBtnColor = UIColor.clear
    var btnTintColor = UIColor(red: 30/255, green: 39/255, blue: 46/255, alpha: 1.0)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    interestsScrollView.alpha = 0.0
    //Activity indicator starts
    let xAxis = self.view.center.x
    let yAxis = self.view.center.y
    
    let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
    loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: btnTintColor, padding: 0)
    self.view.addSubview(loadingView)
    loadingView.startAnimating()
        
    //Set Btn Icons
        amusementBtn.setImage(amuseIcon, for: .normal)
        amusementBtn.tintColor = btnTintColor
        artBtn.setImage(artIcon, for: .normal)
        artBtn.tintColor = btnTintColor
        collegeBtn.setImage(collegeIcon, for: .normal)
        collegeBtn.tintColor = btnTintColor
        communityBtn.setImage(communIcon, for: .normal)
        communityBtn.tintColor = btnTintColor
        competitionBtn.setImage(compIcon, for: .normal)
        competitionBtn.tintColor = btnTintColor
        cultureBtn.setImage(cultIcon, for: .normal)
        cultureBtn.tintColor = btnTintColor
        educationBtn.setImage(edIcon, for: .normal)
        educationBtn.tintColor = btnTintColor
        entertainmentBtn.setImage(entIcon, for: .normal)
        entertainmentBtn.tintColor = btnTintColor
        familyBtn.setImage(famIcon, for: .normal)
        familyBtn.tintColor = btnTintColor
        foodDrinkBtn.setImage(foodIcon, for: .normal)
        foodDrinkBtn.tintColor = btnTintColor
        gamingBtn.setImage(gameIcon, for: .normal)
        gamingBtn.tintColor = btnTintColor
        healthFitnessBtn.setImage(healthIcon, for: .normal)
        healthFitnessBtn.tintColor = btnTintColor
        musicBtn.setImage(musicIcon, for: .normal)
        musicBtn.tintColor = btnTintColor
        networkingBtn.setImage(netIcon, for: .normal)
        networkingBtn.tintColor = btnTintColor
        outdoorsBtn.setImage(outIcon, for: .normal)
        outdoorsBtn.tintColor = btnTintColor
        partyDanceBtn.setImage(partyIcon, for: .normal)
        partyDanceBtn.tintColor = btnTintColor
        shoppingBtn.setImage(shopIcon, for: .normal)
        shoppingBtn.tintColor = btnTintColor
        sportsBtn.setImage(sportsIcon, for: .normal)
        sportsBtn.tintColor = btnTintColor
        techBtn.setImage(techIcon, for: .normal)
        techBtn.tintColor = btnTintColor
        theatreBtn.setImage(theatreIcon, for: .normal)
        theatreBtn.tintColor = btnTintColor
        wineBrewBtn.setImage(wineIcon, for: .normal)
        wineBrewBtn.tintColor = btnTintColor
        
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
            self.amusementBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            amusement = true
            self.userInterests.append("AMUSEMENT")
            self.amusementBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapArt(_ sender: Any) {
        if (art == true){
            art = false
            self.userInterests = self.userInterests.filter(){$0 != "ART"}
            self.artBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            art = true
            self.userInterests.append("ART")
            self.artBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapCollege(_ sender: Any) {
        if (collegeLife == true){
            collegeLife = false
            self.userInterests = self.userInterests.filter(){$0 != "COLLEGELIFE"}
            self.collegeBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            collegeLife = true
            self.userInterests.append("COLLEGELIFE")
            self.collegeBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapCommunity(_ sender: Any) {
        if (community == true){
            community = false
            self.userInterests = self.userInterests.filter(){$0 != "COMMUNITY"}
            self.communityBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            community = true
            self.userInterests.append("COMMUNITY")
            self.communityBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapCompetition(_ sender: Any) {
        if (competition == true){
            competition = false
            self.userInterests = self.userInterests.filter(){$0 != "COMPETITION"}
            self.competitionBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            competition = true
            self.userInterests.append("COMPETITION")
            self.competitionBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapCulture(_ sender: Any) {
        if (culture == true){
            culture = false
            self.userInterests = self.userInterests.filter(){$0 != "CULTURE"}
            self.cultureBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            culture = true
            self.userInterests.append("CULTURE")
            self.cultureBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapEducation(_ sender: Any) {
        if (education == true){
            education = false
            self.userInterests = self.userInterests.filter(){$0 != "EDUCATION"}
            self.educationBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            education = true
            self.userInterests.append("EDUCATION")
            self.educationBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapEntertainment(_ sender: Any) {
        if (entertainment == true){
            entertainment = false
            self.userInterests = self.userInterests.filter(){$0 != "ENTERTAINMENT"}
            self.entertainmentBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            entertainment = true
            self.userInterests.append("ENTERTAINMENT")
            self.entertainmentBtn.layer.borderColor = activeBtnColor.cgColor
        }
        
    }
    
    @IBAction func didTapFam(_ sender: Any) {
        if (family == true){
            family = false
            self.userInterests = self.userInterests.filter(){$0 != "FAMILY"}
            self.familyBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            family = true
            self.userInterests.append("FAMILY")
            self.familyBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapFoodDrink(_ sender: Any) {
        if (foodDrink == true){
            foodDrink = false
            self.userInterests = self.userInterests.filter(){$0 != "FOODDRINK"}
            self.foodDrinkBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            foodDrink = true
            self.userInterests.append("FOODDRINK")
            self.foodDrinkBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapGaming(_ sender: Any) {
        if (gaming == true){
            gaming = false
            self.userInterests = self.userInterests.filter(){$0 != "GAMING"}
            self.gamingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            gaming = true
            self.userInterests.append("GAMING")
            self.gamingBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapHealthFit(_ sender: Any) {
        if (healthFitness == true){
            healthFitness = false
            self.userInterests = self.userInterests.filter(){$0 != "HEALTHFITNESS"}
            self.healthFitnessBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            healthFitness = true
            self.userInterests.append("HEALTHFITNESS")
            self.healthFitnessBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapMusic(_ sender: Any) {
        if (music == true){
            music = false
            self.userInterests = self.userInterests.filter(){$0 != "MUSIC"}
            self.musicBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            music = true
            self.userInterests.append("MUSIC")
            self.musicBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    
    @IBAction func didTapNetworking(_ sender: Any) {
        if (networking == true){
            networking = false
            self.userInterests = self.userInterests.filter(){$0 != "NETWORKING"}
            self.networkingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            networking = true
            self.userInterests.append("NETWORKING")
            self.networkingBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapOutdoors(_ sender: Any) {
        if (outdoors == true){
            outdoors = false
            self.userInterests = self.userInterests.filter(){$0 != "OUTDOORS"}
            self.outdoorsBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            outdoors = true
            self.userInterests.append("OUTDOORS")
            self.outdoorsBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapParty(_ sender: Any) {
        if (partyDance == true){
            partyDance = false
            self.userInterests = self.userInterests.filter(){$0 != "PARTYDANCE"}
            self.partyDanceBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            partyDance = true
            self.userInterests.append("PARTYDANCE")
            self.partyDanceBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }

    @IBAction func didTapShopping(_ sender: Any) {
        if (shopping == true){
            shopping = false
            self.userInterests = self.userInterests.filter(){$0 != "SHOPPING"}
            self.shoppingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            shopping = true
            self.userInterests.append("SHOPPING")
            self.shoppingBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }

    @IBAction func didTapSports(_ sender: Any) {
        if (sports == true){
            sports = false
            self.userInterests = self.userInterests.filter(){$0 != "SPORTS"}
            self.sportsBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            sports = true
            self.userInterests.append("SPORTS")
            self.sportsBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    
    @IBAction func didTapTech(_ sender: Any) {
        if (technology == true){
            technology = false
            self.userInterests = self.userInterests.filter(){$0 != "TECHNOLOGY"}
            self.techBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            technology = true
            self.userInterests.append("TECHNOLOGY")
            self.techBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }
    

    @IBAction func didTapTheatre(_ sender: Any) {
        if (theatre == true){
            theatre = false
            self.userInterests = self.userInterests.filter(){$0 != "THEATRE"}
            self.theatreBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            theatre = true
            self.userInterests.append("THEATRE")
            self.theatreBtn.layer.borderColor = activeBtnColor.cgColor
        }
    }

    @IBAction func didTapWineBrew(_ sender: Any) {
        if (wineBrew == true){
            wineBrew = false
            self.userInterests = self.userInterests.filter(){$0 != "WINEBREW"}
            self.wineBrewBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        else{
            wineBrew = true
            self.userInterests.append("WINEBREW")
            self.wineBrewBtn.layer.borderColor = activeBtnColor.cgColor
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
            self.amusementBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.amusementBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.art == true){
            userInterests.append("ART")
            self.artBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.artBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.community == true){
            userInterests.append("COMMUNITY")
            self.communityBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.communityBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.culture == true){
            userInterests.append("CULTURE")
            self.cultureBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.cultureBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.competition == true){
            userInterests.append("COMPETITION")
            self.competitionBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.competitionBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.education == true){
            userInterests.append("EDUCATION")
            self.educationBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.educationBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.entertainment == true){
            userInterests.append("ENTERTAINMENT")
            self.entertainmentBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.entertainmentBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.family == true){
            userInterests.append("FAMILY")
            self.familyBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.familyBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.foodDrink == true){
            userInterests.append("FOODDRINK")
            self.foodDrinkBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.foodDrinkBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.gaming == true){
            userInterests.append("GAMING")
            self.gamingBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.gamingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.healthFitness == true){
            userInterests.append("HEALTHFITNESS")
            self.healthFitnessBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.healthFitnessBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.music == true){
            userInterests.append("MUSIC")
            self.musicBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.musicBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.networking == true){
            userInterests.append("NETWORKING")
            self.networkingBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.networkingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.outdoors == true){
            userInterests.append("OUTDOORS")
            self.outdoorsBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.outdoorsBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.shopping == true){
            userInterests.append("SHOPPING")
            self.shoppingBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.shoppingBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.sports == true){
            userInterests.append("SPORTS")
            self.sportsBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.sportsBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.technology == true){
            userInterests.append("TECHNOLOGY")
            self.techBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.techBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.theatre == true){
            userInterests.append("THEATRE")
            self.theatreBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.theatreBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.collegeLife == true){
            userInterests.append("COLLEGELIFE")
            self.collegeBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.collegeBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.partyDance == true){
            userInterests.append("PARTYDANCE")
            self.partyDanceBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.partyDanceBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        
        if (self.wineBrew == true){
            userInterests.append("WINEBREW")
            self.wineBrewBtn.layer.borderColor = activeBtnColor.cgColor
        }
        else{
            self.wineBrewBtn.layer.borderColor = inactiveBtnColor.cgColor
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.interestsScrollView.alpha = 1.0
        }, completion: { _ in
            self.interestsScrollView.isHidden = false
            self.loadingView.stopAnimating()
        })
    }


}
