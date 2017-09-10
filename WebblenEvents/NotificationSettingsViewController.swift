//
//  NotificationSettingsViewController.swift
//  WebblenEvents
//
//  Created by Aditya Bhasin on 9/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let notifyWhen = ["Every Day", "Day Before Event", "Day Of Event" ]
    
    @IBOutlet weak var notifyLabel: UILabel!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notifyWhen[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notifyWhen.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notifyLabel.text = notifyWhen[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var notificationsPicker: UIPickerView!
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var distanceLabel: UILabel!
   
    @IBAction func distanceSlider(_ sender: UISlider) {
        
        distanceLabel.text = String(Int(sender.value)) + " mi"
    }
}
