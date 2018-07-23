//
//  NewEventPagingViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit

class NewEventPagingViewController: UIPageViewController, UIPageViewControllerDataSource {

    //New Event
    var newEvent = EventPost.init(eventKey: "", title: "", caption: "", description: "", pathToImage: "", uploadedImage: "", address: "", lat: 0, lon: 0, radius: 0, distanceFromUser: 0.0, tags: [""], startDate: "", endDate: "", startTime: "", endTime: "", published: false, hasMessageBoard: false, messageBoardPassword: "", author: "", authorImagePath: "", verified: false, promoted: false, views: 0, event18: false, event21: false, explicit: false, attendanceRecordID: "", spotsAvailable: 0, reservePrice: 0, website: "", fbSite: "", twitterSite: "")
    var newEventImage: UIImage?
    
    //Navigation
    @IBOutlet weak var canceBtn: UIBarButtonItem!
    
    //ViewList
    lazy var newEventVCList:[UIViewController] = {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let titleVC = storyboard.instantiateViewController(withIdentifier: "titleVC")
        let shortDescVC = storyboard.instantiateViewController(withIdentifier: "shortDescVC")
        let tagsVC = storyboard.instantiateViewController(withIdentifier: "tagsVC")
        let dateVC = storyboard.instantiateViewController(withIdentifier: "dateVC")
        let timeVC = storyboard.instantiateViewController(withIdentifier: "timeVC")
        let externalSitesVC = storyboard.instantiateViewController(withIdentifier: "externalSitesVC")
        let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC")
        let confirmVC = storyboard.instantiateViewController(withIdentifier: "confirmVC")
        
        return [titleVC, shortDescVC, tagsVC, dateVC, timeVC, externalSitesVC, addressVC, confirmVC]
    }()
    
    var currentPageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI
        view.backgroundColor = .white
        
        //First Page
        if let firstVC = newEventVCList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            self.currentPageIndex = 0
        }
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = newEventVCList.index(of: viewController) else {return nil}
        self.currentPageIndex = vcIndex
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard newEventVCList.count > previousIndex else {return nil}
        
        return newEventVCList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = newEventVCList.index(of: viewController) else {return nil}
        self.currentPageIndex = vcIndex
        let nextIndex = vcIndex + 1
        guard nextIndex != 0 else {return nil}
        guard newEventVCList.count > nextIndex else {return nil}
        
        return newEventVCList[nextIndex]
    }
    
    func displayPageForIndex(index: Int, animated: Bool = true) {
        assert(index >= 0 && index < self.newEventVCList.count, "Error: Attempting to display a page for an out of bounds index")
        
        // nop if index == self.currentPageIndex
        if self.currentPageIndex == index { return }
        
        if index < self.currentPageIndex {
            self.setViewControllers([self.newEventVCList[index]], direction: .reverse, animated: true, completion: nil)
        } else if index > self.currentPageIndex {
            self.setViewControllers([self.newEventVCList[index]], direction: .forward, animated: true, completion: nil)
        }
        
        self.currentPageIndex = index
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
