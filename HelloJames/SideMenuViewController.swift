//
//  SideMenuViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/12/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import MessageUI

class SideMenuViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var catTableView: UITableView!//catTableView分类列表
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewWidth:NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight:NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var userViewHeight:NSLayoutConstraint!
    @IBOutlet weak var infoView:SideMenuUserInfoView!
    @IBOutlet weak var loginView:UIView!
    
    @IBOutlet weak var aboutusBtn:UIButton!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var settingBtn:UIButton!
    @IBOutlet weak var sendBtnWidth:NSLayoutConstraint!
    @IBOutlet weak var settingBtnWidth:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("SideMenuViewController")
        
        self.catTableView.delegate=self
        self.catTableView.dataSource=self
        self.catTableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.catTableView.showsVerticalScrollIndicator = false
        self.catTableView.rowHeight = UITableViewAutomaticDimension
        self.catTableView.estimatedRowHeight = 54
        self.catTableView.rowHeight = 54
        self.catTableView.scrollEnabled = false
        
        self.scrollView.showsVerticalScrollIndicator = false
        scrollViewWidth.constant = UIScreen.mainScreen().bounds.width*(2/3)
        //self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCatListData", name: "catListDataGet", object: nil)
        
        if (appCloud().cats.count>=1){
            reloadCatListData()
            
            catTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition:UITableViewScrollPosition.Top)
        }
        else {
            appCloud().getCatData()
        }
        
        aboutusBtn.setNeedsLayout()
        aboutusBtn.layoutIfNeeded()
        
        sendBtnWidth.constant = scrollViewWidth.constant/2-20-1
        settingBtnWidth.constant = scrollViewWidth.constant/2-20-1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeToLogin", name: "changeToLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeToInfo", name: "changeToInfo", object: nil)

        //aboutusBtn.titleLabel?.numberOfLines = 0
        //aboutusBtn.titleLabel?.textAlignment = NSTextAlignment.Justified
        //aboutusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        //aboutusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, aboutusBtn.frame.width*0.15, 0, aboutusBtn.frame.width*0.15)
        
        
        changeToInfo()
        //changeToLogin()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        //self.scrollViewHeight.constant = CGFloat(UIScreen.mainScreen().bounds.height*2)
    }
    
    func changeToInfo(){
        infoView.hidden = false
        loginView.hidden = true
        userViewHeight.constant = 253
        updateConstraints()
        
        infoView.updateUserInfo()
    }
    
    func changeToLogin(){
        infoView.hidden = true
        loginView.hidden = false
        userViewHeight.constant = 193
        updateConstraints()
    }
    
    func reloadCatListData(){
        NSLog("reloadCatListData")
        self.catTableView.reloadData()
        
        updateConstraints()
       
    }
    
    func updateConstraints(){
        updateViewConstraints()
        
        let tableHeight = appCloud().cats.count*54
        
        self.scrollView.scrollEnabled = true
        
        tableViewHeight.constant = CGFloat(tableHeight)
        
        self.scrollViewHeight.constant = CGFloat(CGFloat(tableHeight) + CGFloat(347) + CGFloat(userViewHeight.constant))
    }
    
    @IBAction func loginSelect(){
        NSLog("loginSelect")
        
        NSNotificationCenter.defaultCenter().postNotificationName("loginBtnSelect", object:nil)
    }
    
    @IBAction func userInfoSelect(){
        NSNotificationCenter.defaultCenter().postNotificationName("userInfoSelect", object:nil)
    }
    
    @IBAction func settingSelect(){
        NSLog("settingSelect")
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("settingBtnSelect", object:nil)
    }
    
    @IBAction func aboutusSelect(){
        NSLog("aboutusSelect")
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("aboutusBtnSelect", object:nil)
    }
    
    @IBAction func searchSelect(){
        NSLog("searchSelect")
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("searchBtnSelect", object:nil)
    }
    
    @IBAction func gotoSendArticle(){
        let mail = MFMailComposeViewController()
        
        mail.mailComposeDelegate = self
        
        mail.setSubject("我要投稿给课间")
        
        mail.setToRecipients(["january.zhang@iflabs.cn"])
       
        mail.setCcRecipients(["angell.wen@iflabs.cn"])
        
        self.presentViewController(mail, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "openMailFinish", userInfo: nil, repeats:false)
        
    }
    
    func openMailFinish(){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
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
extension SideMenuViewController: UITableViewDataSource,
    UITableViewDelegate {
    //tableView数据源
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("total:%d",Int(appCloud().contentStory.count))
        return appCloud().cats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //取得已读新闻数组以供配置
        //NSLog("catCell:%d", indexPath.row)
        let catIndex = indexPath.row
        //let data = appCloud().contentStory[newIndex] as! ContentStoryModel
        let cell = tableView.dequeueReusableCellWithIdentifier("catTableCellView") as! CatTableCellView
        
        if (appCloud().cats[catIndex].color=="red"){
            cell.label.textColor = appCloud().redColor
            cell.color = appCloud().redColor
        }
        if (appCloud().cats[catIndex].color=="blue"){
            cell.label.textColor = appCloud().blueColor
            cell.color = appCloud().blueColor
        }
        if (appCloud().cats[catIndex].color=="green"){
            cell.label.textColor = appCloud().greenColor
            cell.color = appCloud().greenColor
        }
        
        cell.label.text=appCloud().cats[catIndex].name
        cell.icon.sd_setImageWithURL(NSURL(string:appCloud().cats[catIndex].image))
        //NSLog("@%f", cell.frame.height)
        //cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        //cell.titleLabel.text = data.title
        
        return cell
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemData = appCloud().cats[indexPath.row]
        var sendObj:NSDictionary!
        if (indexPath.row != 0){
        
            sendObj = ["index":indexPath.row,"id":itemData.id,"name":itemData.name]
            appCloud().currentCatid = itemData.id
            appCloud().currentCatName = itemData.name
        }
        else {
            sendObj = ["index":indexPath.row,"id":"-1","name":itemData.name]
            
            appCloud().currentCatid = "-1"
            appCloud().currentCatName = itemData.name
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("catListSelect", object:sendObj)
    }
    
    
    
    
    
}