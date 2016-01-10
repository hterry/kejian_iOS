//
//  SettingMenuViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/7.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

class SettingMenuViewController:UIViewController{
    @IBOutlet weak var pushBtn:UIView!
    @IBOutlet weak var pushBtnLabel:UILabel!
    @IBOutlet weak var pushTipsLabel:UILabel!
    @IBOutlet weak var versionLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "当前版本号：" + appCloud().version
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
