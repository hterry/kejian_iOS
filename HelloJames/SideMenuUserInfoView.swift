//
//  SideMenuUserInfoView.swift
//  HelloJames
//
//  Created by Terry on 16/1/6.
//  Copyright © 2016年 IFLABS. All rights reserved.
//

import UIKit

class SideMenuUserInfoView:UIControl{
    @IBOutlet weak var avatarView:UIImageView!
    @IBOutlet weak var userNameLabel:UILabel!
    @IBOutlet weak var levelLabel:UILabel!
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserInfo", name: "updateUserInfo", object: nil)
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
        //userNameLabel.text = appCloud().userInfo.username
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
}
