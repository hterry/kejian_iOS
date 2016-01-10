//
//  UserInfoEditViewController.swift
//  HelloJames
//
//  Created by Terry on 16/1/6.
//  Copyright © 2016年 IFLABS. All rights reserved.
//

import UIKit
class UserInfoEditViewController:UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var editHeadpicBtn:UIButton!
    @IBOutlet weak var userNameLabel:UITextField!
    @IBOutlet weak var desLabel:UITextField!
    
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    var imgData:NSData!
    var changeHeadpic:Bool=false
    
    var isFirstShow=true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.delegate = self
        desLabel.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (isFirstShow){
            updateUserInfo()
            isFirstShow=false;
        }
    }
    
    func updateUserInfo(){
        userNameLabel.text = appCloud().userInfo.username
        desLabel.text = appCloud().userInfo.des
        
        if (appCloud().userInfo.avatar != ""){
            
            UIImageView().sd_setImageWithURL(NSURL(string: appCloud().userInfo.avatar)){
                (image, error, cacheType, url)-> Void in
                self.editHeadpicBtn.setImage(image, forState: UIControlState.Normal)
            }
            
            editHeadpicBtn.layer.cornerRadius = 125/2
            editHeadpicBtn.clipsToBounds = true
        }
        else {
            self.editHeadpicBtn.setImage(UIImage(named: "edit_headpic"), forState: UIControlState.Normal)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userNameLabel.resignFirstResponder()
        desLabel.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField != desLabel){
            //return
        }
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            self.view.frame = CGRectMake(0, -(700-UIScreen.mainScreen().bounds.height), self.view.frame.width, self.view.frame.height)
            },completion:nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField != desLabel){
            //return
        }
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            },completion:nil)
    }
    
    @IBAction func editHeadPicSelect(){
        //NSNotificationCenter.defaultCenter().postNotificationName("changeToLogin", object:nil)
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        
        let actionSheet:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel){
            (action: UIAlertAction!) -> Void in
        }

        let cameraAction:UIAlertAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default){
            (action: UIAlertAction!) -> Void in
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePickerController, animated: true, completion: nil)
        }
        let photoAction:UIAlertAction = UIAlertAction(title: "打开相册", style: UIAlertActionStyle.Default){
            (action: UIAlertAction!) -> Void in
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePickerController, animated: true, completion: nil)
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            //self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        
        //self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        
        let newSize:CGSize = CGSizeMake(250, 250)
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imgData = UIImageJPEGRepresentation(newImage,0.8)
        
        //let decodeData = NSData(base64EncodedData: base64String, options: NSUTF8StringEncoding)
        //NSLog("base64String:%@","data:image/jpg;base64,"+String(base64String))
        
        editHeadpicBtn.setImage(UIImage(data: imgData), forState: UIControlState.Normal)
        editHeadpicBtn.layer.cornerRadius = editHeadpicBtn.frame.width/2
        editHeadpicBtn.clipsToBounds = true
        
        changeHeadpic=true
        
    }
    
    @IBAction func saveInfo(){
        var base64String:String = ""
        if (changeHeadpic){
            //base64String = "data:image/jpg;base64,"+String(imgData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
            base64String = String(imgData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
            
        }
        
        appCloud().saveUserInfo(base64String)
        
        appCloud().userInfo.username = userNameLabel.text!
        
        appCloud().userInfo.des = desLabel.text!
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateUserInfo", object:nil)
        
        closeView()
    }
    
    @IBAction func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}