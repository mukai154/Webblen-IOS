//
//  EventCategoryViewController.swift
//  Webblen
//
//  Created by Mukai Selekwa on 9/20/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class EventCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var eventCategoryPicker: UIPickerView!
    @IBOutlet weak var addCategoryButton: UIButtonX!
    @IBOutlet weak var category1: UIImageView!
    @IBOutlet weak var category2: UIImageView!
    @IBOutlet weak var category3: UIImageView!
    
    var interests = ["Choose Category","Amusement", "Art", "College Life", "Community", "Competition", "Culture", "Education", "Entertainment", "Family", "Food & Drink", "Gaming", "Health & Fitness", "Music", "Networking", "Outdoors", "Party/Dance", "Shopping", "Sports", "Technology", "Theatre", "Wine & Brew"]
    
    var selectedCategory = "Choose Category"
    var eventCategories : [String] = []
    var stringCategories : [String] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //category picker
        eventCategoryPicker.delegate = self
        eventCategoryPicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Functions for Category Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interests.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interests[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = interests[row]
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didTapAdd(_ sender: Any) {
        if selectedCategory != "Choose Category"{
        
        if stringCategories.count < 3 {
        
        if selectedCategory != "FOODDRINK" || selectedCategory != "COLLEGELIFE" || selectedCategory != "HEALTHFITNESS" || selectedCategory != "PARTYDANCE" || selectedCategory != "WINEBREW" && !selectedCategory.contains(selectedCategory){
        stringCategories.append(selectedCategory)
            }

        else {
            if selectedCategory == "College Life"{
                stringCategories.append("College Life")
            }
            if selectedCategory == "Food & Drink"{
                stringCategories.append("Food & Drink")
            }
            if selectedCategory == "Health & Fitness"{
                stringCategories.append("Health & Fitness")
            }
            if selectedCategory == "Party/Dance"{
                stringCategories.append("Party/Dance")
            }
            if selectedCategory == "Wine & Brew"{
                stringCategories.append("Wine & Brew")
            }
            }
        }
        
        if selectedCategory == "College Life"{
            selectedCategory = "COLLEGELIFE"
        }
        if selectedCategory == "Food & Drink"{
            selectedCategory = "FOODDRINK"
        }
        if selectedCategory == "Health & Fitness"{
            selectedCategory = "HEALTHFITNESS"
        }
        if selectedCategory == "Party/Dance"{
            selectedCategory = "PARTYDANCE"
        }
        if selectedCategory == "Wine & Brew"{
            selectedCategory = "WINEBREW"
        }
        
        selectedCategory = selectedCategory.uppercased()
        
        if eventCategories.count < 3 {
            if !(eventCategories.contains(selectedCategory)){
               eventCategories.append(selectedCategory)
                category1.image = UIImage(named: eventCategories[0])
                
                if eventCategories.count == 2{
                category2.image = UIImage(named: eventCategories[1])
                }
                if eventCategories.count == 3{
                category3.image = UIImage(named: eventCategories[2])
                }
            }
        }
        else {
            addCategoryButton.isEnabled = false
            addCategoryButton.isHidden = true
        }
            
        }
    }
    
    @IBAction func didPressCat1(_ sender: Any) {
        if eventCategories.indices.contains(0){
            eventCategories.remove(at: 0)
            stringCategories.remove(at: 0)
            
            if eventCategories.indices.contains(0){
            category1.image = UIImage(named: eventCategories[0])
            }
            else {
                category1.image = nil
            }
            
            if eventCategories.indices.contains(1){
            category2.image = UIImage(named: eventCategories[1])
            }
            else {
                category2.image = nil
            }
            
            category3.image = nil
            
            addCategoryButton.isHidden = false
            addCategoryButton.isEnabled = true

        }
        
    }
    @IBAction func didPressCat2(_ sender: Any) {
        if eventCategories.indices.contains(1){
            eventCategories.remove(at: 1)
            stringCategories.remove(at: 1)
            
            if eventCategories.indices.contains(0){
                category1.image = UIImage(named: eventCategories[0])
            }
            else {
                category1.image = nil
            }
            
            if eventCategories.indices.contains(1){
                category2.image = UIImage(named: eventCategories[1])
            }
            else {
                category2.image = nil
            }
            
            category3.image = nil
            
            addCategoryButton.isHidden = false
            addCategoryButton.isEnabled = true

        }
    }
    @IBAction func didPressCat3(_ sender: Any) {
        if eventCategories.indices.contains(2){
            eventCategories.remove(at: 2)
            stringCategories.remove(at: 2)
            if eventCategories.indices.contains(0){
                category1.image = UIImage(named: eventCategories[0])
            }
            else {
                category1.image = nil
            }
            if eventCategories.indices.contains(1){
                category2.image = UIImage(named: eventCategories[1])
            }
            else {
                category2.image = nil
            }
            category3.image = nil
            
            addCategoryButton.isHidden = false
            addCategoryButton.isEnabled = true
        }
    }
    
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressSubmit(_ sender: Any) {
        
        //Send Data Back
        if let presenter = presentingViewController as? NewEventViewController {
            
            presenter.eventCategories = eventCategories
           
            if eventCategories.count > 0 {
            presenter.chooseEventCategoryButton.setTitle(stringCategories.joined(separator: ", "), for: .normal)
            }
            else {
            presenter.chooseEventCategoryButton.setTitle("Event Categories", for: .normal)
            }
        }
        print(eventCategories)
        dismiss(animated: true, completion: nil)
        
    }

}
