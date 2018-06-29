//
//  NewEventPagingViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit

class NewEventPagingViewController: UIPageViewController, UIPageViewControllerDataSource {

    //Navigation
    @IBOutlet weak var canceBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    //ViewList
    lazy var newEventVCList:[UIViewController] = {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let titleVC = storyboard.instantiateViewController(withIdentifier: "titleVC")
        let shortDescVC = storyboard.instantiateViewController(withIdentifier: "shortDescVC")
        
        return [titleVC, shortDescVC]
    }()
    
    var currentPageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Datasource
        self.dataSource = self
        
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
    @IBAction func didPressNext(_ sender: Any) {
        displayPageForIndex(index: self.currentPageIndex + 1, animated: true)
    }
    
}
