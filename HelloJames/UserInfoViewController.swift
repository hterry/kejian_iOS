//
//  UserInfoViewController.swift
//  HelloJames
//
//  Created by Terry on 16/1/5.
//  Copyright © 2016年 IFLABS. All rights reserved.
//

import UIKit
class UserInfoViewController:UIViewController{
    @IBOutlet weak var avatarView:UIImageView!
    @IBOutlet weak var userNameLabel:UILabel!
    @IBOutlet weak var desLabel:UILabel!
    @IBOutlet weak var levelLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //userNameLabel
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserInfo", name: "updateUserInfo", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUserInfo()
    }
    
    func updateUserInfo(){
        if (appCloud().userInfo.avatar != ""){
            avatarView.sd_setImageWithURL(NSURL(string: appCloud().userInfo.avatar))
            avatarView.layer.cornerRadius = avatarView.frame.width/2
            avatarView.clipsToBounds = true
        }
        else {
            avatarView.image = UIImage(named: "defaultHeadPic")
        }
        
        userNameLabel.text = appCloud().userInfo.username
        desLabel.text = appCloud().userInfo.des
    }
    
    @IBAction func logoutSelect(){
        NSNotificationCenter.defaultCenter().postNotificationName("changeToLogin", object:nil)
        closeView()
    }
    
    @IBAction func gotoUserInfoEditView(){
        let userInfoEditViewController = self.storyboard?.instantiateViewControllerWithIdentifier("userInfoEditViewController") as! UserInfoEditViewController!
        userInfoEditViewController.isFirstShow = true
        self.navigationController?.pushViewController(userInfoEditViewController, animated: true)

        
    }
    
    @IBAction func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}