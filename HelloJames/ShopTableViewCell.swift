//
//  ShopTableViewCell.swift
//  HelloJames
//
//  Created by Terry on 15/12/9.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import SDWebImage


class ShopTableViewCell: UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var id:String!
    var firstLoad = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func loadImage(url:String){
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

}
