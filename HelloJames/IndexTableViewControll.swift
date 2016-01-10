//
//  IndexTableViewControll.swift
//  HelloJames
//
//  Created by Terry on 15/11/18.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit
import SDWebImage


class IndexTableViewController: UITableViewController{
    
    var animator: ZFModalTransitionAnimator!
    
    var lastContentY:CGFloat!=0
    
    var catid:String = "-1"
    
    var loadingImageView:UIImageView!
        
    override func viewDidLoad() {
        
        NSLog("IndexTableViewController")
        
        super.viewDidLoad()
        
        
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //self.tableView.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.view.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = 200
        self.automaticallyAdjustsScrollViewInsets = false
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "articleDataGet", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "pastDataGet", object: nil)
        
        //appCloud().getRandomData()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadTodayData")
        appCloud().tabelViewHeader = self.tableView.mj_header
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:"loadMoreData" );
        appCloud().tabelViewFooter = self.tableView.mj_footer
        //下拉刷新组件
        loadingImageView = UIImageView(frame: CGRectMake(0, 0,400, 90))
        loadingImageView.sd_setImageWithURL(NSURL(string: "http://www.iflabs.cn/app/hellojames/asset/refresh.gif"))
        loadingImageView.center.x = UIScreen.mainScreen().bounds.width/2
        //loadingImageView.center.y = 0
        
        let header:MJRefreshNormalHeader! = self.tableView.mj_header as! MJRefreshNormalHeader
        header.addSubview(loadingImageView)
        loadingImageView.hidden = true
        
        header!.stateLabel?.textColor = UIColor.whiteColor()
        header!.setTitle("    下拉刷新奇趣    ", forState:MJRefreshStateIdle)
        header!.setTitle("    松开刷新奇趣    ", forState:MJRefreshStatePulling)
        header!.setTitle("                  ", forState:MJRefreshStateRefreshing)
        
        self.tableView.mj_footer!.tintColor = UIColor.whiteColor()
        
        /*self.tableView.scrollRectToVisible(CGRectMake(0, -100, self.tableView.frame.width, self.tableView.frame.height), animated: true)*/
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "catListSelect:", name: "catListSelect", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mutiCellSelect:", name: "mutiCellSelect", object: nil)
        
        appCloud().getArticleData()
        
        //self.tableView.scrollRectToVisible(CGRectMake(0, 0, 0, 0), animated: false)
        
        //header.hidden=true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func loadMoreData(){
        NSLog("loadMoreData")
        //self.tableView.reloadData()
        
        //self.tableView.reloadData()
        
        appCloud().getArticleData(catid,type: "getMore")
        
        BaiduMobStat.defaultStat().logEvent("listGetMore", eventLabel: appCloud().currentCatName)
    }
    
    func loadTodayData(){
        
        appCloud().getArticleData(catid,type: "refresh")
        loadingImageView.hidden = false
        
        BaiduMobStat.defaultStat().logEvent("listRefresh", eventLabel: appCloud().currentCatName)
    }
    
    
    func reloadData(){
        NSLog("reloadData")
        
        BaiduMobStat.defaultStat().pageviewStartWithName((appCloud().currentCatName+"列表"))
        
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
        NSLog("endRefreshing")
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
        
    }
    
    func catListSelect(sender:NSNotification){
        
        catid = sender.object?.valueForKey("id") as! String
        
        //loadedArticleList = []
        appCloud().article = []
        appCloud().lastSingleMuti = -1
        self.tableView.reloadData()
        appCloud().getArticleData(catid);
        
    }
    
    //tableView数据源
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = appCloud().article[indexPath.row] as! ArticleModel
        var num:CGFloat = 50
        if (data.showType=="big"){
            num = CGFloat(233)*CGFloat(CGFloat(UIScreen.mainScreen().bounds.width)/CGFloat(375))
        }
        else {
            
            num = CGFloat(142)*CGFloat(CGFloat(UIScreen.mainScreen().bounds.width)/CGFloat(375))
        }
        return CGFloat(num)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let num = appCloud().article.count
        //NSLog("count:%d", num)
        var num:Float = 0
        for i in 0 ..< appCloud().article.count{
            if (appCloud().article[i].showType == "big"){
                num++
            }
            else {
                
                num+=0.5
            }
        }
        //NSLog("total:%d",Int(appCloud().article.count))
        //return Int(ceil(Double(num)))
        return Int(appCloud().article.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //取得已读新闻数组以供配置
        if (appCloud().article.count<=0){
            return UITableViewCell(frame: CGRectMake(0, 0, 0, 0));
        }
        NSLog("index:%d", indexPath.row)
        let readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        
        let newIndex = indexPath.row
        let data = appCloud().article[newIndex] as! ArticleModel
        let cell = tableView.dequeueReusableCellWithIdentifier("indexTableBigCellView") as! IndexTableBigCellView
        
        //NSLog("showType:%@", data.showType)
        //NSLog("showType:%@", data.title)
        if (data.showType == "big"){
            cell.bgcolor=data.bgcolor
            cell.changeBgcolor()
            cell.titleLabel4.text = data.catName
            cell.setTitle(data.subTitle1,title2:data.subTitle2,title3:data.subTitle3,titleAll:data.title)
            //NSLog("thumb:%@", data.thumb)
            
            
            if (!checkArticleLoaded(data.id)){
                cell.firstLoad = false
            }
            
            cell.loadImage(data.thumb)
            
            appCloud().loadedArticleList.append(data.id)
            //cell.imagesView.image?.sd_animatedImageByScalingAndCroppingToSize(cell.imagesView.frame.size)
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("indexTableSmallCellView") as! IndexTableSmallCellView
            
            //NSLog("@%f", cell.frame.height)
            
            let mutiView1 = cell.cellView1
            let mutiView2 = cell.cellView2
            
            mutiView1.label.text=data.title
            mutiView2.label.text=data.title2
            
            mutiView1.catLabel.text=data.catName
            mutiView2.catLabel.text=data.catName2
            
            mutiView1.newsId=data.id
            mutiView2.newsId=data.id2
            
            if (!checkArticleLoaded(data.id)){
                mutiView1.firstLoad = false
            }
            
            if (!checkArticleLoaded(data.id)){
                mutiView2.firstLoad = false
            }
            
            mutiView1.loadImage(data.thumb)
            mutiView2.loadImage(data.thumb2)
            
            appCloud().loadedArticleList.append(data.id)
            if (data.id2=="-1"){
                
                mutiView2.backgroundColor = UIColor.blackColor()
                //NSLog("picurl:%@", data.images2[0])
            }
            else{
                if (!checkArticleLoaded(data.id)){
                    mutiView2.img.alpha = 0
                }
                appCloud().loadedArticleList.append(data.id2)
                mutiView2.backgroundColor = UIColor.whiteColor()
            }
            return cell
        }
        
         //NSLog("@%f", cell.frame.height)
        //cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        //cell.titleLabel.text = data.title
        
        return cell
    }
    
    func checkArticleLoaded(id:String)->Bool{
        var bn = false
        
        for i in 0 ..< appCloud().loadedArticleList.count{
            if (appCloud().loadedArticleList[i] == id){
                bn = true
                break
            }
        }
        
        return bn
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        /*if tableView.cellForRowAtIndexPath(indexPath) is IndexTableBigCellView  {
            let myCell = cell  as! IndexTableBigCellView
            myCell.imagesView.alpha=0
        }
        
        if tableView.cellForRowAtIndexPath(indexPath) is IndexTableSmallCellView  {
            let myCell = cell  as! IndexTableSmallCellView
            myCell.cellView1.img.alpha=0
            myCell.cellView2.img.alpha=0
        }*/
        
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //tableView点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //保证点击的是TableContentViewCell
        guard tableView.cellForRowAtIndexPath(indexPath) is IndexTableBigCellView else {
            return
        }
        BaiduMobStat.defaultStat().logEvent("BigCellSelect", eventLabel: appCloud().currentCatName)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("从"+appCloud().currentCatName+"进入文章")
        BaiduMobStat.defaultStat().pageviewEndWithName("从"+appCloud().currentCatName+"进入文章")
        NSLog("indexCellSelect")
        //拿到webViewController
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        
        let newIndex = indexPath.row
        let id = (appCloud().article[newIndex] as! ArticleModel).id
        webViewController.newsId = id
        webViewController.newsTitle = appCloud().article[newIndex].title
        
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        //webViewController.transitioningDelegate = self.animator
        
        //self.navigationController?.navigationBar.hidden=false
        self.parentViewController?.navigationController?.pushViewController(webViewController,animated: true)
        //实施转场
        //self.navigationController!.pushViewController(webViewController, true) { () -> Void in
            
        //}
    }
    
    var isBeginDrag = false
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastContentY = scrollView.contentOffset.y
        isBeginDrag = true
    }
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
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
    
    @IBAction func mutiCellSelect(sender: NSNotification){
        BaiduMobStat.defaultStat().logEvent("MutiCellSelect", eventLabel: appCloud().currentCatName)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("从"+appCloud().currentCatName+"进入文章")
        BaiduMobStat.defaultStat().pageviewEndWithName("从"+appCloud().currentCatName+"进入文章")
        
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        let newsInfo:[String] = sender.object as! [String]
        webViewController.newsId = newsInfo[0]
        
        webViewController.newsTitle = newsInfo[1]
        
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
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //设置StatusBar为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}
