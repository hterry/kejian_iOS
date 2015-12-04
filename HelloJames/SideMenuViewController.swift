//
//  SideMenuViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/12/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var catTableView: UITableView!//catTableView分类列表
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("SideMenuViewController")
        
        self.catTableView.delegate=self
        self.catTableView.dataSource=self
        self.catTableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.catTableView.showsVerticalScrollIndicator = false
        self.catTableView.rowHeight = UITableViewAutomaticDimension
        self.catTableView.estimatedRowHeight = 40
        self.catTableView.rowHeight = 40
        //self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCatListData:", name: "catListDataGet", object: nil)
        
    }
    
    func reloadCatListData(){
        NSLog("reloadCatListData")
        self.catTableView.reloadData()
       
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
extension SideMenuViewController: UITableViewDataSource,
    UITableViewDelegate {
    //tableView数据源
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("total:%d",Int(appCloud().contentStory.count))
        return appCloud().cats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //取得已读新闻数组以供配置
        //NSLog("catCell:%d", indexPath.row)
        let catIndex = indexPath.row
        //let data = appCloud().contentStory[newIndex] as! ContentStoryModel
        let cell = tableView.dequeueReusableCellWithIdentifier("catTableCellView") as! CatTableCellView
        
        NSLog("color:%@", appCloud().cats[catIndex].color)
        if (appCloud().cats[catIndex].color=="red"){
            cell.label.textColor = appCloud().redColor
            cell.color = appCloud().redColor
        }
        if (appCloud().cats[catIndex].color=="blue"){
            cell.label.textColor = appCloud().blueColor
            cell.color = appCloud().blueColor
        }
        if (appCloud().cats[catIndex].color=="green"){
            cell.label.textColor = appCloud().greenColor
            cell.color = appCloud().greenColor
        }
        
        cell.label.text=appCloud().cats[catIndex].name
        cell.icon.sd_setImageWithURL(NSURL(string:appCloud().cats[catIndex].image))
        //NSLog("@%f", cell.frame.height)
        //cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        //cell.titleLabel.text = data.title
        
        return cell
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemData = appCloud().cats[indexPath.row]
        var sendObj:NSDictionary!
        if (indexPath.row != 0){
        
            sendObj = ["index":indexPath.row,"id":itemData.id,"name":itemData.name]
            
        }
        else {
            sendObj = ["index":indexPath.row,"id":"-1","name":itemData.name]
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("catListSelect", object:sendObj)
    }
    
    
    
}