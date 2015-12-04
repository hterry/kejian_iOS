//
//  WebViewController.swift
//  HelloJames
//
//  Created by Terry on 15/11/19.
//  Copyright © 2015年 IFLABS. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import JavaScriptCore

class WebViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView:CustomWebView!
    @IBOutlet weak var sharePopup:UIView!
    @IBOutlet weak var shareBtn:UIButton!
    @IBOutlet weak var loadingImageView:UIImageView!
    
    var animator: ZFModalTransitionAnimator!
    
    var jsContext: JSContext?
    
    var imageView: UIImageView!
    var orginalHeight: CGFloat = 0
    var titleLabel: myUILabel!
    var sourceLabel: UILabel!
    var refreshImageView: UIImageView!
    var dragging = false
    var triggered = false
    var newsId = "-1"
    var index = 2
    var isTopStory = false
    var hasImage = true
    var isThemeStory = false
    var lastNewsId = "0"
    var webViewUrl = ""
    var shareInfo:ShareModel!
    var shareImage:UIImage!
    var shareImageData:NSData!
    var isShareOpen:Bool = false
    
    //滑到对应位置时调整arrow方向
    var arrowState = false {
        didSet {
            if arrowState == true {
                
                guard index != 0 && isTopStory == false else {
                    return
                }
                
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            } else {
                
                guard index != 0 && isTopStory == false else {
                    return
                }
                
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("WebViewController")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //避免webScrollView的ContentView过长 挡住底层View
        self.view.clipsToBounds = true
        
        //隐藏默认返回button但保留左划返回
        self.navigationController?.navigationBar.hidden=true
        //self.navigationController?.navigationBar.frame = CGRectMake(0, 0, 0, 0)
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //NSLog("%@",String(self.navigationItem.backBarButtonItem))
        
        self.webView.alpha = 0
        self.webView.delegate = self
        self.webView.scrollView.delegate = self
        self.webView.scrollView.clipsToBounds = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        
        self.sharePopup.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 144))
        
        loadingImageView.sd_setImageWithURL(NSURL(string: "http://www.iflabs.cn/app/hellojames/asset/pen.gif"))
        
        if (newsId=="-1"){
            shareBtn.hidden = true
        }
        
        
        //动态添加tap事件
        /*let ges:UIGestureRecognizer = UIGestureRecognizer(target: self, action: "shareCloseMovie")
        ges.cancelsTouchesInView = false
        ges.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "shareCloseMovie")
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.webView.userInteractionEnabled = true
        self.webView.addGestureRecognizer(tap)*/
        //self.webView.addGestureRecognizer(ges)
        
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //必须在viewWillAppear设置隐藏，interactivePopGestureRecognizer才能生效
        self.navigationController?.navigationBar.hidden=true
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        if (lastNewsId != newsId){
            
            loadWebView(newsId)
            lastNewsId = newsId
            
        }
        
        //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "setPopGes", userInfo: nil, repeats: false)
    }
    
    
    
    //加载普通header
    func loadNormalHeader() {
        //载入上一篇Label
        let refreshLabel = UILabel(frame: CGRectMake(12, -45, self.view.frame.width, 45))
        refreshLabel.text = "载入上一篇"
        if index == 0 {
            refreshLabel.text = "已经是第一篇了"
            refreshLabel.frame = CGRectMake(0, -45, self.view.frame.width, 45)
        }
        refreshLabel.textAlignment = NSTextAlignment.Center
        refreshLabel.textColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        refreshLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        if (!self.webView.scrollView.subviews.contains(refreshLabel)){
            self.webView.scrollView.addSubview(refreshLabel)
        }
        
        if refreshLabel.text != "已经是第一篇了" {
            //"载入上一篇"imageView
            refreshImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 47, -30, 15, 15))
            refreshImageView.contentMode = UIViewContentMode.ScaleAspectFill
            refreshImageView.image = UIImage(named: "arrow")?.imageWithRenderingMode(.AlwaysTemplate)
            refreshImageView.tintColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
            self.webView.scrollView.addSubview(refreshImageView)
        }
    }
    
    //加载WebView
    func loadWebView(id: String) {
        //获取网络数据，包括body css image image_source title
        NSLog("id:%@", id)
        if (index==0){
            isTopStory = true
        }
        self.hasImage=false
        self.setNeedsStatusBarAppearanceUpdate()
        
        //self.loadNormalHeader()
        if (id != "-1"){
            let url = "http://www.iflabs.cn/app/hellojames/html/index.html?id=" + id
            webViewUrl = url
        }
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: webViewUrl)!))
        
        return
        
    }
    
    func loadApiFinish(){
        
        
        UIView.animateWithDuration(0.5, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            
            self.webView.alpha = 1
            self.loadingImageView.alpha = 0
            self.loadingImageView.hidden = true
            
            },completion:nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        
        if (newsId=="-1"){
            UIView.animateWithDuration(0.5, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
                ()-> Void in
                
                self.webView.alpha = 1
                self.loadingImageView.alpha = 0
                self.loadingImageView.hidden = true
                
                },completion:nil)
            return
        }
        NSLog("webViewDidFinishLoad")
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = JSObjCModel()
        model.controller = self
        model.jsContext = context
        self.jsContext = context
        
        // 这一步是将OCModel这个模型注入到JS中，在JS就可以通过OCModel调用我们公暴露的方法了。
        self.jsContext?.setObject(model, forKeyedSubscript: "OCModel")
        //let url = NSBundle.mainBundle().URLForResource("test", withExtension: "html")
        
        //self.jsContext?.evaluateScript(try? String(contentsOfURL: NSURL(string: webViewUrl)!, encoding: NSUTF8StringEncoding));
        
        self.jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception)
        }
    }
    
    //实现Parallax效果
    /*func scrollViewDidScroll(scrollView: UIScrollView) {
        //判断是否含图
        if hasImage {
            let incrementY = scrollView.contentOffset.y
            if incrementY < 0 {
                //不断设置titleLabel及sourceLabel以保证frame正确
                titleLabel.frame = CGRectMake(15, orginalHeight - 80 - incrementY, self.view.frame.width - 30, 60)
                sourceLabel.frame = CGRectMake(15, orginalHeight - 20 - incrementY, self.view.frame.width - 30, 15)
                
                //保证frame正确
                //blurView.frame = CGRectMake(0, -85 - incrementY, self.view.frame.width, orginalHeight + 85)
                
                //如果下拉超过65pixels则改变图片方向
                if incrementY <= -65 {
                    arrowState = true
                    //如果此时是第一次检测到松手则加载上一篇
                    guard dragging || triggered else {
                        //index不能为零, 且不为topStory
                        if index != 0 && isTopStory == false {
                            loadNewArticle(true)
                            triggered = true
                        }
                        return
                    }
                } else {
                    arrowState = false
                }
                
                //使Label不被遮挡
                imageView.bringSubviewToFront(titleLabel)
                imageView.bringSubviewToFront(sourceLabel)
            }
            
            
        } else {
            //如果下拉超过40pixels则改变图片方向
            if self.webView.scrollView.contentOffset.y <= -40 {
                arrowState = true
                //如果此时是第一次检测到松手则加载上一篇
                guard dragging || triggered else {
                    //index不能为零, 且不为topStory
                    if index != 0 {
                        loadNewArticle(true)
                        triggered = true
                    }
                    return
                }
            } else {
                arrowState = false
            }
        }
    }*/
    
    //记录下拉状态
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
    //设置滑动极限 修改该值需要一并更改layoutWebHeaderViewForScrollViewOffset中的对应值
    func lockDirection() {
        self.webView.scrollView.contentOffset.y = -85
    }
    
    //加载新文章
    func loadNewArticle(previous: Bool) {
        //生成动画初始位置
        let offScreenUp = CGAffineTransformMakeTranslation(0, -self.view.frame.height)
        let offScreenDown = CGAffineTransformMakeTranslation(0, self.view.frame.height)
        
        //生成新View并传入新数据
        let toWebViewController = self.storyboard!.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController
        let toView = toWebViewController.view
        toView.frame = self.view.frame
        
        //数据相关
        if isThemeStory == false {
            //找到上一篇文章的newsID
            index--
            if index < appCloud().article.count {
                let id = appCloud().article[index].id
                toWebViewController.index = index
                toWebViewController.newsId = id
            } else {
                var newIndex = index - appCloud().article.count
                
                //如果取到的不是文章则取上一篇
                if appCloud().pastContentStory[newIndex] is DateHeaderModel {
                    index--
                    newIndex--
                }
                
                //如果因上述情况newIndex = -1 则取contentStory中数据
                if newIndex > -1 {
                    let id = (appCloud().pastContentStory[newIndex] as! ContentStoryModel).id
                    toWebViewController.index = index
                    toWebViewController.newsId = id
                } else {
                    let id = appCloud().contentStory[index].id
                    toWebViewController.index = index
                    toWebViewController.newsId = id
                }
            }
        } else {
            index--
            let id = appCloud().themeContent!.stories[index].id
            toWebViewController.index = index
            toWebViewController.newsId = id
            toWebViewController.isThemeStory = true
        }
        
        //取得已读新闻数组以供修改
        var readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        //记录已被选中的id
        readNewsIdArray.append(toWebViewController.newsId)
        NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        
        //生成原View截图并添加到主View上
        let fromView = self.view.snapshotViewAfterScreenUpdates(true)
        self.view.addSubview(fromView)
        
        //将toView放置到屏幕之外并添加到主View上
        toView.transform = offScreenUp
        self.view.addSubview(toView)
        self.addChildViewController(toWebViewController)
        
        //动画开始
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //fromView下滑出屏幕，新View滑入屏幕
            fromView.transform = offScreenDown
            toView.transform = CGAffineTransformIdentity
            }, completion: { (success) -> Void in
                //动画完成后清理底层webView、statusBarBackground，以及滑出屏幕的fromView，这里也有问题，多次加载新文章会每次留一层UIView 待解决
                self.webView.removeFromSuperview()
                //self.statusBarBackground.removeFromSuperview()
                fromView.removeFromSuperview()
        })
        
        
    }
    
    @IBAction func backSelect(){
        NSLog("backSelect")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func gotoOtherArticle(id:String){
        if (isShareOpen){
            
            return
        }
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.newsId = id
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem
        
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
    
    func gotoShopping(url:String){
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.newsId = "-1"
        webViewController.webViewUrl = url
        
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem
        
        
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        self.navigationController?.pushViewController(webViewController,animated: true)
        
    }
    //shareSDK Open
    @IBAction func shareSinaOpen(){
        shareSend("weibo")
    }
    @IBAction func shareQqOpen(){
        shareSend("qq")
        
    }
    @IBAction func shareWeixinOpen(){
        shareSend("wx_friend")
        
    }
    @IBAction func shareWxTimelineOpen(){
        shareSend("wx_timeline")
        
    }
    @IBAction func shareQzoneOpen(){
        shareSend("qzone")
        
    }
    
    @IBAction func shareActivity(){
        
        shareCloseMovie()
        
        let textToShare = shareInfo.title+String("\n")+webViewUrl+" from HelloJames"
        let myWebsite = NSURL ( string : webViewUrl)
        var objectsToShare:NSArray = [textToShare,textToShare]
        
        let activityView:UIActivityViewController = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil)

        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    @IBAction func shareOpenMovie(){
        NSLog("shareOpenMovie")
        if (isShareOpen){
            return
        }
        
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            
            /*self.item1.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item2.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item3.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))*/
            
            self.sharePopup.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            
            
            },completion:nil)
        
        isShareOpen = true
    }
    
    @IBAction func shareCloseMovie(){
        NSLog("shareCloseMovie")
        if (!isShareOpen){
            return
        }
        UIView.animateWithDuration(0.3, delay:0, options:UIViewAnimationOptions.AllowUserInteraction, animations: {
            ()-> Void in
            
            /*self.item1.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item2.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))
            self.item3.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 0))*/
            
            self.sharePopup.layer.setAffineTransform(CGAffineTransformMakeTranslation(0, 144))
            
            
            },completion:nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "setShareOpenFalse", userInfo: nil, repeats: false)
    }
    
    func setShareOpenFalse(){
        isShareOpen = false
    }

    
    func shareSend(type:String = ""){
        NSLog("shareInfo:%@", String(shareInfo))
        
        if (type=="wx_friend"||type=="wx_timeline"){
            var message:WXMediaMessage = WXMediaMessage()
            message.title = shareInfo.title
            message.description = shareInfo.des
            //NSLog("shareSend1")
            
            
            //修改图片尺寸
            let width = 240 as CGFloat
            let height = width*shareImage.size.height/shareImage.size.width
            UIGraphicsBeginImageContext(CGSizeMake(width, height))
            shareImage.drawInRect(CGRectMake(0, 0, width, height))
            
            message.setThumbImage(UIGraphicsGetImageFromCurrentImageContext())
            
            var ext:WXWebpageObject = WXWebpageObject()
            ext.webpageUrl = webViewUrl
            message.mediaObject = ext
            message.mediaTagName = "测试"
            var req = SendMessageToWXReq()
            var scene:Int!
            if (type=="wx_friend"){
                scene = 0
            }
            if (type=="wx_timeline"){
                scene = 1
            }
            req.scene = Int32(scene)//0:分享朋友，1:分享朋友圈，2:收藏
            req.text = "分享测试"
            req.bText = false
            req.message = message
            
            WXApi.sendReq(req)
        }
        
        if (type=="weibo"){
            if (WeiboSDK.isCanSSOInWeiboApp()){
                var wbMessage:WBMessageObject = WBMessageObject()
                wbMessage.text = "#HelloJames# " +  shareInfo.title + String(" ") + shareInfo.des + "...... | 阅读原文:" + webViewUrl
                var wbImage:WBImageObject = WBImageObject()
                wbImage.imageData = shareImageData
                wbMessage.imageObject = wbImage
                
                let request:WBSendMessageToWeiboRequest = WBSendMessageToWeiboRequest.requestWithMessage(wbMessage) as! WBSendMessageToWeiboRequest
                WeiboSDK.sendRequest(request)
            }
            
        }
        
        if (type=="qq"||type=="qzone"){
            
            let newsObj:QQApiNewsObject = QQApiNewsObject(URL: NSURL(string: webViewUrl), title: shareInfo.title, description: shareInfo.des, previewImageData: shareImageData, targetContentType: QQApiURLTargetTypeNews)
            
            let req:SendMessageToQQReq = SendMessageToQQReq(content: newsObj)
            
            if (type=="qq"){
                QQApiInterface.sendReq(req)
            }
            if (type=="qzone"){
                QQApiInterface.SendReqToQZone(req)
            }
        }
    }
    
    
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //设置StatusBar为黑色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }

}

// All methods that should apply in Javascript, should be in the following protocol.
@objc protocol JavaScriptSwiftDelegate: JSExport {
    func webViewTouchBegan();
    func getShareInfo(dict: [String: AnyObject]);
    func gotoArticle(id :String);
    func gotoShopping(url :String);
    
    func callSystemCamera();
    
    func showAlert(title: String, msg: String);
    
    func callWithDict(dict: [String: AnyObject])
    
    func jsCallObjcAndObjcCallJsWithDict(dict: [String: AnyObject]);
}
@objc class JSObjCModel: NSObject, JavaScriptSwiftDelegate {
    weak var controller: WebViewController?
    weak var jsContext: JSContext?
    
    func webViewTouchBegan() {
        controller?.shareCloseMovie()
    }
    
    func getShareInfo(dict: [String: AnyObject]){
        NSLog("@getShareInfo:%@",String(dict["thumb"] as! String))
        controller?.shareInfo=ShareModel(thumb: dict["thumb"] as! String, id: dict["id"] as! String, title: dict["title"] as! String, des: dict["des"] as! String)
        
        controller?.shareImageData = NSData(contentsOfURL: NSURL(string: (controller?.shareInfo.thumb)!)!)!
        //NSLog("shareSend2")
        controller?.shareImage = UIImage.sd_imageWithData(controller?.shareImageData)
        controller?.loadApiFinish()
    }
    
    func gotoArticle(id :String){
        NSLog("@gotoArticle:%@",id)
        controller!.gotoOtherArticle(id)
    }
    
    func gotoShopping(url: String) {
        
        NSLog("@gotoShopping:%@",url)
        controller!.gotoShopping(url)
    }
    
    func callSystemCamera() {
        print("js call objc method: callSystemCamera");
        
        let jsFunc = self.jsContext?.objectForKeyedSubscript("jsFunc");
        jsFunc?.callWithArguments([]);
    }
    
    func showAlert(title: String, msg: String) {
        NSLog("@showAlert")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // JS调用了我们的方法
    func callWithDict(dict: [String : AnyObject]) {
        print("js call objc method: callWithDict, args: %@", dict)
    }
    
    // JS调用了我们的就去
    func jsCallObjcAndObjcCallJsWithDict(dict: [String : AnyObject]) {
        print("js call objc method: jsCallObjcAndObjcCallJsWithDict, args: %@", dict)
        
        let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc");
        let dict = NSDictionary(dictionary: ["age": 18, "height": 168, "name": "lili"])
        jsParamFunc?.callWithArguments([dict])
    }
}
