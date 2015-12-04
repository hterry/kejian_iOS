//
//  CustomWebView.swift
//  HelloJames
//
//  Created by Terry on 15/12/3.
//  Copyright © 2015年 IFLABS. All rights reserved.
//



class CustomWebView:UIWebView{
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //super.touchesBegan(Set, withEvent: <#T##UIEvent?#>)
        NSLog("CustomWebViewTouchBegan")
    }
    
}
