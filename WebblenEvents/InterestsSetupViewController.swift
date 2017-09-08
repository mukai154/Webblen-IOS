//
//  InterestsSetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class InterestsSetupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var InterestsSetupCollectionView: UICollectionView!
    
    struct interestsObject {
        
        var interestName: String
        var interestPic: UIImage
        var interestSwitchIdentifier: String
        
    }
    
    var interestsArray: [interestsObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interestsArray.append(interestsObject(interestName: "Amusement", interestPic: UIImage(named:"carousel")!, interestSwitchIdentifier: "amusementSwitch"))
        interestsArray.append(interestsObject(interestName: "Art", interestPic: UIImage(named:"art")!, interestSwitchIdentifier: "artSwitch"))
        interestsArray.append(interestsObject(interestName: "Competition", interestPic: UIImage(named:"trophy")!, interestSwitchIdentifier: "competitionSwitch"))
        interestsArray.append(interestsObject(interestName: "Culture", interestPic: UIImage(named:"fan")!, interestSwitchIdentifier: "educationSwitch"))
        interestsArray.append(interestsObject(interestName: "Education", interestPic: UIImage(named:"classroom")!, interestSwitchIdentifier: "educationSwitch"))
        interestsArray.append(interestsObject(interestName: "Entertainment", interestPic: UIImage(named:"entertainment")!, interestSwitchIdentifier: "entertainmentSwitch"))
        interestsArray.append(interestsObject(interestName: "Family", interestPic: UIImage(named:"family")!, interestSwitchIdentifier: "familySwitch"))
        interestsArray.append(interestsObject(interestName: "Food & Drink", interestPic: UIImage(named:"food")!, interestSwitchIdentifier: "foodDrinkSwitch"))
        interestsArray.append(interestsObject(interestName: "Gaming", interestPic: UIImage(named:"joystick")!, interestSwitchIdentifier: "gamingSwitch"))
        interestsArray.append(interestsObject(interestName: "Health & Fitness", interestPic: UIImage(named:"floating")!, interestSwitchIdentifier: "healthFitnessSwitch"))
        interestsArray.append(interestsObject(interestName: "Music", interestPic: UIImage(named:"music")!, interestSwitchIdentifier: "musicSwitch"))
        interestsArray.append(interestsObject(interestName: "Networking", interestPic: UIImage(named:"handshake")!, interestSwitchIdentifier: "networkingSwitch"))
        interestsArray.append(interestsObject(interestName: "Outdoors", interestPic: UIImage(named:"forest")!, interestSwitchIdentifier: "outdoorsSwitch"))
        interestsArray.append(interestsObject(interestName: "Shopping", interestPic: UIImage(named:"shopping")!, interestSwitchIdentifier: "shoppingSwitch"))
        interestsArray.append(interestsObject(interestName: "Sports", interestPic: UIImage(named:"sport")!, interestSwitchIdentifier: "sportsSwitch"))
        interestsArray.append(interestsObject(interestName: "Technology", interestPic: UIImage(named:"technology")!, interestSwitchIdentifier: "technologySwitch"))
        interestsArray.append(interestsObject(interestName: "Theatre", interestPic: UIImage(named:"theatre")!, interestSwitchIdentifier: "theatreSwitch"))
        
        InterestsSetupCollectionView.delegate = self
        
        InterestsSetupCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interests_cell", for: indexPath) as! InterestsSetupCollectionViewCell
        cell.interestsLabel.text = interestsArray[indexPath.item].interestName
        cell.interestsImageView.image = interestsArray[indexPath.item].interestPic
        cell.interestsSwitch.accessibilityIdentifier = interestsArray[indexPath.item].interestSwitchIdentifier
        return cell
    }
}
