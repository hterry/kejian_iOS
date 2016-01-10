//
//  LoginViewController.swift
//  HelloJames
//
//  Created by Terry on 16/1/5.
//  Copyright © 2016年 IFLABS. All rights reserved.
//

import UIKit
class LoginViewController:UIViewController,UITextFieldDelegate{
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var scrollViewTopSpace:NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextView:UIView!
    @IBOutlet weak var passwordTextView:UIView!
    @IBOutlet weak var phoneTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    @IBOutlet weak var sinaBtn:UIButton!
    @IBOutlet weak var weixinBtn:UIButton!
    @IBOutlet weak var qqBtn:UIButton!
    
    @IBOutlet weak var cancelBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextView.layer.borderWidth = 1;
        phoneTextView.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        
        passwordTextView.layer.borderWidth = 1;
        passwordTextView.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        
        cancelBtn.layer.borderWidth = 1;
        cancelBtn.layer.borderColor = appCloud().redColor.CGColor
        
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.secureTextEntry = true
        
        //self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.width, self.scrollView.frame.height)
        
        self.scrollViewTopSpace.constant = 0
    }

    override func viewWillDisappear(animated: Bool) {
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            //self.scrollView.frame = CGRectMake(0, -(920-UIScreen.mainScreen().bounds.height), self.scrollView.frame.width, self.scrollView.frame.height)
            self.scrollViewTopSpace.constant = -(900-UIScreen.mainScreen().bounds.height)
            },completion:nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            //self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.width, self.scrollView.frame.height)
            self.scrollViewTopSpace.constant = 0
            },completion:nil)
    }
    
    @IBAction func changePasswordTextShowType(){
        passwordTextField.secureTextEntry = !passwordTextField.secureTextEntry
    }
    
    @IBAction func loginSelect(){
        NSNotificationCenter.defaultCenter().postNotificationName("changeToInfo", object:nil)
        closeView()
        
    }
    
    @IBAction func registerSelect(){
        let registerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("registerViewController") as! RegisterViewController!
        
        //self.navigationController?.presentViewController(registerViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(registerViewController, animated: true)
        
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
