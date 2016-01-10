//
//  SuggestViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/4.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit



class SuggestViewController:UIViewController,UITextViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var tipsLabel:UILabel!
    
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        textView.returnKeyType = UIReturnKeyType.Done
        textView.delegate = self
        
        self.navigationItem.title = "给建议"//设置标题
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: "sendSuggest")
        self.navigationItem.rightBarButtonItem?.enabled=false
        tipsLabel.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
        
        BaiduMobStat.defaultStat().pageviewStartWithName("提交建议")
        
        textView.text=""
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("提交建议")
    }
    func textViewDidChange(textView: UITextView) {
        if (textView.text != ""){
            self.navigationItem.rightBarButtonItem?.enabled=true
            tipsLabel.hidden = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.enabled=false
            tipsLabel.hidden = false
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        if (text == "\n"){
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func sendSuggest(){
        if (textView.text != ""){
            NSLog("suggest:%@", textView.text)
            appCloud().sendSuggest(textView.text)
        }
        else {
            return
        }
        
        
        
        self.alert = UIAlertController(title: "", message: "谢谢你宝贵的建议!", preferredStyle: .Alert)
        //alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        self.presentViewController(self.alert, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "closeAlert", userInfo: nil, repeats: false)
    }
    
    func closeAlert(){
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.alert.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    
}