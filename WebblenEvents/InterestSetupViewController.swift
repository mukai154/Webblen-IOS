
//
//  InterestSetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class InterestSetupViewController: UIViewController {


//Outlets
    @IBOutlet weak var navBackground: UIView!
    
    
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
    var college = false
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
    

    //Firebase references
    var dataBaseRef = FIRDatabase.database().reference()
    var currentUser: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //Activity indicator starts
    activityIndicator.startAnimating()
    
    //Check for current user
    currentUser = FIRAuth.auth()?.currentUser
    
    //Set up current interests
    dataBaseRef.child("Users").child(self.currentUser!.uid).child("interests").observe(.value, with: { (snapshot) in
        
        self.amusement = snapshot.childSnapshot(forPath: "AMUSEMENT").value as! Bool
        if (self.amusement == true){
            self.amusementView.layer.borderColor = UIColor.orange.cgColor
            self.amusementView.layer.borderWidth = 1
            self.amusementView.layer.cornerRadius = CGFloat(Float(25.0))
            
        }
        else{
            self.amusementView.layer.borderColor = UIColor.lightGray.cgColor
            self.amusementView.layer.borderWidth = 0.1
            self.amusementView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.art = snapshot.childSnapshot(forPath: "ART").value as! Bool
        if (self.art == true){
            self.artView.layer.borderColor = UIColor.orange.cgColor
            self.artView.layer.borderWidth = 1
            self.artView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.artView.layer.borderColor = UIColor.lightGray.cgColor
            self.artView.layer.borderWidth = 0.1
            self.artView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.community = snapshot.childSnapshot(forPath: "COMMUNITY").value as! Bool
        if (self.community == true){
            self.communityView.layer.borderColor = UIColor.orange.cgColor
            self.communityView.layer.borderWidth = 1
            self.communityView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.communityView.layer.borderColor = UIColor.lightGray.cgColor
            self.communityView.layer.borderWidth = 0.1
            self.communityView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.culture = snapshot.childSnapshot(forPath: "CULTURE").value as! Bool
        if (self.culture == true){
            self.cultureView.layer.borderColor = UIColor.orange.cgColor
            self.cultureView.layer.borderWidth = 1
            self.cultureView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.cultureView.layer.borderColor = UIColor.lightGray.cgColor
            self.cultureView.layer.borderWidth = 0.1
            self.cultureView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.competition = snapshot.childSnapshot(forPath: "COMPETITION").value as! Bool
        if (self.competition == true){
            self.competitionView.layer.borderColor = UIColor.orange.cgColor
            self.competitionView.layer.borderWidth = 1
            self.competitionView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.competitionView.layer.borderColor = UIColor.lightGray.cgColor
            self.competitionView.layer.borderWidth = 0.1
            self.competitionView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.education = snapshot.childSnapshot(forPath: "EDUCATION").value as! Bool
        if (self.education == true){
            self.educationView.layer.borderColor = UIColor.orange.cgColor
            self.educationView.layer.borderWidth = 1
            self.educationView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.educationView.layer.borderColor = UIColor.lightGray.cgColor
            self.educationView.layer.borderWidth = 0.1
            self.educationView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.entertainment = snapshot.childSnapshot(forPath: "ENTERTAINMENT").value as! Bool
        if (self.entertainment == true){
            self.entertainmentView.layer.borderColor = UIColor.orange.cgColor
            self.entertainmentView.layer.borderWidth = 1
            self.entertainmentView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.entertainmentView.layer.borderColor = UIColor.lightGray.cgColor
            self.entertainmentView.layer.borderWidth = 0.1
            self.entertainmentView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.family = snapshot.childSnapshot(forPath: "FAMILY").value as! Bool
        if (self.family == true){
            self.familyView.layer.borderColor = UIColor.orange.cgColor
            self.familyView.layer.borderWidth = 1
            self.familyView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.familyView.layer.borderColor = UIColor.lightGray.cgColor
            self.familyView.layer.borderWidth = 0.1
            self.familyView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.foodDrink = snapshot.childSnapshot(forPath: "FOODDRINK").value as! Bool
        if (self.foodDrink == true){
            self.foodDrinkView.layer.borderColor = UIColor.orange.cgColor
            self.foodDrinkView.layer.borderWidth = 1
            self.foodDrinkView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.foodDrinkView.layer.borderColor = UIColor.lightGray.cgColor
            self.foodDrinkView.layer.borderWidth = 0.1
            self.foodDrinkView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.gaming = snapshot.childSnapshot(forPath: "GAMING").value as! Bool
        if (self.gaming == true){
            self.gamingView.layer.borderColor = UIColor.orange.cgColor
            self.gamingView.layer.borderWidth = 1
            self.gamingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.gamingView.layer.borderColor = UIColor.lightGray.cgColor
            self.gamingView.layer.borderWidth = 0.1
            self.gamingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.healthFitness = snapshot.childSnapshot(forPath: "HEALTHFITNESS").value as! Bool
        if (self.healthFitness == true){
            self.healthFitnessView.layer.borderColor = UIColor.orange.cgColor
            self.healthFitnessView.layer.borderWidth = 1
            self.healthFitnessView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.healthFitnessView.layer.borderColor = UIColor.lightGray.cgColor
            self.healthFitnessView.layer.borderWidth = 0.1
            self.healthFitnessView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.music = snapshot.childSnapshot(forPath: "MUSIC").value as! Bool
        if (self.music == true){
            self.musicView.layer.borderColor = UIColor.orange.cgColor
            self.musicView.layer.borderWidth = 1
            self.musicView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.musicView.layer.borderColor = UIColor.lightGray.cgColor
            self.musicView.layer.borderWidth = 0.1
            self.musicView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.networking = snapshot.childSnapshot(forPath: "NETWORKING").value as! Bool
        if (self.networking == true){
            self.networkingView.layer.borderColor = UIColor.orange.cgColor
            self.networkingView.layer.borderWidth = 1
            self.networkingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.networkingView.layer.borderColor = UIColor.lightGray.cgColor
            self.networkingView.layer.borderWidth = 0.1
            self.networkingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.outdoors = snapshot.childSnapshot(forPath: "OUTDOORS").value as! Bool
        if (self.outdoors == true){
            self.outdoorsView.layer.borderColor = UIColor.orange.cgColor
            self.outdoorsView.layer.borderWidth = 1
            self.outdoorsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.outdoorsView.layer.borderColor = UIColor.lightGray.cgColor
            self.outdoorsView.layer.borderWidth = 0.1
            self.outdoorsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.shopping = snapshot.childSnapshot(forPath: "SHOPPING").value as! Bool
        if (self.shopping == true){
            self.shoppingView.layer.borderColor = UIColor.orange.cgColor
            self.shoppingView.layer.borderWidth = 1
            self.shoppingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.shoppingView.layer.borderColor = UIColor.lightGray.cgColor
            self.shoppingView.layer.borderWidth = 0.1
            self.shoppingView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.sports = snapshot.childSnapshot(forPath: "SPORTS").value as! Bool
        if (self.sports == true){
            self.sportsView.layer.borderColor = UIColor.orange.cgColor
            self.sportsView.layer.borderWidth = 1
            self.sportsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.sportsView.layer.borderColor = UIColor.lightGray.cgColor
            self.sportsView.layer.borderWidth = 0.1
            self.sportsView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.technology = snapshot.childSnapshot(forPath: "TECHNOLOGY").value as! Bool
        if (self.technology == true){
            self.techView.layer.borderColor = UIColor.orange.cgColor
            self.techView.layer.borderWidth = 1
            self.techView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.techView.layer.borderColor = UIColor.lightGray.cgColor
            self.techView.layer.borderWidth = 0.1
            self.techView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.theatre = snapshot.childSnapshot(forPath: "THEATRE").value as! Bool
        if (self.theatre == true){
            self.theatreView.layer.borderColor = UIColor.orange.cgColor
            self.theatreView.layer.borderWidth = 1
            self.theatreView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.theatreView.layer.borderColor = UIColor.lightGray.cgColor
            self.theatreView.layer.borderWidth = 0.1
            self.theatreView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.college = snapshot.childSnapshot(forPath: "COLLEGELIFE").value as! Bool
        if (self.college == true){
            self.collegeView.layer.borderColor = UIColor.orange.cgColor
            self.collegeView.layer.borderWidth = 1
            self.collegeView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.collegeView.layer.borderColor = UIColor.lightGray.cgColor
            self.collegeView.layer.borderWidth = 0.1
            self.collegeView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.partyDance = snapshot.childSnapshot(forPath: "PARTYDANCE").value as! Bool
        if (self.partyDance == true){
            self.partyDanceView.layer.borderColor = UIColor.orange.cgColor
            self.partyDanceView.layer.borderWidth = 1
            self.partyDanceView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.partyDanceView.layer.borderColor = UIColor.lightGray.cgColor
            self.partyDanceView.layer.borderWidth = 0.1
            self.partyDanceView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
        self.wineBrew = snapshot.childSnapshot(forPath: "WINEBREW").value as! Bool
        if (self.wineBrew == true){
            self.wineBrewView.layer.borderColor = UIColor.orange.cgColor
            self.wineBrewView.layer.borderWidth = 1
            self.wineBrewView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        else{
            self.wineBrewView.layer.borderColor = UIColor.lightGray.cgColor
            self.wineBrewView.layer.borderWidth = 0.1
            self.wineBrewView.layer.cornerRadius = CGFloat(Float(25.0))
        }
        
    })
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    @IBAction func didPressAmusment(_ sender: Any) {
        if (amusement == true){
            amusement = false
            self.amusementView.layer.borderColor = UIColor.lightGray.cgColor
            self.amusementView.layer.borderWidth = 0.1
        }
        else{
            amusement = true
            self.amusementView.layer.borderColor = UIColor.orange.cgColor
            self.amusementView.layer.borderWidth = 1
    }
    }
    
    @IBAction func didPressArt(_ sender: Any) {
        if (art == true){
            art = false
            self.artView.layer.borderColor = UIColor.lightGray.cgColor
            self.artView.layer.borderWidth = 0.1
        }
        else{
            art = true
            self.artView.layer.borderColor = UIColor.orange.cgColor
            self.artView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressCollege(_ sender: Any) {
        if (college == true){
            college = false
            self.collegeView.layer.borderColor = UIColor.lightGray.cgColor
            self.collegeView.layer.borderWidth = 0.1
        }
        else{
            college = true
            self.collegeView.layer.borderColor = UIColor.orange.cgColor
            self.collegeView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressCommunity(_ sender: Any) {
        if (community == true){
            community = false
            self.communityView.layer.borderColor = UIColor.lightGray.cgColor
            self.communityView.layer.borderWidth = 0.1
        }
        else{
            community = true
            self.communityView.layer.borderColor = UIColor.orange.cgColor
            self.communityView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressCompetition(_ sender: Any) {
        if (competition == true){
            competition = false
            self.competitionView.layer.borderColor = UIColor.lightGray.cgColor
            self.competitionView.layer.borderWidth = 0.1
        }
        else{
            competition = true
            self.competitionView.layer.borderColor = UIColor.orange.cgColor
            self.competitionView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressCulture(_ sender: Any) {
        if (culture == true){
            culture = false
            self.cultureView.layer.borderColor = UIColor.lightGray.cgColor
            self.cultureView.layer.borderWidth = 0.1
        }
        else{
            culture = true
            self.cultureView.layer.borderColor = UIColor.orange.cgColor
            self.cultureView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressEducation(_ sender: Any) {
        if (education == true){
            education = false
            self.educationView.layer.borderColor = UIColor.lightGray.cgColor
            self.educationView.layer.borderWidth = 0.1
        }
        else{
            education = true
            self.educationView.layer.borderColor = UIColor.orange.cgColor
            self.educationView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressEntertainment(_ sender: Any) {
        if (entertainment == true){
            entertainment = false
            self.entertainmentView.layer.borderColor = UIColor.lightGray.cgColor
            self.entertainmentView.layer.borderWidth = 0.1
        }
        else{
            entertainment = true
            self.entertainmentView.layer.borderColor = UIColor.orange.cgColor
            self.entertainmentView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressFamily(_ sender: Any) {
        if (family == true){
            family = false
            self.familyView.layer.borderColor = UIColor.lightGray.cgColor
            self.familyView.layer.borderWidth = 0.1
        }
        else{
            family = true
            self.familyView.layer.borderColor = UIColor.orange.cgColor
            self.familyView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressFoodDrink(_ sender: Any) {
        if (foodDrink == true){
            foodDrink = false
            self.foodDrinkView.layer.borderColor = UIColor.lightGray.cgColor
            self.foodDrinkView.layer.borderWidth = 0.1
        }
        else{
            foodDrink = true
            self.foodDrinkView.layer.borderColor = UIColor.orange.cgColor
            self.foodDrinkView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressGaming(_ sender: Any) {
        if (gaming == true){
            gaming = false
            self.gamingView.layer.borderColor = UIColor.lightGray.cgColor
            self.gamingView.layer.borderWidth = 0.1
        }
        else{
            gaming = true
            self.gamingView.layer.borderColor = UIColor.orange.cgColor
            self.gamingView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressHealthFitness(_ sender: Any) {
        if (healthFitness == true){
            healthFitness = false
            self.healthFitnessView.layer.borderColor = UIColor.lightGray.cgColor
            self.healthFitnessView.layer.borderWidth = 0.1
        }
        else{
            healthFitness = true
            self.healthFitnessView.layer.borderColor = UIColor.orange.cgColor
            self.healthFitnessView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressMusic(_ sender: Any) {
        if (music == true){
            music = false
            self.musicView.layer.borderColor = UIColor.lightGray.cgColor
            self.musicView.layer.borderWidth = 0.1
        }
        else{
            music = true
            self.musicView.layer.borderColor = UIColor.orange.cgColor
            self.musicView.layer.borderWidth = 1
        }
    }
    @IBAction func didPressNetworking(_ sender: Any) {
        if (networking == true){
            networking = false
            self.networkingView.layer.borderColor = UIColor.lightGray.cgColor
            self.networkingView.layer.borderWidth = 0.1
        }
        else{
            networking = true
            self.networkingView.layer.borderColor = UIColor.orange.cgColor
            self.networkingView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressOutdoors(_ sender: Any) {
        if (outdoors == true){
            outdoors = false
            self.outdoorsView.layer.borderColor = UIColor.lightGray.cgColor
            self.outdoorsView.layer.borderWidth = 0.1
        }
        else{
            outdoors = true
            self.outdoorsView.layer.borderColor = UIColor.orange.cgColor
            self.outdoorsView.layer.borderWidth = 1
        }
    }
    
    @IBAction func didPressPartyDance(_ sender: Any) {
        if (partyDance == true){
            partyDance = false
            self.partyDanceView.layer.borderColor = UIColor.lightGray.cgColor
            self.partyDanceView.layer.borderWidth = 0.1
        }
        else{
            partyDance = true
            self.partyDanceView.layer.borderColor = UIColor.orange.cgColor
            self.partyDanceView.layer.borderWidth = 1
        }
    }

    @IBAction func didPressShopping(_ sender: Any) {
        if (shopping == true){
            shopping = false
            self.shoppingView.layer.borderColor = UIColor.lightGray.cgColor
            self.shoppingView.layer.borderWidth = 0.1
        }
        else{
            shopping = true
            self.shoppingView.layer.borderColor = UIColor.orange.cgColor
            self.shoppingView.layer.borderWidth = 1
        }
    }

    @IBAction func pressedSports(_ sender: Any) {
        
        if (sports == true){
            sports = false
            self.sportsView.layer.borderColor = UIColor.lightGray.cgColor
            self.sportsView.layer.borderWidth = 0.1
        }
        else{
            sports = true
            self.sportsView.layer.borderColor = UIColor.orange.cgColor
            self.sportsView.layer.borderWidth = 1
            
        }
        
    }
    @IBAction func didPressTechnology(_ sender: Any) {
        if (technology == true){
            technology = false
            self.techView.layer.borderColor = UIColor.lightGray.cgColor
            self.techView.layer.borderWidth = 0.1
        }
        else{
            technology = true
            self.techView.layer.borderColor = UIColor.orange.cgColor
            self.techView.layer.borderWidth = 1
            
        }
    }
    @IBAction func didPressTheatre(_ sender: Any) {
        if (theatre == true){
            theatre = false
            self.theatreView.layer.borderColor = UIColor.lightGray.cgColor
            self.theatreView.layer.borderWidth = 0.1
        }
        else{
            theatre = true
            self.theatreView.layer.borderColor = UIColor.orange.cgColor
            self.theatreView.layer.borderWidth = 1
        }
    }

    @IBAction func didPressWineBrew(_ sender: Any) {
        if (wineBrew == true){
            wineBrew = false
            self.wineBrewView.layer.borderColor = UIColor.lightGray.cgColor
            self.wineBrewView.layer.borderWidth = 0.1
        }
        else{
            wineBrew = true
            self.wineBrewView.layer.borderColor = UIColor.orange.cgColor
            self.wineBrewView.layer.borderWidth = 1
        }
    }
    

    
    @IBAction func didTapUpdateInterests(_ sender: Any) {
        let updateInterestsData = dataBaseRef.child("Users").child(self.currentUser!.uid).child("interests")
        
        //Activity Indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        updateInterestsData.child("AMUSEMENT").setValue(amusement)
        updateInterestsData.child("ART").setValue(art)
        updateInterestsData.child("COMMUNITY").setValue(community)
        updateInterestsData.child("COMPETITION").setValue(competition)
        updateInterestsData.child("CULTURE").setValue(culture)
        updateInterestsData.child("EDUCATION").setValue(education)
        updateInterestsData.child("ENTERTAINMENT").setValue(entertainment)
        updateInterestsData.child("FAMILY").setValue(family)
        updateInterestsData.child("FOODDRINK").setValue(foodDrink)
        updateInterestsData.child("GAMING").setValue(gaming)
        updateInterestsData.child("HEALTHFITNESS").setValue(healthFitness)
        updateInterestsData.child("MUSIC").setValue(music)
        updateInterestsData.child("NETWORKING").setValue(networking)
        updateInterestsData.child("OUTDOORS").setValue(outdoors)
        updateInterestsData.child("SHOPPING").setValue(shopping)
        updateInterestsData.child("SPORTS").setValue(sports)
        updateInterestsData.child("TECHNOLOGY").setValue(technology)
        updateInterestsData.child("THEATRE").setValue(theatre)
        
        updateInterestsData.child("COLLEGELIFE").setValue(college)
        updateInterestsData.child("PARTYDANCE").setValue(partyDance)
        updateInterestsData.child("WINEBREW").setValue(wineBrew)
        
        activityIndicator.stopAnimating()
        
        returnHome()
    }
    
    



    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func returnHome(){
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }


}
