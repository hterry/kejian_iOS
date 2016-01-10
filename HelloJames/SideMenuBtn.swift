//
//  SideMenuBtn.swift
//  HelloJames
//
//  Created by Terry on 15/12/30.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

class SideMenuBtn: UIButton{
    @IBOutlet weak var leftSpace:NSLayoutConstraint!
    @IBOutlet weak var bottomSpace:NSLayoutConstraint!
    
    var redLine:UIView!
    var blueLine:UIView!
    var greenLine:UIView!
    
    override func awakeFromNib() {
        
        redLine = UIView(frame: CGRectMake(0, 0, 14, 2))
        redLine.backgroundColor = appCloud().redColor
        redLine.center=CGPoint(x: self.frame.width/2,y: 11)
        
        //redLine.frame.origin = CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        
        blueLine = UIView(frame: CGRectMake(0, 0, 14, 2))
        blueLine.backgroundColor = appCloud().blueColor
        blueLine.center=CGPoint(x: self.frame.width/2,y: 16)
        
        greenLine = UIView(frame: CGRectMake(0, 0, 14, 2))
        greenLine.backgroundColor = appCloud().greenColor
        greenLine.center=CGPoint(x: self.frame.width/2,y: 21)
        
        self.addSubview(blueLine)
        self.addSubview(greenLine)
        self.addSubview(redLine)
        
        leftSpace.constant = 10-self.frame.width/2
        bottomSpace.constant = 10-self.frame.height/2
        
        let scale:CGFloat=UIScreen.mainScreen().bounds.width/320
        self.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.transform = CGAffineTransformMakeScale(scale, scale)
        
        
    }
    
    func closeState(){
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
                self.redLine.transform = CGAffineTransformMakeRotation(0)
                self.greenLine.transform = CGAffineTransformMakeRotation(0)
                self.blueLine.alpha=1
            
            },completion:nil)
        
    }
    
    func openState(){
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
                self.redLine.transform = CGAffineTransformMakeRotation(40)
                self.greenLine.transform = CGAffineTransformMakeRotation(-40)
                self.blueLine.alpha=0
            
            },completion:nil)
        
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}