//
//  IndexTableMutiCellView.swift
//  HelloJames
//
//  Created by Terry on 15/11/17.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

class IndexTableSmallCellView: UITableViewCell {
    
    @IBOutlet weak var cellView1: IndexTableMutiCellSingleView!
    @IBOutlet weak var cellView2: IndexTableMutiCellSingleView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cell初始化时设置高度
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.width, CGFloat(142)*CGFloat(CGFloat(UIScreen.mainScreen().bounds.width)/CGFloat(375)))
        
        //添加分割线
        //NSLog("%f", UIScreen.mainScreen().bounds.width)
        //cellView1.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2,cellView1.frame.height)
        //cellView2.frame=CGRectMake(UIScreen.mainScreen().bounds.width/2+2-100, 0, UIScreen.mainScreen().bounds.width/2-1,cellView2.frame.height)
        
        //cellView2.frame.origin=CGPointMake(100,0)
        //cellView1.label.text="title1"
        //cellView2.label.text="title2"
        /*let btmLine = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2-1, 0, 2, UIScreen.mainScreen().bounds.height))
        btmLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.contentView.addSubview(btmLine)*/
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        // Configure the view for the selected state
}
   