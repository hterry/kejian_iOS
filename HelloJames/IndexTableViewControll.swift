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
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:"loadMoreData" );
        
        //下拉刷新组件
        loadingImageView = UIImageView(frame: CGRectMake(0, 0,200, 70))
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
    
    
    func loadMoreData(){
        NSLog("loadMoreData")
        //self.tableView.reloadData()
        
        //self.tableView.reloadData()
        
        appCloud().getArticleData(catid)
        
    }
    
    func loadTodayData(){
        appCloud().article = []
        appCloud().getArticleData(catid)
        
        loadingImageView.hidden = false
    }
    
    
    func reloadData(){
        NSLog("reloadData")
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
        
        appCloud().article = []
        self.tableView.reloadData()
        appCloud().getArticleData(catid);
        
    }
    
    //tableView数据源
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = appCloud().article[indexPath.row] as! ArticleModel
        var num = 50
        if (data.showType=="big"){
            num = 205+5//间距2px
        }
        else {
            
            num = 148+5//间距2px
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
        NSLog("index:%d", indexPath.row)
        let readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        
        let newIndex = indexPath.row
        let data = appCloud().article[newIndex] as! ArticleModel
        let cell = tableView.dequeueReusableCellWithIdentifier("indexTableBigCellView") as! IndexTableBigCellView
        
        NSLog("showType:%@", data.showType)
        NSLog("showType:%@", data.title)
        if (data.showType == "big"){
            cell.bgcolor=data.bgcolor
            cell.changeBgcolor()
            cell.setTitle(data.subTitle1,title2:data.subTitle2,title3:data.subTitle3,titleAll:data.title)
            //NSLog("thumb:%@", data.thumb)
            cell.imagesView.sd_setImageWithURL(NSURL(string:data.thumb))
            //cell.imagesView.image?.sd_animatedImageByScalingAndCroppingToSize(cell.imagesView.frame.size)
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("indexTableSmallCellView") as! IndexTableSmallCellView
            
            //NSLog("@%f", cell.frame.height)
            
            let mutiView1 = cell.cellView1
            let mutiView2 = cell.cellView2
            
            mutiView1.label.text=data.title
            mutiView2.label.text=data.title2
            
            mutiView1.newsId=data.id
            mutiView2.newsId=data.id2
            
            mutiView1.img.sd_setImageWithURL(NSURL(string:data.thumb))
            mutiView2.img.sd_setImageWithURL(NSURL(string:data.thumb2))
            if (data.title2==""){
                
                //NSLog("picurl:%@", data.images2[0])
            }
            return cell
        }
        
         //NSLog("@%f", cell.frame.height)
        //cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        //cell.titleLabel.text = data.title
        
        return cell
    }
    
    //tableView点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //保证点击的是TableContentViewCell
        guard tableView.cellForRowAtIndexPath(indexPath) is IndexTableBigCellView else {
            return
        }
        
        NSLog("indexCellSelect")
        //拿到webViewController
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        
        let newIndex = indexPath.row
        let id = (appCloud().article[newIndex] as! ArticleModel).id
        webViewController.newsId = id
        
        //webViewController.index = indexPath.row
        
        //找到对应newsID
        /*if indexPath.row < appCloud().contentStory.count {
            let id = appCloud().contentStory[indexPath.row].id
            webViewController.newsId = id
        } else {
            let newIndex = indexPath.row - appCloud().contentStory.count
            let id = (appCloud().pastContentStory[newIndex] as! ContentStoryModel).id
            webViewController.newsId = id
        }*/
        
        //取得已读新闻数组以供修改
        //var readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        //记录已被选中的id
        //readNewsIdArray.append(webViewController.newsId)
        //NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        
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
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        
        webViewController.newsId = sender.object as! String
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        
        
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
