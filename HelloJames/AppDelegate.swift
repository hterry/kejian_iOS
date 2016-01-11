//
//  AppDelegate.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/1/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate, TencentSessionDelegate {
    
    var window: UIWindow?
    var version = "1.1"
    var appStoreLink = "itms-apps://itunes.apple.com/gb/app/"
    
    var userInfo:UserInfo!
    
    var currentCatid:String = "-1"
    var currentCatName:String = "最新"
    
    var articleList: [ArticleListModel] = []
    var article: [ArticleModel] = []
    
    var product:[ProductModel] = []
    var loadedProductList:[String] = []
    
    var cats: [CatModel] = []
    var firstDisplay = true
    var dataDate:Int = 0;
    var isPushOpen = false
    var loadedArticleList:[String] = []
    
    var searchData:[SearchModel] = []
    
    var tabelViewHeader:MJRefreshHeader! = nil
    var shopTabelViewHeader:MJRefreshHeader! = nil
    var tabelViewFooter:MJRefreshFooter! = nil
    var shopTabelViewFooter:MJRefreshFooter! = nil
    var searchTableViewHeader:MJRefreshHeader! = nil
    var searchTableViewFooter:MJRefreshFooter! = nil
    
    var userStoryBoard:UIStoryboard!
    
    let redColor:UIColor = UIColor(red: 242/255, green: 0, blue: 137/255, alpha: 1)
    let blueColor:UIColor = UIColor(red: 0, green: 174/255, blue: 255/255, alpha: 1)
    let greenColor:UIColor = UIColor(red: 0, green: 222/255, blue: 0, alpha: 1)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        userStoryBoard = UIStoryboard(name: "User", bundle: nil)
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        
        //自定义全局UINavigationBar
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor=UIColor(white: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        UINavigationBar.appearance().backItem?.title="返回"
        
        //获取栏目列表
        getCatData()
        
        //初始化已读新闻数组
        if NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) == nil {
            let readNewsIdArray: [String] = []
            NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        //shareSDK
        //ShareSDK.connectWeChatFavWithAppId("wxcb5845e578922637", appSecret: "01d4879c888b8ac1c582a0f037f0592d",wechatCls: WXApi.classForCoder())
        WXApi.registerApp("wx97ed15df8f6ea971")
        
        //WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp("1947160717")
        
        TencentOAuth.init(appId: "1104927341", andDelegate: self)
        
        UMessage.startWithAppkey("566ba092e0f55a3cea006b9b", launchOptions:launchOptions)
        //UMessage.setLogEnabled(true)
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[.Alert,.Badge] , categories: nil)
            
            UMessage.registerRemoteNotificationAndUserNotificationSettings(settings)
            
            //application.registerUserNotificationSettings(settings)
            //application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            
            UMessage.registerForRemoteNotificationTypes([.Alert,.Badge])
            
            //application.registerForRemoteNotificationTypes([.Alert,.Sound,.Badge])
            
            
        }
        
        //腾讯信鸽
        /*XGPush.startApp(2200169925,appKey:"I3QS29FFH73R")
        XGPush.setAccount("Terry")*/
        //JPush
        
        /*APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue, categories: nil)
        
        APService.setupWithOption(launchOptions)*/
        
        BaiduMobStat.defaultStat().enableDebugOn = true
        BaiduMobStat.defaultStat().channelId = "AppStore"
        BaiduMobStat.defaultStat().shortAppVersion = version
        BaiduMobStat.defaultStat().startWithAppId("67d0d6ac5c")
        
        
        //MobClick.startWithAppkey("5667904be0f55aeb2000115a")
        //MobClick.startWithAppkey("5667904be0f55aeb2000115a", reportPolicy: BATCH, channelId: "tongbutui")
        //MobClick.setLogEnabled(true)
        
        getAppInfo()
        
        NSLog("launchOptions:%@",String(launchOptions))
        if (launchOptions != nil){
            let userInfo = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey]
            
            if ((userInfo) != nil){
                
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector:("lanuchGotoArticle:"), userInfo: userInfo, repeats: false)
                
                UMessage.didReceiveRemoteNotification(userInfo! as! [NSObject : AnyObject])
            }
        }
        
        userInfo=UserInfo()
        userInfo.username = "January"
        
        //aesTest
        let aes = try!
            "terry".aesEncrypt("bbA3H18lkVbQDfak")
        NSLog("AES:%@",aes)
        //NSLog("md5:%@","terry".md5())
        return true
    }
    
    func lanuchGotoArticle(timer:NSTimer){
        let newsid = timer.userInfo!["newsid"]
        
        NSLog("launchOptionsDidReceiveRemoteNotification:%@", String(newsid))
    NSNotificationCenter.defaultCenter().postNotificationName("pushToArticle", object: String(newsid!!.integerValue!))
    }
    
    //将deviceToken注册到JPush
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        NSLog("didRegisterForRemoteNotificationsWithDeviceToken:%@",String(deviceToken))
        //534d79e2b586ce5b01b9657a0e22bfcdd5130fe3ccb1391ae69da7769fdccc3c
        //APService.registerDeviceToken(deviceToken)
        
        //XGPush.registerDevice(deviceToken)
        UMessage.registerDeviceToken(deviceToken)
    }
    
    //推送通知状态更改
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        NSLog("didRegisterUserNotificationSettings:%@",String(notificationSettings.types))
        
        if (notificationSettings.types == UIUserNotificationType.None){
            isPushOpen = false
        }
        else {
            isPushOpen = true
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("didFailToRegisterForRemoteNotificationsWithError")
        
    }
    //从通知进入app
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        NSLog("didReceiveRemoteNotification")
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        if (application.applicationState == UIApplicationState.Inactive){
            let newsid = userInfo["newsid"]
            
            NSLog("didReceiveRemoteNotification:%@", String(newsid))
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("pushToArticle", object: String(newsid!.integerValue!))
        }
        //APService.handleRemoteNotification(userInfo)
        UMessage.didReceiveRemoteNotification(userInfo)
    }
    
  
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WeiboSDK.handleOpenURL(url, delegate: self )
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return WeiboSDK.handleOpenURL(url, delegate: self )
    }
    
    //WeiboSDKDelegate必填方法
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
    }
    
    //TencentSessionDelegate必填方法
    func tencentDidLogin() {
        
    }
    
    func tencentDidNotLogin(cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        NSLog("network:%@", String(Reach().connectionStatus()))
    }
    
    func checkNetwork()->Bool{
        let status = Reach().connectionStatus()
        if (status.description == ReachabilityStatus.Offline.description || status.description == ReachabilityStatus.Unknown.description){
            if (self.tabelViewHeader != nil){
                self.tabelViewHeader.endRefreshing()
            }
            if (self.tabelViewFooter != nil){
                self.tabelViewFooter.endRefreshing()
            }
            if (self.shopTabelViewHeader != nil){
                self.shopTabelViewHeader.endRefreshing()
            }
            if (self.shopTabelViewFooter != nil){
                self.shopTabelViewFooter.endRefreshing()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("openNetworkAlert", object: nil)
            return false
            
        }
        return true

    }
    
    func getAppInfo(){
        Alamofire.request(.GET, "http://www.iflabs.cn/app/hellojames/api/api.php?type=getAppInfo").responseJSON { (_, _, dataResult) -> Void in
            guard dataResult.error == nil else {
                print("获取数据失败")
                return
            }
            let data = JSON(dataResult.value!)
            self.appStoreLink = String(data["applink"])
            
            NSLog("appLink:%@", self.appStoreLink)
        }
    }
    //获取栏目列表数据
    func getCatData() {
        currentCatid = "-1"
        self.articleList.append(ArticleListModel(catid: "-1",list: []))
        self.cats = []
        Alamofire.request(.GET, "http://www.iflabs.cn/app/hellojames/api/api.php?type=getCatList").responseJSON { (_, _, dataResult) -> Void in
            guard dataResult.error == nil else {
                print("获取数据失败")
                return
            }
            
            //取到内容数组
            let data = JSON(dataResult.value!)["catList"]
            for i in 0 ..< data.count {
                self.cats.append(CatModel(id: String(data[i]["id"]), name: data[i]["name"].string!, image:data[i]["image"].string!, color:data[i]["color"].string!))
                
                
            }
            
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("catListDataGet", object: nil)
        }
    }
    
    func getCatName(catid:String)->String{
        for i in 0 ..< cats.count {
            if (catid == cats[i].id){
                return cats[i].name
            }
        }
        return ""
        
    }
    
    func getArticleListModel(catid:String)->ArticleListModel{
        
        
        for i in 0 ..< articleList.count {
            if (catid == articleList[i].catid){
                return articleList[i]
            }
        }
        return ArticleListModel(catid: "",list: [])
    }
    
    //获取最新文章列表数据
    var lastSingleMuti:Int! = -1
    var lastUpdateTime:String = ""
    func getArticleData(catid:String = "-1",type:String = "refresh"){
        NSLog("getArticleData:%@",catid)
        
        if (!checkNetwork()){
            
            return
        }
        
        //输出上一天日期
        /*self.dataDate+=1;
        let before:NSDate = NSDate().dateByAddingTimeInterval(28800-Double(self.dataDate)*86400)
        let beforeURL = getCalenderString(NSDate().dateByAddingTimeInterval(28800-Double(self.dataDate)*86400).description)*/
        
        if (type == "getMore"){
            //article = getArticleListModel(catid).list
        }
        if (type == "refresh"){
            
            //article = []
            lastSingleMuti = -1
        }
        
        var  timeInterval:String = String(NSDate().timeIntervalSince1970)
        if (type == "getMore"){
            timeInterval = lastUpdateTime
        }
        
        Alamofire.request(.GET,
            "http://www.iflabs.cn/app/hellojames/api/api.php?type=getNewsList&catid="+catid+"&updateTime="+String(timeInterval)).responseJSON { (_, _, resultData) -> Void in
            guard resultData.error == nil else {
                print("数据获取失败")
                return
            }
            if (type == "refresh"){
                    
                self.article = []
            }
            let data = JSON(resultData.value!)
            NSLog("data:%@",String(data))
            var articleData = data["list"]
            var pastMuti = false
                
            if (articleData.count<=0){
                if (type == "getMore"){
                    self.tabelViewFooter.endRefreshingWithNoMoreData()
                }
                return
            }
                
            self.lastUpdateTime = String(articleData[articleData.count-1]["inputTime"])
            for i in 0 ..< articleData.count {
                if (!pastMuti){
                    var count:Int!
                    count = self.article.count
                    
                    if (articleData[i]["showType"]=="0"){
                        self.article.append(ArticleModel(thumb: String(articleData[i]["thumb"]), id: String(articleData[i]["id"]), catName:self.getCatName(String(articleData[i]["catid"])), title: String(articleData[i]["title"])))
                        
                        
                        
                        self.article[count].thumb=String(articleData[i]["thumb"])

                        
                        self.article[count].subTitle1=articleData[i]["subTitle1"].string!
                        self.article[count].subTitle2=articleData[i]["subTitle2"].string!
                        self.article[count].subTitle3=articleData[i]["subTitle3"].string!
                        self.article[count].showType="big"
                        if (articleData[i]["titleColor"].string! == "random"){
                            //self.article[count].bgcolor=Int(arc4random() % 3 )
                            self.article[count].bgcolor = -1
                        }
                        else {
                            if (articleData[i]["titleColor"].string! == "red"){
                                self.article[count].bgcolor=0
                            }
                            if (articleData[i]["titleColor"].string! == "green"){
                                self.article[count].bgcolor=1
                            }
                            if (articleData[i]["titleColor"].string! == "blue"){
                                self.article[count].bgcolor=2
                            }
                        }
                    }
                    else {
                        if (self.lastSingleMuti == -1){
                            
                            self.article.append(ArticleModel(thumb: String(articleData[i]["thumb"]), id: String(articleData[i]["id"]), catName:self.getCatName(String(articleData[i]["catid"])), title: String(articleData[i]["title"])))
                            
                            
                            self.article[count].thumb=String(articleData[i]["thumb"])

                            
                            self.article[count].showType="muti"
                            if ((i+1<articleData.count)){
                                if (articleData[i+1]["showType"] != "0"){
                                    self.article[count].id2=String(articleData[i+1]["id"])
                                    self.article[count].catName2=self.getCatName(String(articleData[i+1]["catid"]))
                                    self.article[count].title2=String(articleData[i+1]["title"].string!)
                                    self.article[count].thumb2=articleData[i+1]["thumb"].string!
                                    pastMuti=true
                                }
                                else {
                                    
                                    self.article[count].thumb2=""
                                    pastMuti=false
                                    self.lastSingleMuti=count
                                }
                            }
                            else {
                                self.article[count].thumb2=""
                                pastMuti=false
                                self.lastSingleMuti=count
                            }
                            
                            continue
                        }
                        else {
                            NSLog("lastSingleMuti")
                            self.article[self.lastSingleMuti].id2=String(articleData[i]["id"])
                            self.article[self.lastSingleMuti].catName2=self.getCatName(String(articleData[i]["catid"]))
                            self.article[self.lastSingleMuti].title2=String(articleData[i]["title"].string!)
                            self.article[self.lastSingleMuti].thumb2=articleData[i]["thumb"].string!
                            self.lastSingleMuti = -1
                            pastMuti=false
                        }
                    }
                }
                if (pastMuti){
                    pastMuti=false
                }
            }
                
            var articleListModel:ArticleListModel = self.getArticleListModel(catid)
            articleListModel.list = self.article
            //NSLog("%@", String(self.article))
            NSNotificationCenter.defaultCenter().postNotificationName("articleDataGet", object: nil)
            
        }
        
    }
    
    var productLastUpdateTime:String = ""
    func getProductData(type:String){
        if (!checkNetwork()){
            
            return
        }
        
        
        if (type == "getMore"){
            //article = getArticleListModel(catid).list
        }
        if (type == "refresh"){
            product = []
        }
        
        var  timeInterval:String = String(NSDate().timeIntervalSince1970)
        if (type == "getMore"){
            timeInterval = productLastUpdateTime
        }
        NSLog("%@", "http://www.iflabs.cn/app/hellojames/api/api.php?type=getProductList&updateTime="+String(timeInterval))
        Alamofire.request(.GET,
            "http://www.iflabs.cn/app/hellojames/api/api.php?type=getProductList&updateTime="+String(timeInterval)).responseJSON { (_, _, resultData) -> Void in
                guard resultData.error == nil else {
                    print("数据获取失败")
                    return
                }
                let data = JSON(resultData.value!)
                var productData = data["list"]
                
                if (productData.count<=0){
                    if (type == "getMore"){
                        self.shopTabelViewFooter.endRefreshingWithNoMoreData()
                    }
                    return
                }
                
                self.productLastUpdateTime = String(productData[productData.count-1]["inputTime"])
                for i in 0 ..< productData.count {
                    self.product.append(ProductModel(id: String(productData[i]["id"]), title: String(productData[i]["title"]),location:String(productData[i]["location"]) , image: String(productData[i]["image"]),url: String(productData[i]["url"])))
                    
                }
                //NSLog("%@", String(self.product))
                NSNotificationCenter.defaultCenter().postNotificationName("productDataGet", object: nil)
         }

    }
    
    var searchLastUpdateTime:String = ""
    func getSearchData(type:String,keywords:String){
        if (!checkNetwork()){
            return
        }
        
        NSLog("getSearchData")
        
        if (type == "getMore"){
            //article = getArticleListModel(catid).list
        }
        
        var  timeInterval:String = String(NSDate().timeIntervalSince1970)
        if (type == "getMore"){
            timeInterval = searchLastUpdateTime
        }
        
        let keywords2:String! = keywords.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        Alamofire.request(.GET,
            "http://www.iflabs.cn/app/hellojames/api/api.php?type=search&keywords="+keywords2+"&updateTime="+String(timeInterval)).responseJSON { (_, _, resultData) -> Void in
                guard resultData.error == nil else {
                    print("数据获取失败")
                    return
                }
                if (type == "refresh"){
                    self.searchData = []
                }
                
                let data = JSON(resultData.value!)
                var searchJsonData = data["list"]
                NSLog("%@", String(data))
                
                if (searchJsonData.count<=0){
                    if (type == "getMore"){
                        self.searchTableViewFooter.endRefreshingWithNoMoreData()
                        

                    }
                    else {
                        self.searchTableViewHeader.endRefreshing()
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("searchDataGet", object: nil)
                    }
                    return
                }
                
                self.searchLastUpdateTime = String(searchJsonData[searchJsonData.count-1]["inputTime"])
                for i in 0 ..< searchJsonData.count {
                    self.searchData.append(SearchModel(id: String(searchJsonData[i]["id"]), title: String(searchJsonData[i]["title"]),des:String(searchJsonData[i]["des"]) , author: String(searchJsonData[i]["author"]),time: String(searchJsonData[i]["time"])))
                    
                }
                //NSLog("%@", String(self.product))
                NSNotificationCenter.defaultCenter().postNotificationName("searchDataGet", object: nil)
        }
        
    }
    
    func sendSuggest(txt:String){
        let txt2 = txt.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        NSLog("sendSuggest:%@",txt2!)
        Alamofire.request(.GET, "http://www.iflabs.cn/app/hellojames/api/api.php?type=sendSuggest&txt"+txt2!)
    }
    
    //用户相关
    func saveUserInfo(headpicBase64:String){
        NSLog("saveUserInfo")
        //let headpicBase642:String! = headpicBase64.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = "http://www.iflabs.cn/app/hellojames/api/api.php?type=saveUserInfo"
        
        let parameters = [
            "headpic": headpicBase64]
        
        NSLog("%@", url)
        Alamofire.request(.POST,url,parameters:parameters).responseJSON{ (_, _, resultData) -> Void in
            guard resultData.error == nil else {
                print("数据获取失败")
                return
            }
            let data = JSON(resultData.value!)
            NSLog("saveUserInfoFinish:%@",String(data["result"]))
            NSLog("saveUserInfoAvatar:%@",String(data["avatar"]))
            
            self.userInfo.avatar = String(data["avatar"])
            NSNotificationCenter.defaultCenter().postNotificationName("updateUserInfo", object:nil)
        }
    }
    
    
    // MARK: - 日期相关
    func getCalenderString(dateString: String) -> String {
        var calenderString = ""
        for character in dateString.characters {
            if character != " " && character != "-"{
                calenderString += "\(character)"
            } else if character == " " {
                break
            }
        }
        return calenderString
    }
    
    func getDetailString(dateString: String) -> String {
        //拿到month
        var month = ""
        month = dateString.substringWithRange(Range(start: dateString.startIndex.advancedBy(4), end: dateString.startIndex.advancedBy(6)))
        if month.hasPrefix("0") {
            month.removeAtIndex(month.startIndex)
        }
        //拿到day
        var day = ""
        day = dateString.substringWithRange(Range(start: dateString.startIndex.advancedBy(6), end: dateString.startIndex.advancedBy(8)))
        if day.hasPrefix("0") {
            day.removeAtIndex(day.startIndex)
        }
        //拼接返回
        return month + "月" + day + "日"
    }
    
    /*func getRandomData(){
        NSLog("getRandomData")
        let ran=(arc4random() % 5) * 2+5
        for i in 0 ..< ran{
            //NSLog("%f",Float(i)/3)
            if Float(Float(i)/3) == Float(floor(Double(i/3))){
                self.contentStory.append(ContentStoryModel(images: ["http://pic1.zhimg.com/f7e095644fc86fe9f14fec9ee310fdc0.jpg"], id: String(""), title: "titleas,dmaskldjsakldjsalkdjsakldjsakldjsakldjsakldsajd", showType: "big", bgcolor: Int(arc4random() % 2 )))
            }
            
            else{
                self.contentStory.append(ContentStoryModel(images: ["http://pic1.zhimg.com/f7e095644fc86fe9f14fec9ee310fdc0.jpg"], id: String(""), title: "title1", showType: "muti", title2:"title2", images2: ["http://pic1.zhimg.com/f7e095644fc86fe9f14fec9ee310fdc0.jpg"]))
                
            }
            
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("randomDataGet", object: nil)
    }*/
}

extension NSDate {
    func dayOfWeek() -> String {
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        let intValue = (days - 3) % 7
        switch intValue {
        case 0:
            return "星期日"
        case 1:
            return "星期一"
        case 2:
            return "星期二"
        case 3:
            return "星期三"
        case 4:
            return "星期四"
        case 5:
            return "星期五"
        case 6:
            return "星期六"
        default:
            break
        }
        return "未取到数据"
    }
}
import Foundation
extension String {
    func aesEncrypt(key: String, iv: String = "0123456789012345") throws -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    func aesDecrypt(key: String, iv: String = "0123456789012345") throws -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
    }
}

