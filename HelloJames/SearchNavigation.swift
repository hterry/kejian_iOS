//
//  SearchNavigation.swift
//  HelloJames
//
//  Created by Terry on 15/12/25.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit



class SearchNavigation:UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("AboutusViewNavigation-viewWillAppear")
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.hidden = false
        //self.navigationBar.topItem?.title = "关于我们"
        
        //UINavigationBar.appearance().barStyle
        UINavigationBar.appearance().barTintColor=UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        UINavigationBar.appearance().tintColor=appCloud().greenColor
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UINavigationBar.appearance().barTintColor=UIColor.blackColor()
        UINavigationBar.appearance().tintColor=UIColor.whiteColor()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    //获取总代理 
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
