//
//  MainTabViewController.swift
//  HelloJames
//
//  Created by Terry on 15/11/17.
//  Copyright © 2015年 IFLABS. All rights reserved.
//

import UIKit

class MainTabBarController: UIViewController, UIScrollViewDelegate, SWRevealViewControllerDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var mytabBar: UITabBar!
    @IBOutlet weak var item1: UIButton!
    @IBOutlet weak var item2: UIButton!
    @IBOutlet weak var item3: UIButton!
    @IBOutlet weak var sideMenuBtn: SideMenuBtn!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBtnTop:NSLayoutConstraint!
    
    var animator: ZFModalTransitionAnimator!
    var scrollView: UIScrollView!
    
    let totalPageNum = 2
    var currentPageNum = 1
    
    let tabHeight=72
    
    var tabItemList:[MainTabBarItem!]=[]
    var mainViewList:[UIViewController!]=[]
    
    var isTopBarHide = false
    
    var isIndex = true
    
    var blackView:UIView!
    
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("MainTabBarController")
        
        item1.hidden=true
        item2.hidden=true
        item3.hidden=true
        
        //sideMenuBtn.target = self.revealViewController()
        //sideMenuBtn.action = "revealToggle:"
        
        //self.navigationController?.navigationBar.hidden=true
        //self.navigationItem
        //修复navigationbar下tableview顶部留白
        self.edgesForExtendedLayout = UIRectEdge.None
        
        //self.navigationItem.leftBarButtonItem!.title="返回"
        self.navigationItem.title="首页"
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem
        
        //self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //self.navigationItem.backBarButtonItem?.title="返回"
        //self.navigationController?.title="首页"
        //self.navigationController?.navigationBar.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        //self.navigationController?.navigationBar.barStyle=UIBarStyle.Black
        //self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        //self.navigationController?.navigationBar
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        scrollView.frame=CGRectMake(0, CGFloat(tabHeight), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
        
        scrollView.contentSize = CGSizeMake(CGFloat(totalPageNum)*UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        scrollView.backgroundColor = UIColor(white: 0, alpha: 1)
        
        for i in 0..<totalPageNum{
            var myViewController:UIViewController!
            if (i==0){
                myViewController = storyboard?.instantiateViewControllerWithIdentifier("indexViewController")
            }
            /*if (i==1){
                myViewController = storyboard?.instantiateViewControllerWithIdentifier("main2ViewController")
            }*/
            if (i==1){
                myViewController = storyboard?.instantiateViewControllerWithIdentifier("shopTableViewController")
            }
            myViewController.view.frame.origin=CGPointMake(CGFloat(i)*UIScreen.mainScreen().bounds.width,0)
            myViewController.view.frame.size=CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
            
            self.addChildViewController(myViewController)
            scrollView.addSubview(myViewController!.view)
            
            mainViewList.append(myViewController)
            //myViewController?.viewDidLoad()
        }
        
        self.view.insertSubview(scrollView, atIndex: 0)
        
        //blackView.hidden = true
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.revealViewController().delegate = self
        self.revealViewController().frontViewShadowOpacity = 0
        self.revealViewController().rearViewRevealWidth = UIScreen.mainScreen().bounds.width*(2/3)
        //self.revealViewController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideTopBar:", name: "hideTopBar", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTopBarSend:", name: "showTopBar", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "catListSelect:", name: "catListSelect", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoLoginView", name: "loginBtnSelect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoUserInfoView", name: "userInfoSelect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoSettingView", name: "settingBtnSelect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoAboutusView", name: "aboutusBtnSelect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotoSearchView", name: "searchBtnSelect", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushToArticle:", name: "pushToArticle", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openNetworkAlert", name: "openNetworkAlert", object: nil)
        
        /*let swipe = UISwipeGestureRecognizer(target:self, action:Selector("swipe:"))
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        self.scrollView.addGestureRecognizer(swipe)*/

        //addIndexView()
        //indexViewController?.viewDidLoad()
        //self.view.
        
        /*let item1:UITabBarItem = tabBar.items![0] as UITabBarItem
        let item2:UITabBarItem = tabBar.items![1] as UITabBarItem
        let item3:UITabBarItem = tabBar.items![2] as UITabBarItem*/
        
        
        
        /*self.item1.title="新奇趣"
        self.item2.title="巴拉巴拉"
        self.item3.title="传送门"
        
        self.item1.image=UIImage(named: "tab1")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.item2.image=UIImage(named: "tab2")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.item3.image=UIImage(named: "tab3")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        */
        //NSLog("%@", String(self.item1))
        
        addTabBarItems()
        
        blackView=UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        blackView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(blackView)
        blackView.alpha = 0
        
        searchBtn.hidden = true
        searchBtn.alpha = 0
        self.searchBtn.layer.setAffineTransform(CGAffineTransformMakeTranslation(-searchBtn.frame.width, 0))
        
        self.view.bringSubviewToFront(sideMenuBtn)
        self.view.bringSubviewToFront(searchBtn)
        
        //changeToOtherCat()
        
        //changeToIndex()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        if (isIndex){
            self.navigationController?.setNavigationBarHidden(true, animated: true)//隐藏navigationbar
            showTopBar()
        }
        else {
            changeToOtherCatView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        if (isIndex){
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)//进入子页面隐藏navigationbar
            showTopBar()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!isIndex){
            
            //两个结合使用，NavigationBar才能出来，并且内容的frame才能调整正确
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            changeToOtherCatView()
        }
    }
    
    func addIndexView(){
        let indexViewController = storyboard?.instantiateViewControllerWithIdentifier("indexViewController")
        self.addChildViewController(indexViewController!)
        self.view.insertSubview(indexViewController!.view, atIndex: 0)
        
        
        
        indexViewController!.view.frame=CGRectMake(0, CGFloat(tabHeight), indexViewController!.view.frame.width,UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
        
    }
    
    
    func addTabBarItems(){
        let t1=MainTabBarItem(frame: CGRectMake(0, 0, 0, 0))
        let t2=MainTabBarItem(frame: CGRectMake(0, 0, 0, 0))
        let t3=MainTabBarItem(frame: CGRectMake(0, 0, 0, 0))
        
        t1.num=1
        //t2.num=2
        t3.num=2
        
        t1.color=UIColor(red: 242/255, green: 0, blue: 137/255, alpha: 1)
        t2.color=UIColor(red: 0, green: 174/255, blue: 255/255, alpha: 1)
        t3.color=UIColor(red: 0, green: 222/255, blue: 0, alpha: 1)
        
        t1.title="新奇趣"
        //t2.title="巴拉巴拉"
        t3.title="传送门"
        
        self.view.addSubview(t1)
        //self.view.addSubview(t2)
        self.view.addSubview(t3)
        
        t1.makeItem()
        //t2.makeItem()
        t3.makeItem()
        
        tabItemList.append(t1)
        //tabItemList.append(t2)
        tabItemList.append(t3)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changePageSender:", name: "mainTabBarItemTap", object: nil)
        
        currentPageNum = 1
        changeTabItemState()
        
    }
   
    @IBAction func sideMenuBtnTouch(sender: UIButton?){
        NSLog("sideMenuBtnTouch")
        
        
    }
    
    func changePageSender(sender: NSNotification){
        currentPageNum = sender.object as! Int
        changePage()
    }
    
    func changePage(){
        self.scrollView.scrollRectToVisible(CGRectMake(CGFloat(currentPageNum-1)*self.scrollView.frame.width, self.scrollView.frame.origin.y, self.scrollView.frame.width, self.scrollView.frame.height), animated: true)
        
        changeTabItemState()

        
    }
    
    func changeTabItemState(){
        let sv:ShopTableViewController = mainViewList[1] as! ShopTableViewController
        let iv:IndexTableViewController = mainViewList[0] as! IndexTableViewController
        for i in 0..<totalPageNum{
            if (i+1 == currentPageNum){
                tabItemList[i].changeToSelected()
                
                //mainViewList[i]!.scrollEnabled(true)?
                
                if (i==1){
                    iv.tableView.scrollsToTop = false
                    sv.shopTableView.scrollsToTop = true
                    sv.appearLoad()
                }
                else {
                    
                    iv.tableView.scrollsToTop = true
                    sv.shopTableView.scrollsToTop = false
                 }
            }
            else {
                tabItemList[i].changeToUnselected()
                
                //mainViewList[i]!.scrollEnabled(false)?
            }
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        showTopBar()
        if ( scrollView.contentOffset.x<0){
            scrollView.bounces = false
            
            //scrollView第一页向右滑动展出侧栏
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Right, animated: true)
            //scrollView.bounces = true
            //NSLog("offsetLeft")
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        NSLog("scrollViewDidEndDecelerating")
        
        currentPageNum = Int(floor(Double(scrollView.contentOffset.x/UIScreen.mainScreen().bounds.width)))+1
        
        changeTabItemState()
        
        
    }
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if (position == FrontViewPosition.Right){
            
            UIView.animateWithDuration(0.3, animations: {
                ()-> Void in
                self.blackView.alpha = 0.3
                
                self.searchBtn.hidden = false
                self.searchBtn.alpha = 1
                
                self.searchBtn.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            })
            
            sideMenuBtn.openState()
        }
        
        if (position == FrontViewPosition.Left){
           
            UIView.animateWithDuration(0.3, animations: {
                ()-> Void in
                self.blackView.alpha = 0
                self.searchBtn.hidden = true
                self.searchBtn.alpha = 0
                self.searchBtn.layer.setAffineTransform(CGAffineTransformMakeTranslation(-self.searchBtn.frame.width, 0))
            })
            
            sideMenuBtn.closeState()
        }
    }
    
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        NSLog("%@",String(position))
        if (position == FrontViewPosition.Right){
            NSLog("didMoveToRight")
            
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
            
            scrollView.bounces = true
            scrollView.scrollEnabled=false
            UIView.animateWithDuration(0.3, animations: {
                ()-> Void in
                self.blackView.alpha = 0.3
            })
        }
        
        if (position == FrontViewPosition.Left){
            NSLog("didMoveToLeft")
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
            
            scrollView.bounces = true
            if (isIndex){
                scrollView.scrollEnabled=true
            }
            
            UIView.animateWithDuration(0.3, animations: {
                ()-> Void in
                self.blackView.alpha = 0
            })
        }
    }
    
    func hideTopBar(sender:NSNotification){
        if (!isIndex){
            return
        }
        if (isTopBarHide){
            return
        }
        isTopBarHide = true
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        
        /*self.item1.updateConstraintsIfNeeded()
        self.item1.needsUpdateConstraints()
        self.item2.updateConstraintsIfNeeded()
        self.item2.needsUpdateConstraints()
        self.item3.updateConstraintsIfNeeded()
        self.item3.needsUpdateConstraints()
        
        self.item1.setNeedsLayout()
        self.item1.layoutIfNeeded()
        self.item2.setNeedsLayout()
        self.item2.layoutIfNeeded()
        self.item3.setNeedsLayout()
        self.item3.layoutIfNeeded()*/

        
        UIView.animateWithDuration(0.3, animations: {
            ()-> Void in
            
            for i in 0..<self.totalPageNum {
                self.tabItemList[i].layer.setAffineTransform(CGAffineTransformMakeTranslation(0, -CGFloat(self.tabHeight+20)))
            }
            /*self.item1.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, -CGFloat(self.tabHeight+20)))
            self.item2.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, -CGFloat(self.tabHeight+20)))
            self.item3.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, -CGFloat(self.tabHeight+20)))*/
            
            self.scrollView.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, -CGFloat(self.tabHeight+20)))
            self.scrollView.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height+20)
            
            self.sideMenuBtn.alpha = 0
            
        })
    }
    
    func showTopBarSend(sender:NSNotification){
        showTopBar()
    }
    
    func showTopBar(){
        if (!isIndex){
            return
        }
        if (!isTopBarHide){
            return
        }
        isTopBarHide = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        
        
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            
            for i in 0..<self.totalPageNum {
                self.tabItemList[i].layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            }
            
            /*self.item1.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item2.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item3.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))*/
            
            self.scrollView.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
                        self.sideMenuBtn.alpha = 1
            
            },completion:{
                (Bool)-> Void in
                if (!self.isTopBarHide){
                    self.scrollView.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - CGFloat(self.tabHeight))
                }
            }
        )
        
    }
    
    func catListSelect(sender:NSNotification){
        NSLog("%@",String(sender.object))
        let index = sender.object?.valueForKey("index") as? Int
        let title = sender.object?.valueForKey("name") as? String
        NSLog("%d",Int(index!))
        if (index==0){
            changeToIndex()
            
            
        }
        else {
            changeToOtherCat(String(title!))
        }
    }
    
    func changeToIndex(){
        NSLog("changeToIndex")
        isIndex = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        for i in 0..<self.totalPageNum {
            self.tabItemList[i].hidden = false
        }
        
        scrollView.frame.origin=CGPointMake(0, CGFloat(tabHeight))
        
        currentPageNum=1
        
        scrollView.scrollEnabled = true
        changePage()
        
        scrollView.frame=CGRectMake(0, CGFloat(tabHeight), UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
        
        mainViewList[0].view.frame.size=CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - CGFloat(tabHeight))
        
        searchBtnTop.constant=23
        
        showTopBar()
        
        self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
    }
    
    func changeToOtherCat(title:String){
        isIndex = false
        
        self.navigationItem.title=title
        appCloud().currentCatName = title
        
        changeToOtherCatView()
        //self.navigationController?.navigationBar.hidden = false
        
        
    }
    
    
    func changeToOtherCatView(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        for i in 0..<self.totalPageNum {
            self.tabItemList[i].hidden = true
        }
        
        scrollView.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - (self.navigationController?.navigationBar.frame.height)!)
        
        currentPageNum=1
        changePage()
        
        scrollView.scrollEnabled = false
        
        searchBtnTop.constant = 0
        
        //NSLog("height1:%f", (self.navigationController?.navigationBar.frame.height)!)
        //NSLog("height2:%f", UIScreen.mainScreen().bounds.height)
        mainViewList[0].view.frame.size=CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - (self.navigationController?.navigationBar.frame.height)!)
        
        self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
    }
    
    func gotoLoginView(){
        NSLog("gotoLoginView")
        let loginNavigation = appCloud().userStoryBoard.instantiateViewControllerWithIdentifier("loginNavigation") as!LoginNavigation
        
        self.presentViewController(loginNavigation, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "closeRevealView", userInfo: nil, repeats: false)
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func gotoUserInfoView(){
        NSLog("gotoUserInfoView")
        let userInfoNavigation = appCloud().userStoryBoard.instantiateViewControllerWithIdentifier("userInfoNavigation") as!UserInfoNavigation
        
        self.presentViewController(userInfoNavigation, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "closeRevealView", userInfo: nil, repeats: false)
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func gotoSettingView(){
        NSLog("gotoSettingView")
        let settingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("settingViewController") as!SettingViewController
        
        self.presentViewController(settingViewController, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "closeRevealView", userInfo: nil, repeats: false)
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func gotoAboutusView(){
        NSLog("gotoAboutusView")
        let aboutusViewController = self.storyboard?.instantiateViewControllerWithIdentifier("aboutusViewNavigation") as!AboutusViewNavigation
        
        
        
        self.presentViewController(aboutusViewController, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "closeRevealView", userInfo: nil, repeats: false)
        
        //self.navigationController!.navigationBar.hidden = false
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func gotoSearchView(){
        NSLog("gotoSearchView")
        let searchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("searchNavigation") as!SearchNavigation
        
        self.presentViewController(searchViewController, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "closeRevealView", userInfo: nil, repeats: false)
        
        //self.navigationController!.navigationBar.hidden = false
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func closeRevealView(){
        self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
    }
    
    //从推送进入指定文章
    func pushToArticle(sender:NSNotification){
        
        //self.navigationController?.popToRootViewControllerAnimated(false)
        
        //return
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        
        webViewController.newsId = sender.object as! String
        webViewController.newsTitle = "推送文章"
        webViewController.shareBtn.hidden = false
        self.navigationController?.pushViewController(webViewController,animated: true)

    }
    
    
    func openNetworkAlert(){
        self.alert = UIAlertController(title: "", message:"网络不给力哦，请检查移动网络是否可用", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        self.navigationController!.presentViewController(self.alert, animated: true, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "closeAlert", userInfo: nil, repeats: false)
    }
    
    func closeAlert(){
        self.alert.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
}