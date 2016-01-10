//
//  IndexTableBigCellView.swift
//  HelloJames
//
//  Created by Terry on 15/11/17.
//  Copyright © 2015年 IFLABS. All rights reserved.
//
import SDWebImage

class IndexTableBigCellView: UITableViewCell{
    @IBOutlet weak var cellHeight:NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var tf4TopSpace:NSLayoutConstraint!
    @IBOutlet weak var imagesView: UIImageView!
    
    var titleBg1:UIView!
    var titleBg2:UIView!
    var titleBg3:UIView!
    var titleBg4:UIView!
    var bgcolor: Int!=1
    
    var tfoy1:CGFloat=0
    var tfoy2:CGFloat=0
    var tfoy3:CGFloat=0
    var tfoy4:CGFloat=0
    
    var firstLoad = true
    
    let tf4Offset = 16
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //图片等比例布满view
        imagesView.contentMode = UIViewContentMode.ScaleAspectFill
        //imagesView.contentScaleFactor = 3
        //imagesView.contentMode = UIViewContentMode.Top
        
        titleBg1 = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2+20, 0))
        self.contentView.insertSubview(titleBg1, atIndex: 1)
        
        titleBg2 = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2+20, 0))
        self.contentView.insertSubview(titleBg2, atIndex: 1)
        
        titleBg3 = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2+20, 0))
        self.contentView.insertSubview(titleBg3, atIndex: 1)
        
        titleBg4 = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2+20, 0))
        self.contentView.insertSubview(titleBg4, atIndex: 1)
        
        titleLabel1.text = ""
        titleLabel2.text = ""
        titleLabel3.text = ""
        
        //cell初始化时设置高度
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.width, CGFloat(233)*CGFloat(CGFloat(UIScreen.mainScreen().bounds.width)/CGFloat(375)))
        
        //titleLabel4.text = ""
        
        
        /*NSLog("tfoy1:%f", tfoy1)
        NSLog("tfoy2:%f", tfoy2)
        NSLog("tfoy3:%f", tfoy3)*/
        
        //titleBg1.frame=CGRectMake(0, tfoy1, 0, 0)
        //titleBg2.frame=CGRectMake(0, tfoy2, 0, 0)
        //titleBg3.frame=CGRectMake(0, tfoy3, 0, 0)
        //titleBg4.frame=CGRectMake(0, tfoy4, 0, 0)
        
        //updateLabel()
                
        /*let paraStyle=NSMutableParagraphStyle()
        paraStyle.headIndent = 30
        paraStyle.lineSpacing = 50
        
        let para = NSMutableAttributedString()
        
        para.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange(location: 0,length: para.length))
        titleLabel.enabled=true
        titleLabel.attributedText = para*/
        
        //添加分割线
        //let btmLine = UIView(frame: CGRectMake(15, 91, UIScreen.mainScreen().bounds.width - 30, 1))
        //btmLine.backgroundColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
        //self.contentView.addSubview(btmLine)
        
        // Initialization code
    }
    
    
    func changeBgcolor(){
        var color = UIColor.blackColor()
        if (bgcolor == -1){
            color = UIColor.blackColor()
            
            
        }
        if (bgcolor == 0){
            color = appCloud().redColor
            
        }
        
        if (bgcolor == 1) {
            color = appCloud().greenColor
            
        }
        
        if (bgcolor == 2) {
            color = appCloud().blueColor
            
        }
        
        titleBg1.backgroundColor=color
        titleBg2.backgroundColor=color
        titleBg3.backgroundColor=color
        titleBg4.backgroundColor=color

        //titleLabel4.text = "时尚"
    }
    
    func updateLabel(){
        //更新storyboard约束后的frame
        titleLabel1.updateConstraintsIfNeeded()
        titleLabel1.needsUpdateConstraints()
        titleLabel2.updateConstraintsIfNeeded()
        titleLabel2.needsUpdateConstraints()
        titleLabel3.updateConstraintsIfNeeded()
        titleLabel3.needsUpdateConstraints()
        titleLabel4.updateConstraintsIfNeeded()
        titleLabel4.needsUpdateConstraints()
        
        titleLabel1.setNeedsLayout()
        titleLabel1.layoutIfNeeded()
        titleLabel2.setNeedsLayout()
        titleLabel2.layoutIfNeeded()
        titleLabel3.setNeedsLayout()
        titleLabel3.layoutIfNeeded()
        titleLabel4.setNeedsLayout()
        titleLabel4.layoutIfNeeded()
        
        tfoy1 = titleLabel1.frame.origin.y-1
        tfoy2 = titleLabel2.frame.origin.y-1
        tfoy3 = titleLabel3.frame.origin.y-1
    }
    
    func setTitle(title1 : String,title2 : String,title3 : String , titleAll:String = ""){
        //updateLabel()
        
        var strAll:String!=titleAll
        var str1:String!=title1
        var str2:String!=title2
        var str3:String!=title3
        var lines:Int! = 1

        //title为一段文字时的处理
        if (title1==""){
            let strLength = strAll.characters.count
            
            if (strLength>27){
                strAll = strAll.substringWithRange(Range<String.Index>(start: strAll.startIndex.advancedBy(0), end: strAll.startIndex.advancedBy(28)))
            }
            
            str1 = strAll.substringWithRange(Range<String.Index>(start: strAll.startIndex.advancedBy(0), end: strAll.startIndex.advancedBy(9)))
            NSLog("str:%@", strAll)
            if (strLength>9 ){
                if (strLength<=18){
                    str2 = strAll.substringWithRange(Range<String.Index>(start: strAll.startIndex.advancedBy(9), end: strAll.endIndex.advancedBy( 0)))
                }
                else {
                    str2 = strAll.substringWithRange(Range<String.Index>(start: strAll.startIndex.advancedBy(9), end: strAll.startIndex.advancedBy( 18)))
                }
                
                lines = 2
                
            }
            
            if (strLength>18){
                str3 = strAll.substringWithRange(Range<String.Index>(start: strAll.startIndex.advancedBy(18), end: strAll.endIndex.advancedBy( 0)))
                
                lines = 3
                
            }
        }
        
        //NSLog("str1:%@", str1)
        //NSLog("str2:%@", str2)
        //NSLog("str3:%@", str3)
        
        if(str1 != ""&&str2 != ""&&str3 != ""){
            lines=3
        }
        
        if(str1 != ""&&str2 != ""&&str3 == ""){
            lines=2
        }
        
        if(str1 != ""&&str2 == ""&&str3 == ""){
            lines=1
        }
        
        var bgWidth1:CGFloat!
        var bgWidth2:CGFloat!
        var bgWidth3:CGFloat!
        var bgWidth4:CGFloat!
        
        titleBg1.hidden=false
        titleBg2.hidden=false
        titleBg3.hidden=false
        
        titleLabel1.hidden=false
        titleLabel2.hidden=false
        titleLabel3.hidden=false
        
        titleLabel1.text = " "
        titleLabel2.text = " "
        titleLabel3.text = " "
        
        
        
        
        
        if (lines==1){
            
            
            titleLabel3.text = str1
            
            //titleLabel1.hidden=true
            //titleLabel3.hidden=true
            titleBg1.hidden=true
            titleBg2.hidden=true
            
            titleLabel1.sizeToFit()
            titleLabel2.sizeToFit()
            titleLabel3.sizeToFit()
            
            bgWidth1 = titleLabel3.frame.width
            bgWidth2 = titleLabel3.frame.width
            bgWidth3 = titleLabel3.frame.width
            
            updateLabel()
            tf4TopSpace.constant = tfoy3 - CGFloat(tf4Offset)
        }
        if (lines==2){
            
            titleLabel2.text = str1
            titleLabel3.text = str2
            
            titleBg1.hidden=true
            
            titleLabel1.sizeToFit()
            titleLabel2.sizeToFit()
            titleLabel3.sizeToFit()
            
            bgWidth1 = 0
            bgWidth2 = titleLabel2.frame.width
            bgWidth3 = titleLabel3.frame.width
            
            updateLabel()
            tf4TopSpace.constant = tfoy2 - CGFloat(tf4Offset)
            
        }
        if (lines==3){
            
            titleLabel1.text = str1
            titleLabel2.text = str2
            titleLabel3.text = str3
            
            titleLabel1.sizeToFit()
            titleLabel2.sizeToFit()
            titleLabel3.sizeToFit()
            
            bgWidth1 = titleLabel1.frame.width
            bgWidth2 = titleLabel2.frame.width
            bgWidth3 = titleLabel3.frame.width
            
            updateLabel()
            tf4TopSpace.constant = tfoy1 - CGFloat(tf4Offset)
        }
        
        updateLabel()
        
        bgWidth4 = titleLabel4.frame.width
        
        titleBg1.frame=CGRectMake(3, tfoy1, bgWidth1+8, titleLabel1.frame.height+3)
        titleBg2.frame=CGRectMake(3, tfoy2, bgWidth2+8, titleLabel2.frame.height+3)
        titleBg3.frame=CGRectMake(3, tfoy3, bgWidth3+8, titleLabel3.frame.height+3)
        titleBg4.frame=CGRectMake(3, titleLabel4.frame.origin.y-1, bgWidth4 + 8, 14)
        
        
        //NSLog("%f", titleLabel1.frame.width)
        //NSLog("%f", titleLabel2.frame.width)
        //NSLog("%f", titleLabel3.frame.width)
        
    }
    
    func loadImage(url:String){
        
        self.imagesView.alpha = 0
        
        SDImageCache.sharedImageCache().queryDiskCacheForKey(url, done: { (image:UIImage!, cacheType:SDImageCacheType) -> Void in
            if (cacheType.rawValue == 2){
                self.imagesView.alpha = 1
            }
            
        })
        
        imagesView!.sd_setImageWithURL(NSURL(string: url)){
            (image, error, cacheType, url)-> Void in
            UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
                ()-> Void in
                self.imagesView.alpha = 1
                
            },completion:nil)
        }
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
