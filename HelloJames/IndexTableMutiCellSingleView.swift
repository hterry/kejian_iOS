//
//  IndexTableMutiCellSingleView.swift
//  HelloJames
//
//  Created by Terry on 15/11/17.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

class IndexTableMutiCellSingleView: UIView {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var newsId: String! = "-1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //添加分割线
        //let btmLine = UIView(frame: CGRectMake(15, 91, UIScreen.mainScreen().bounds.width - 30, 1))
        //btmLine.backgroundColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
        
        
        // Initialization code
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("%@", newsId)
        if (newsId == "-1"){
            return
        }
        NSNotificationCenter.defaultCenter().postNotificationName("mutiCellSelect", object: newsId)

    }
    
        // Configure the view for the selected state
}