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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate, TencentSessionDelegate {
    
    var window: UIWindow?
    var article: [ArticleModel] = []
    var contentStory: [ContentStoryModel] = []
    var pastContentStory: [PastContentStoryItem] = []
    var offsetYValue: [(CGFloat, String)] = []
    var cats: [CatModel] = []
    var themeContent: ThemeContentModel?
    var firstDisplay = true
    var dataDate:Int = 0;
    
    let redColor:UIColor = UIColor(red: 242/255, green: 0, blue: 137/255, alpha: 1)
    let blueColor:UIColor = UIColor(red: 0, green: 174/255, blue: 255/255, alpha: 1)
    let greenColor:UIColor = UIColor(red: 0, green: 222/255, blue: 0, alpha: 1)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //自定义全局UINavigationBar
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor=UIColor(white: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        UINavigationBar.appearance().backItem?.title="返回"
        //获取文章内容
        //getTodayData()
        
        //获取栏目列表
        getCatData()
        
        //初始化已读新闻数组
        if NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) == nil {
            let readNewsIdArray: [String] = []
            NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        }
        
        
        //shareSDK
        //ShareSDK.connectWeChatFavWithAppId("wxcb5845e578922637", appSecret: "01d4879c888b8ac1c582a0f037f0592d",wechatCls: WXApi.classForCoder())
        WXApi.registerApp("wxcb5845e578922637")
        
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp("3899209537")
        
        TencentOAuth.init(appId: "1104927341", andDelegate: self)
        
                
        return true
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
    
    //获取最新文章列表数据
    func getArticleData(catid:String = "-1"){
        NSLog("getArticleData:%@",catid)
        //NSLog("%@", "http://www.iflabs.cn/app/hellojames/api/api.php?type=getNewsList&catid="+catid)
        Alamofire.request(.GET, "http://www.iflabs.cn/app/hellojames/api/api.php?type=getNewsList&catid="+catid).responseJSON { (_, _, resultData) -> Void in
            guard resultData.error == nil else {
                print("数据获取失败")
                return
            }
            let data = JSON(resultData.value!)
            var articleData = data["list"]
            NSLog("%@", String(articleData))
            var pastMuti = false
            for i in 0 ..< articleData.count {
                if (!pastMuti){
                    let count = self.article.count + i
                    self.article.append(ArticleModel(thumb: String(articleData[i]["thumb"]), id: String(articleData[i]["id"]), title: String(articleData[i]["title"])))
                    NSLog("%d",i)
                    NSLog("%@", String(articleData[i]["title"]))
                    
                    self.article[self.article.count-1].thumb=String(articleData[i]["thumb"])
                    
                    if (articleData[i]["showType"]=="0"){
                        
                        self.article[self.article.count-1].subTitle1=articleData[i]["subTitle1"].string!
                        self.article[self.article.count-1].subTitle2=articleData[i]["subTitle2"].string!
                        self.article[self.article.count-1].subTitle3=articleData[i]["subTitle3"].string!
                        self.article[self.article.count-1].showType="big"
                        self.article[self.article.count-1].bgcolor=Int(arc4random() % 3 )
                    }
                    else {
                        self.article[self.article.count-1].showType="muti"
                        if ((i+1<articleData.count)){
                            if (articleData[i+1]["showType"] != "0"){
                                self.article[self.article.count-1].id2=String(articleData[i+1]["id"])
                                self.article[self.article.count-1].title2=String(articleData[i+1]["title"].string!)
                                self.article[self.article.count-1].thumb2=articleData[i+1]["thumb"].string!
                                pastMuti=true
                            }
                            else {
                                self.article[self.article.count-1].thumb2=""
                                pastMuti=false
                            }
                        }
                        else {
                            self.article[self.article.count-1].thumb2=""
                            pastMuti=false
                        }
                        
                        continue
                    }
                }
                if (pastMuti){
                    pastMuti=false
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("articleDataGet", object: nil)
            //NSLog("%@", String(self.article))
        }
        
    }
    
    // MARK: - 数据相关
    func getTodayData() {
        NSLog("getTodayData")
        contentStory = []
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/latest").responseJSON { (_, _, resultData) -> Void in
            guard resultData.error == nil else {
                print("数据获取失败")
                return
            }
            let data = JSON(resultData.value!)
            //取到本日文章列表数据
            let topStoryData = data["top_stories"]
            let contentStoryData = data["stories"]
            
            //注入topStory
            /*for i in 0 ..< topStoryData.count {
                self.topStory.append(TopStoryModel(image: topStoryData[i]["image"].string!, id: String(topStoryData[i]["id"]), title: topStoryData[i]["title"].string!))
            }*/
            //注入contentStory
            var pastMuti = false
            for i in 0 ..< contentStoryData.count {
                if (!pastMuti){
                    self.contentStory.append(ContentStoryModel(images: [contentStoryData[i]["images"][0].string!], id: String(contentStoryData[i]["id"]), title: contentStoryData[i]["title"].string!))
                    if Float(Float(i)/3) == Float(floor(Double(i/3))){
                        self.contentStory[self.contentStory.count-1].showType="big"
                        self.contentStory[self.contentStory.count-1].bgcolor=Int(arc4random() % 2 )
                    }
                    else {
                        self.contentStory[self.contentStory.count-1].showType="muti"
                        if (i+1<contentStoryData.count){
                            self.contentStory[self.contentStory.count-1].id2=String(contentStoryData[i+1]["id"])
                            self.contentStory[self.contentStory.count-1].title2=String(contentStoryData[i+1]["title"].string!)
                            self.contentStory[self.contentStory.count-1].images2=[contentStoryData[i+1]["images"][0].string!]
                            
                        }
                        else {
                            self.contentStory[self.contentStory.count-1].images2=[""]
                        }
                        
                        pastMuti=true
                        continue
                    }
                }
                
                if (pastMuti){
                    pastMuti=false
                }
            }
            //设置offsetYValue
            //self.offsetYValue.append((120 + CGFloat(contentStoryData.count) * 93, "今日热闻"))
            //发出完成通知
            NSNotificationCenter.defaultCenter().postNotificationName("todayDataGet", object: nil)
            
            //获取过去三天的文章内容
            //self.getPastData()
        }
    }
    
    func getPastData() {
        self.dataDate+=1;
        
        let before:NSDate = NSDate().dateByAddingTimeInterval(28800-Double(self.dataDate)*86400)
        let beforeURL = getCalenderString(NSDate().dateByAddingTimeInterval(28800-Double(self.dataDate)*86400).description)
        
        
        NSLog("url:%@","http://news.at.zhihu.com/api/4/news/before/" + beforeURL)
        Alamofire.request(.GET, "http://news.at.zhihu.com/api/4/news/before/" + beforeURL).responseJSON { (_, _, resultData) -> Void in
            guard resultData.error == nil else {
                print("数据获取失败")
                return
            }
            let data = JSON(resultData.value!)
            
            //取得日期Cell数据
            let tempDateString = self.getDetailString(beforeURL)+before.dayOfWeek()
            self.pastContentStory.append(DateHeaderModel(dateString: tempDateString))
            
            //取得文章列表数据
            
            let contentStoryData = data["stories"]
            
            //注入pastContentStory
            
            var pastMuti = false
            for i in 0 ..< contentStoryData.count {
                if (!pastMuti){
                    self.contentStory.append(ContentStoryModel(images: [contentStoryData[i]["images"][0].string!], id: String(contentStoryData[i]["id"]), title: contentStoryData[i]["title"].string!))
                    if Float(Float(i)/3) == Float(floor(Double(i/3))){
                        self.contentStory[self.contentStory.count-1].showType="big"
                        self.contentStory[self.contentStory.count-1].bgcolor=Int(arc4random() % 2 )
                    }
                    else {
                        self.contentStory[self.contentStory.count-1].showType="muti"
                        if (i+1<contentStoryData.count){
                            
                            self.contentStory[self.contentStory.count-1].id2=String(contentStoryData[i+1]["id"])
                            self.contentStory[self.contentStory.count-1].title2=String(contentStoryData[i+1]["title"].string!)
                            self.contentStory[self.contentStory.count-1].images2=[contentStoryData[i+1]["images"][0].string!]
                            
                        }
                        else {
                            self.contentStory[self.contentStory.count-1].images2=[""]
                            NSLog("mutiEmpty")
                        }
                        
                        pastMuti=true
                        continue
                    }
                }
                
                if (pastMuti){
                    pastMuti=false
                }
            }
            
            //设置offsetYValue
            //self.offsetYValue.append((self.offsetYValue.last!.0 + 30 + CGFloat(contentStoryData.count) * 93, tempDateString))
            
            NSNotificationCenter.defaultCenter().postNotificationName("pastDataGet", object: nil)
            
            //NSLog("%@", String(self.offsetYValue))
        }
        
        
    }
    //获取栏目列表数据
    func getCatData() {
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
    
    func getRandomData(){
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
    }
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

