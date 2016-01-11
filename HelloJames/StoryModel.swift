//
//  StoryModel.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/2/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import Foundation

struct ShareModel {
    var thumb: String
    var id: String
    var title: String
    var des:String
    
    init (thumb: String, id: String, title: String,des: String) {
        self.thumb = thumb
        self.id = id
        self.title = title
        self.des = des
    }
}

struct ArticleListModel {
    var catid:String
    var list:[ArticleModel]
    
    
    init(catid:String,list:[ArticleModel]){
        self.catid = catid
        self.list = list
    }
}

struct ArticleModel {
    var thumb: String!
    var id: String!
    var catName: String!
    var title: String!
    var showType: String!
    var thumb2: String!
    var id2: String!
    var catName2: String!
    var title2: String!
    var bgcolor: Int!
    var subTitle1: String!
    var subTitle2: String!
    var subTitle3: String!
    
    init (thumb: String, id: String,catName: String, title: String, bgcolor: Int = 1, showType : String = "muti",
        thumb2: String = "", id2: String = "-1",catName2: String = "", title2: String = "", subTitle1: String = "", subTitle2: String = "",subTitle3:String = "") {
            self.thumb = thumb
            self.id = id
            self.catName = catName
            self.title = title
            self.showType = showType
            self.bgcolor = bgcolor
            
            self.thumb = thumb2
            self.id2 = id2
            self.catName2 = catName2
            self.title2 = title2
            
            self.subTitle1 = subTitle1
            self.subTitle2 = subTitle2
            self.subTitle3 = subTitle3
            
            
    }
}

struct ProductModel {
    var id:String!
    var title:String!
    var location:String!
    var image:String!
    var url:String!
    
    init(id:String,title:String,location:String,image:String,url:String){
        self.id=id
        self.title=title
        self.image=image
        self.url=url
        self.location=location
        
    }
}

struct SearchModel {
    var id:String!
    var title:String!
    var des:String!
    var author:String!
    var time:String!
    
    init(id:String,title:String,des:String,author:String,time:String){
        self.id=id
        self.title=title
        self.des=des
        self.author=author
        self.time=time
        
    }
}


protocol PastContentStoryItem {
    
}
struct ContentStoryModel: PastContentStoryItem {
    var images: [String]
    var id: String
    var title: String
    var showType: String
    var images2: [String]
    var id2: String
    var title2: String
    var bgcolor: Int
    init (images: [String], id: String, title: String, bgcolor: Int = 1, showType : String = "muti",
        images2: [String] = [""], id2: String = "", title2: String = "") {
        self.images = images
        self.id = id
        self.title = title
        self.showType = showType
        self.bgcolor = bgcolor
        
        self.images2 = images
        self.id2 = id
        self.title2 = title2
    }
}

struct DateHeaderModel:PastContentStoryItem {
    var date: String
    init (dateString: String) {
        self.date = dateString
    }
}

struct CatModel {
    var id: String
    var name: String
    var image: String
    var color: String!
    init (id: String, name: String, image: String, color: String) {
        self.id = id
        self.name = name
        self.image = image
        self.color = color
    }
}

struct ThemeModel {
    var id: String
    var name: String
    init (id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct ThemeContentModel {
    var stories: [ContentStoryModel]
    var background: String
    var editorsAvatars: [String]
    init (stories: [ContentStoryModel], background: String, editorsAvatars: [String]) {
        self.stories = stories
        self.background = background
        self.editorsAvatars = editorsAvatars
    }
}

struct Keys {
    static let launchImgKey = "launchImgKey"
    static let launchTextKey = "launchTextKey"
    static let readNewsId = "readNewsId"
    
}


struct UserInfo{
    var username:String=""
    var userid:String=""
    var des:String=""
    var avatar:String=""
    var tel:String=""
    var level:String=""
    
    init(userid:String="",username:String="",des:String="",avatar:String="",tel:String="",level:String=""){
        self.userid = userid
        self.username = username
        self.des = des
        self.avatar = avatar
        self.tel = tel
        self.level = level
    }
}
