//
//  CatTableCellView.swift
//  HelloJames
//
//  Created by Terry on 15/11/30.
//  Copyright © 2015年 IFLABS. All rights reserved.
//,
class CatTableCellView: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var color:UIColor!
    
    override func awakeFromNib() {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
     
        super.setSelected(selected, animated: animated)
        
        changeSelect()
        
    }
    
    func changeSelect(){
        let bg:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        bg.backgroundColor = color
        if (selected){
            //self.label.textColor = UIColor.whiteColor()
            self.label.textColor = appCloud().redColor
        }
        else {
            self.label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            
        }
        
        //self.selectedBackgroundView = bg
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
}