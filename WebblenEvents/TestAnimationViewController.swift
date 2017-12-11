//
//  TestAnimationViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 12/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TestAnimationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let xAxis = self.view.center.x // or use (view.frame.size.width / 2) // or use (faqWebView.frame.size.width / 2)
        let yAxis = self.view.center.y // or use (view.frame.size.height / 2) // or use (faqWebView.frame.size.height / 2)
        
        let frame = CGRect(x: (xAxis - 50), y: (yAxis - 50), width: 45, height: 45)
        let loadingView = NVActivityIndicatorView(frame: frame, type: .orbit, color: UIColor.red, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
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

}
