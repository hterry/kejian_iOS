//
//  RegisterViewController.swift
//  HelloJames
//
//  Created by Terry on 16/1/5.
//  Copyright © 2016年 IFLABS. All rights reserved.
//

import UIKit
class RegisterViewController:UIViewController,UITextFieldDelegate{
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var scrollViewTopSpace:NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextView:UIView!
    @IBOutlet weak var passwordTextView:UIView!
    @IBOutlet weak var codeTextView:UIView!
    @IBOutlet weak var phoneTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var codeTextField:UITextField!
    
    @IBOutlet weak var sendCodeBtn:UIButton!
    @IBOutlet weak var termSelectBtn:UIButton!
    
    
    var isTermSelect:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        //self.modalPresentationStyle = UIModalPresentationStyle.
        
        phoneTextView.layer.borderWidth = 1;
        phoneTextView.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        
        passwordTextView.layer.borderWidth = 1;
        passwordTextView.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        
        codeTextView.layer.borderWidth = 1;
        codeTextView.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        codeTextField.delegate = self
        
        passwordTextField.secureTextEntry = true
        
        scrollViewTopSpace.constant = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            //self.scrollView.frame = CGRectMake(0, -(860-UIScreen.mainScreen().bounds.height), self.scrollView.frame.width, self.scrollView.frame.height)
            self.scrollViewTopSpace.constant = -(860-UIScreen.mainScreen().bounds.height)
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
    
    @IBAction func termBtnSelect(){
        NSLog("termBtnSelect")
        if (isTermSelect){
            termSelectBtn.setImage(UIImage(named: "term_unselect"), forState: UIControlState.Normal)
            isTermSelect=false
        }
        else {
            termSelectBtn.setImage(UIImage(named: "term_select"), forState: UIControlState.Normal)
            isTermSelect=true
        }
    }
    
    @IBAction func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }

}
