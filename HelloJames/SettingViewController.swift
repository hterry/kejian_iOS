//
//  SettingViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/4.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage



class SettingViewController:UINavigationController{
    var menuViewController:SettingMenuViewController!
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("SettingViewController")
        //self.navigationController
        //self.navigationBar.hidden=false
        
        menuViewController = self.childViewControllers[0] as! SettingMenuViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        
        BaiduMobStat.defaultStat().pageviewStartWithName("设置")
        
        super.viewWillAppear(animated)
        //必须在viewWillAppear设置隐藏，interactivePopGestureRecognizer才能生效
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationBar.topItem?.title = "设置"
        
        //rightBarButtonItem和下一界面的backBarButtonItem要在第一个viewController设置
        menuViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "closeView")
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        menuViewController.navigationItem.backBarButtonItem = backItem
        
        UINavigationBar.appearance().barTintColor=UIColor.blackColor()
        UINavigationBar.appearance().tintColor=UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:appCloud().greenColor]
        
        if(appCloud().isPushOpen){
            menuViewController.pushBtn.backgroundColor = appCloud().greenColor
            menuViewController.pushBtnLabel.text = "已开启"
        }
        else {
            menuViewController.pushBtn.backgroundColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)
            menuViewController.pushBtnLabel.text = "未开启"
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("设置")
    }
    
    func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            
        },completion:nil)
    }
    
    @IBAction func clearCacheSelect(){
        BaiduMobStat.defaultStat().logEvent("clearCacheClick", eventLabel: "")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            //图片缓存清除
            
            let sizeTotal = SDWebImageManager.sharedManager().imageCache.getSize() + UInt(NSURLCache.sharedURLCache().currentDiskUsage)
            
            let sizeNum = floor((Double(sizeTotal/1024)/1024)*100)/100
            
            NSLog("size:%@",String(SDWebImageManager.sharedManager().imageCache.getSize()))
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            
            SDWebImageManager.sharedManager().imageCache.clearMemory()
            SDWebImageManager.sharedManager().imageCache.clearDisk()
            SDWebImageManager.sharedManager().imageCache.clearDiskOnCompletion( {
                ()-> Void in
                NSLog("size:%@",String(SDWebImageManager.sharedManager().imageCache.getSize()))
                
            })
            
            //self.appCloud().loadedArticleList = []
            self.alert = UIAlertController(title: "", message: "已清除"+String(sizeNum)+"MB缓存数据", preferredStyle: .Alert)
            //alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            self.presentViewController(self.alert, animated: true, completion: nil)
            
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "closeAlert", userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func gotoAppstoreScore(){
        BaiduMobStat.defaultStat().logEvent("scoreClick", eventLabel: "")
        
        UIApplication.sharedApplication().openURL(NSURL(string: appCloud().appStoreLink)!)
    }
    
    @IBAction func gotoSuggestView(){
        let suggestViewController = self.storyboard?.instantiateViewControllerWithIdentifier("suggestViewController") as! UIViewController!
        
        self.title = "提建议"
        //suggestViewController.navigationController?.navigationBar.topItem!.title = "提建议"
        self.pushViewController(suggestViewController, animated: true)
    }
    

    
    func closeAlert(){
        self.alert.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
}
