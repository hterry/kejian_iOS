//
//  AboutusNavigation.swift
//  HelloJames
//
//  Created by Terry on 15/12/8.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit



class AboutusViewNavigation:UINavigationController{
    
    override func viewWillAppear(animated: Bool) {
        NSLog("AboutusViewNavigation-viewWillAppear")
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.hidden = false
        self.navigationBar.topItem?.title = "关于我们"
        
        UINavigationBar.appearance().barTintColor=UIColor.blackColor()
        UINavigationBar.appearance().tintColor=UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:appCloud().redColor]
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
