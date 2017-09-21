//
//  EventCategoryViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 9/20/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class EventCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var eventCategoryPicker: UIPickerView!
    
    var interests = ["Choose Category","Amusement", "Art", "College Life", "Community", "Competition", "Culture", "Education", "Entertainment", "Family", "Food & Drink", "Gaming", "Health & Fitness", "Music", "Networking", "Outdoors", "Party/Dance", "Shopping", "Sports", "Technology", "Theatre", "Wine & Brew"]
    
    var eventCategory = "Choose Category"
    
    
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
        eventCategory = interests[row]
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressSubmit(_ sender: Any) {
        
        //Send Data Back
        if let presenter = presentingViewController as? NewEventViewController {
            
            presenter.eventCategory = eventCategory
            presenter.chooseEventCategoryButton.setTitle(eventCategory, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}
