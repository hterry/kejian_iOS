//
//  SearchCellView.swift
//  HelloJames
//
//  Created by Terry on 15/12/25.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

class SearchCellView: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var desLabel:UILabel!
    @IBOutlet weak var infoLabel:UILabel!
    
    
    func setDesAlign(){
        desLabel.numberOfLines = 0
        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Justified
        
        let attr = [NSFontAttributeName:UIFont.systemFontOfSize(12),NSBaselineOffsetAttributeName:0,NSParagraphStyleAttributeName:paraStyle]
        
        let at = NSAttributedString(string: desLabel.text!, attributes: attr)
        desLabel.attributedText = at
    }
}
