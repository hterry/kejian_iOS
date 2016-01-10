//
//  AboutusViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/8.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit
import JavaScriptCore
import MessageUI


class AboutusViewController:UIViewController,UIWebViewDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var loadingView:UIImageView!
    
    var animator: ZFModalTransitionAnimator!

    var jsContext: JSContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("AboutusViewController")
        
        
        loadingView.sd_setImageWithURL(NSURL(string: "http://www.iflabs.cn/app/hellojames/asset/loading.gif"))
        
        if (!appCloud().checkNetwork()){
            
            return
        }
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string:"http://www.iflabs.cn/app/hellojames/html/aboutus.html")!))
        webView.delegate = self
        webView.hidden = true
        loadingView.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.hidden = false
        loadingView.hidden = true
        
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = JSObjCModel()
        model.controller2 = self
        model.jsContext = context
        self.jsContext = context
        
        // 这一步是将OCModel这个模型注入到JS中，在JS就可以通过OCModel调用我们公暴露的方法了。
        self.jsContext?.setObject(model, forKeyedSubscript: "OCModel")
        //let url = NSBundle.mainBundle().URLForResource("test", withExtension: "html")
        
        //self.jsContext?.evaluateScript(try? String(contentsOfURL: NSURL(string: webViewUrl)!, encoding: NSUTF8StringEncoding));
        
        self.jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("AboutusViewController-viewWillAppear")
        super.viewWillAppear(animated)
        BaiduMobStat.defaultStat().pageviewStartWithName("关于我们")
        //rightBarButtonItem和下一界面的backBarButtonItem要在第一个viewController设置
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "closeView")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("关于我们")
    }
    
    func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            
            },completion:nil)
    }
    
    func openBusiness(){
        BaiduMobStat.defaultStat().pageviewStartWithName("我要和课间洽谈商务合作")
        openMail("我要和课间洽谈商务合作")
    }
    
    func openJoinus(){
        BaiduMobStat.defaultStat().pageviewStartWithName("我要加入到课间")
        openMail("我要加入到课间")
    }
    
    func gotoLegal(){
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.newsId = "-1"
        webViewController.webViewUrl = "http://www.iflabs.cn/app/hellojames/html/legal.html"
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem
        
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        self.navigationController?.pushViewController(webViewController,animated: true)
    }
    
    func openMail(title:String){
        let mail = MFMailComposeViewController()
        
        mail.mailComposeDelegate = self
        
        mail.setSubject(title)
        
        mail.setToRecipients(["january.zhang@iflabs.cn"])
        mail.setCcRecipients(["angell.luo@iflabs.cn","terry.luo@iflabs.cn"])
        
        self.presentViewController(mail, animated: true, completion: nil)
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        for i in 0 ..< 5 {
            NSTimer.scheduledTimerWithTimeInterval(0.6+Double(i)*0.1, target: self, selector: "openMailFinish", userInfo: nil, repeats:false)
        }
        
    }
    
    func openMailFinish(){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    //发送邮件代理方法
    func mailComposeController(controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult, error: NSError!) {
            controller.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
            
            switch result.rawValue{
            case MFMailComposeResultSent.rawValue:
                NSLog("邮件已发送")
            case MFMailComposeResultCancelled.rawValue:
                NSLog("邮件已取消")
            case MFMailComposeResultSaved.rawValue:
                NSLog("邮件已保存")
            case MFMailComposeResultFailed.rawValue:
                NSLog("邮件发送失败")
            default:
                NSLog("邮件没有发送")
                break
            }
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
}


