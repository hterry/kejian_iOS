//
//  IndexTableMutiCellSingleView.swift
//  HelloJames
//
//  Created by Terry on 15/11/17.
//  Copyright © 2015年 IFLABS. All rights reserved.
//
import SDWebImage

class IndexTableMutiCellSingleView: UIView {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var labelBg: UIView!
    @IBOutlet weak var viewWidth:NSLayoutConstraint!
    @IBOutlet weak var labelTopSpace:NSLayoutConstraint!
    
    var newsId: String! = "-1"
    var firstLoad = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewWidth.constant = UIScreen.mainScreen().bounds.width/2
        labelTopSpace.constant = CGFloat(85)-(CGFloat(142)-self.frame.height)
        
        let gl:CAGradientLayer = CAGradientLayer()
        gl.frame = labelBg.bounds
        gl.colors = [UIColor.clearColor().CGColor,UIColor.blackColor().CGColor]
        gl.locations = [0,1]
        
        labelBg.layer.addSublayer(gl)
        self.bringSubviewToFront(label)
        self.bringSubviewToFront(catLabel)
        
        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Justified
        
        let para = NSMutableAttributedString()
        
        para.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange(location: 0,length: para.length))
        label.attributedText = para
        label.sizeToFit()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("%@", newsId)
        if (newsId == "-1"){
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("mutiCellSelect", object: [newsId,label.text])

    }
    
    func loadImage(url:String){
        
        //label设置Justify对齐
        label.numberOfLines = 0
        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Justified
        
        let attr = [NSFontAttributeName:UIFont.systemFontOfSize(12),NSBaselineOffsetAttributeName:0,NSParagraphStyleAttributeName:paraStyle]
        
        let at = NSAttributedString(string: label.text!, attributes: attr)
        label.attributedText = at
        //label.sizeToFit()
        
        self.img.alpha = 0
        
        SDImageCache.sharedImageCache().queryDiskCacheForKey(url, done: { (image:UIImage!, cacheType:SDImageCacheType) -> Void in
            
            if (cacheType.rawValue == 2){
                self.img.alpha = 1
            }
            
        })
        
        img!.sd_setImageWithURL(NSURL(string: url)){
            (image, error, cacheType, url)-> Void in
            UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
                ()-> Void in
                self.img.alpha = 1
                
                },completion:nil)
        }
    }
    
        // Configure the view for the selected state
}