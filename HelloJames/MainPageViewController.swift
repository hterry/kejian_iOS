//
//  MainPageViewController.swift
//  HelloJames
//
//  Created by Terry on 15/11/20.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    //var viewControllers: = NSMutableArray()
    var viewList:[UIViewController] = []
    var currentPage:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("MainPageViewController")
        for i in 0...2{
            
            self.viewList.append((storyboard?.instantiateViewControllerWithIdentifier("indexViewController"))!)
            
            //NSLog("%d", i)
            
        }
        
        //NSLog("%@",String(self.viewControllers))
        
    }
    
    //------------Delegate--------------
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        return .Min
    }
    
    
    func pageViewControllerPreferredInterfaceOrientationForPresentation(pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return .Portrait
    }
    
    //-------------DataSource-----------------
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        currentPage--
        if currentPage < 0 {
            currentPage = 0
            return nil
        }
        
        return self.viewList[currentPage]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        currentPage++
        if currentPage > 3 {
            currentPage = 3
            return nil
        }
        return self.viewList[currentPage]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentPage
    }

}
