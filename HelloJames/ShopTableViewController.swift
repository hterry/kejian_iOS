//
//  ShopTableViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/9.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit

class ShopTableViewController: UIViewController{
    @IBOutlet weak var shopTableView: UITableView!//shopTableView分类列表
    
    var loadingImageView:UIImageView!
    
    var animator: ZFModalTransitionAnimator!
    
    var isBeginDrag = false
    var lastContentY:CGFloat!=0
    
    var isLoad=false

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("ShopTableViewController")
        
        self.view.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.shopTableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.shopTableView.dataSource = self
        self.shopTableView.delegate = self
        self.shopTableView.showsVerticalScrollIndicator = false
        self.shopTableView.rowHeight = UITableViewAutomaticDimension
        self.shopTableView.estimatedRowHeight = 50
        self.shopTableView.rowHeight = 322
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "productDataGet", object: nil)
        
        self.shopTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")
        appCloud().shopTabelViewHeader = self.shopTableView.mj_header
        
        self.shopTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:"loadMoreData" );
        appCloud().shopTabelViewFooter = self.shopTableView.mj_footer
        //下拉刷新组件
        loadingImageView = UIImageView(frame: CGRectMake(0, 0,400, 90))
        loadingImageView.sd_setImageWithURL(NSURL(string: "http://www.iflabs.cn/app/hellojames/asset/refresh.gif"))
        loadingImageView.center.x = UIScreen.mainScreen().bounds.width/2
        //loadingImageView.center.y = 0
        
        let header:MJRefreshNormalHeader! = self.shopTableView.mj_header as! MJRefreshNormalHeader
        header.addSubview(loadingImageView)
        loadingImageView.hidden = true
        
        header!.stateLabel?.textColor = UIColor.whiteColor()
        header!.setTitle("    下拉刷新传送门    ", forState:MJRefreshStateIdle)
        header!.setTitle("    松开刷新传送门    ", forState:MJRefreshStatePulling)
        header!.setTitle("                  ", forState:MJRefreshStateRefreshing)
        
        self.shopTableView.mj_footer!.tintColor = UIColor.whiteColor()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //appCloud().getProductData("refresh")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func appearLoad(){
        BaiduMobStat.defaultStat().pageviewStartWithName("传送门列表")
        
        if (isLoad){
            return
        }
        isLoad=true
        appCloud().getProductData("refresh")
        
    }
    
    func loadMoreData(){
        NSLog("refreshData")
        
        appCloud().getProductData("getMore")
        
        BaiduMobStat.defaultStat().logEvent("shopListGetMore", eventLabel: "")

    }
    
    func refreshData(){
        
        appCloud().getProductData("refresh")
        loadingImageView.hidden = false
        
        BaiduMobStat.defaultStat().logEvent("shopListRefresh", eventLabel: "")
    }
    
    
    func reloadData(){
        NSLog("shopReloadData")
        
        self.shopTableView.reloadData()
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"endRefreshing:", userInfo:nil, repeats:false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:"hideLoading", userInfo:nil, repeats:false)
        
        //timer.fire()
        
        //loadingImageView.hidden = true
    }
    
    func hideLoading(){
        loadingImageView.hidden = true
    }
    
    func endRefreshing(timer:NSTimer){
        self.shopTableView.mj_footer.endRefreshing()
        self.shopTableView.mj_header.endRefreshing()
        
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    
}

extension ShopTableViewController: UITableViewDataSource,
UITableViewDelegate {
    //tableView数据源
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("total:%d",Int(appCloud().contentStory.count))
        return appCloud().product.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        NSLog("ShopCellForRowAtIndexPath:%d",indexPath.row)
        let newIndex = indexPath.row
        let data = appCloud().product[newIndex] as! ProductModel
        NSLog("%@", String(data))
        let cell = tableView.dequeueReusableCellWithIdentifier("shopTableViewCell") as! ShopTableViewCell
        
        cell.label.text = data.title
        cell.locationLabel.text = data.location
        
        if (!checkProductLoaded(data.id)){
            cell.firstLoad = false
        }
        
        cell.loadImage(data.image)
        
        appCloud().loadedProductList.append(data.id)
        
        return cell
    }
    
    func checkProductLoaded(id:String)->Bool{
        var bn = false
        
        for i in 0 ..< appCloud().loadedProductList.count{
            if (appCloud().loadedProductList[i] == id){
                bn = true
                break
            }
        }
        
        return bn
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemData = appCloud().product[indexPath.row]
        var sendObj:NSDictionary!
        sendObj = ["title":itemData.title,"id":itemData.id,"url":itemData.url]
        
        BaiduMobStat.defaultStat().logEvent("shopListSelect", eventLabel: itemData.title)
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.newsTitle = itemData.title
        webViewController.webViewUrl = itemData.url
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        //webViewController.transitioningDelegate = self.animator
        
        
        self.parentViewController?.navigationController?.pushViewController(webViewController,animated: true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastContentY = scrollView.contentOffset.y
        isBeginDrag = true
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isBeginDrag){
            return
        }
        
        isBeginDrag=false
        
        if (scrollView.contentOffset.y<lastContentY){
            
            NSNotificationCenter.defaultCenter().postNotificationName("showTopBar", object: nil)
        }
        else {
            if (scrollView.contentOffset.y>0){
                NSLog("scorll1:%f",lastContentY)
                NSLog("scorll2:%f",scrollView.contentOffset.y)
                NSNotificationCenter.defaultCenter().postNotificationName("hideTopBar", object: nil)
            }
        }
        
        
    }
    
    
    
}