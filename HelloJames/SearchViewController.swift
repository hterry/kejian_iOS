//
//  SearchViewController.swift
//  HelloJames
//
//  Created by Terry on 15/12/25.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit
class SearchViewController:UIViewController,UISearchBarDelegate{
    @IBOutlet weak var tableView:UITableView!
    
    var loadingImageView:UIImageView!
    var animator: ZFModalTransitionAnimator!
    
    var searchBar:UISearchBar!
    
    var lastSearchText:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.separatorColor = UIColor.grayColor()
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.SingleLine
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 40
        //self.tableView.rowHeight = 40
        //self.tableView.scrollEnabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "searchDataGet", object: nil)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")
        appCloud().searchTableViewHeader = self.tableView.mj_header
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:"loadMoreData" );
        appCloud().searchTableViewFooter = self.tableView.mj_footer
        //下拉刷新组件
        loadingImageView = UIImageView(frame: CGRectMake(0, 0,400, 90))
        loadingImageView.sd_setImageWithURL(NSURL(string: "http://www.iflabs.cn/app/hellojames/asset/refresh.gif"))
        loadingImageView.center.x = UIScreen.mainScreen().bounds.width/2
        //loadingImageView.center.y = 0
        
        let header:MJRefreshNormalHeader! = self.tableView.mj_header as! MJRefreshNormalHeader
        //header.addSubview(loadingImageView)
        loadingImageView.hidden = true
        
        header!.stateLabel?.textColor = UIColor.whiteColor()
        header!.setTitle("    下拉刷新搜索内容    ", forState:MJRefreshStateIdle)
        header!.setTitle("    松开刷新搜索内容    ", forState:MJRefreshStatePulling)
        header!.setTitle("    正在刷新搜索内容    ", forState:MJRefreshStateRefreshing)
        
        self.tableView.mj_footer!.tintColor = UIColor.whiteColor()

        
        searchBar = UISearchBar(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width-80,20))
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("SearchViewController-viewWillAppear")
        super.viewWillAppear(animated)
        BaiduMobStat.defaultStat().pageviewStartWithName("搜索")
        //rightBarButtonItem和下一界面的backBarButtonItem要在第一个viewController设置
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "closeView")
        
        searchBar.tintColor=UIColor.blackColor()
        if (searchBar.text==""){
        
            tableView.hidden = true
        }
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (searchBar.text==""){
            searchBar.becomeFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
    
    func loadMoreData(){
        NSLog("refreshData")
        
        
        
        appCloud().getSearchData("getMore",keywords:lastSearchText)
        
        BaiduMobStat.defaultStat().logEvent("searchListGetMore", eventLabel: "")
        
    }
    
    func refreshData(){
        
        
        appCloud().getSearchData("refresh",keywords:lastSearchText)
        loadingImageView.hidden = false
        
        BaiduMobStat.defaultStat().logEvent("searchListRefresh", eventLabel: "")
    }
    
    
    func reloadData(){
        NSLog("searchReloadData")
        
        tableView.hidden = false
        
        self.tableView.reloadData()
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"endRefreshing:", userInfo:nil, repeats:false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:"hideLoading", userInfo:nil, repeats:false)
        
        //timer.fire()
        
        //loadingImageView.hidden = true
    }
    
    func hideLoading(){
        loadingImageView.hidden = true
    }
    
    func endRefreshing(timer:NSTimer){
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (searchBar.text != ""){
            searchBar.resignFirstResponder()
            appCloud().getSearchData("refresh",keywords: searchBar.text!)
            
            lastSearchText = searchBar.text
        }
    }
    
    func closeView(){
        //self.parentViewController!.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: false)
        
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            
            },completion:nil)
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

extension SearchViewController: UITableViewDataSource,
UITableViewDelegate {
    //tableView数据源
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 43
        }
        else {
            return 114
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("total:%d",Int(appCloud().contentStory.count))
        return appCloud().searchData.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //取得已读新闻数组以供配置
        //NSLog("catCell:%d", indexPath.row)
        let newsIndex = indexPath.row-1
        //let data = appCloud().contentStory[newIndex] as! ContentStoryModel
        
        if (newsIndex == -1){
            let cell = tableView.dequeueReusableCellWithIdentifier("searchTitleCellView") as! SearchTitleCellView
            cell.numLabel.text = "（"+String(appCloud().searchData.count)+"条搜索结果）"
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCellView") as! SearchCellView
        cell.titleLabel.text = appCloud().searchData[newsIndex].title
        cell.desLabel.text = appCloud().searchData[newsIndex].des+"..."
        cell.setDesAlign()
        if (appCloud().searchData[newsIndex].author != ""){
            cell.infoLabel.text = appCloud().searchData[newsIndex].author + " | " + appCloud().searchData[newsIndex].time
        }
        else {
            cell.infoLabel.text = appCloud().searchData[newsIndex].time
        }
        
        //cell.titleLabel.text=appCloud().cats[newsIndex].name
        //NSLog("@%f", cell.frame.height)
        //cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        //cell.titleLabel.text = data.title
        
        return cell
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        searchBar.resignFirstResponder()
    }
    
    //tableView点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard tableView.cellForRowAtIndexPath(indexPath) is SearchCellView else {
            return
        }
        
        let itemData = appCloud().searchData[indexPath.row-1]
        
        
        BaiduMobStat.defaultStat().logEvent("searchListSelect", eventLabel: itemData.title)
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.newsTitle = itemData.title
        webViewController.newsId = itemData.id
        
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
        
        
        self.navigationController?.pushViewController(webViewController,animated: true)
    }
    
    
    
    
    
}