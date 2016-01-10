//
//  MainTabBarItem.swift
//  HelloJames
//
//  Created by Terry on 15/11/23.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit

class MainTabBarItem: UIView{
    
    let space = 2
    let lineHeight:CGFloat = 2
    
    var color:UIColor!
    var num:Int! = 1
    var title:String! = ""
    var itemHeight:CGFloat!=50
    var line:UIView!
    var label1:UILabel!
    var label2:UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRectMake(0, 0, 0, 0))
        
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeItem(){
        self.backgroundColor = UIColor(white: 0, alpha: 1)
        
        //let itemWidth = CGFloat((UIScreen.mainScreen().bounds.width - CGFloat(4*space))/3)
        let itemWidth = CGFloat((UIScreen.mainScreen().bounds.width - CGFloat(3*space))/2)
        
        NSLog("screenWidth:%f", UIScreen.mainScreen().bounds.width)
        NSLog("itemWidth:%f", itemWidth)
        
        let posX = CGFloat(space) + (CGFloat(itemWidth) + CGFloat(space))*CGFloat(num-1)
        
        NSLog("posX:%f", posX)
        
        self.frame = CGRectMake(posX, 20, itemWidth, itemHeight)
        
        line = UIView(frame: CGRectMake(0, self.frame.height - lineHeight, itemWidth, lineHeight))
        line.backgroundColor = color
        self.addSubview(line)
        
        label1 = UILabel(frame: CGRectMake(0,0, itemWidth, 20))
        label1.center.x=itemWidth/2
        label1.center.y=itemHeight/2
        label1.textAlignment = NSTextAlignment.Center
        label1.textColor = color
        label1.font = UIFont(name:label1.font.fontName , size: 15)
        label1.adjustsFontSizeToFitWidth = true
        label1.text = title
        
        self.addSubview(label1)
        
        label2 = UILabel(frame: CGRectMake(0,0, itemWidth, 20))
        label2.center.x=itemWidth/2
        label2.center.y=itemHeight/2 + itemHeight
        label2.textAlignment = NSTextAlignment.Center
        label2.textColor = color
        label2.font = UIFont(name:label1.font.fontName , size: 15)
        label2.adjustsFontSizeToFitWidth = true
        label2.text = title
        
        self.addSubview(label2)
        
        let tap = UITapGestureRecognizer(target: self, action: "viewTap:")
        self.addGestureRecognizer(tap)
    }
    
    func viewTap(sender:AnyObject){
        NSNotificationCenter.defaultCenter().postNotificationName("mainTabBarItemTap", object: self.num)
    }
    
    func changeToSelected(){
        UIView.animateWithDuration(0.2, animations: {
            ()-> Void in
            
            self.label1.center.y = self.itemHeight/2 - self.itemHeight
            self.label2.center.y = self.itemHeight/2
            
            self.line.frame.origin = CGPointMake(0, 0)
        })
    }
    
    func changeToUnselected(){
        UIView.animateWithDuration(0.2, animations: {
            ()-> Void in
            
            self.label1.center.y = self.itemHeight/2
            self.label2.center.y = self.itemHeight/2 + self.itemHeight
            
            self.line.frame.origin = CGPointMake(0, self.frame.height - self.lineHeight)
        })

    }
    
    
}