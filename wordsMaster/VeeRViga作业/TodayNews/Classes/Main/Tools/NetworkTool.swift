//
//  NetworkTool.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 17/2/16.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkTool {
    
    
    
    /// -------------------------- 首 页 home -------------------------
    /// 获取首页顶部标题内容
    class func loadHomeTitlesData(fromViewController: String,completionHandler:@escaping (_ topTitles: [TopicTitle], _ homeTopicVCs: [TopicViewController])->()) {
        let url = BASE_URL + "article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                let dataDict = json["data"].dictionary
                if let data = dataDict!["data"]!.arrayObject {
                    var titles = [TopicTitle]()
                    var homeTopicVCs = [TopicViewController]()
                    
                    // 添加推荐标题
                    let recommendDict = ["category": "__all__", "name": "推荐"]
                    let recommend = TopicTitle(dict: recommendDict as [String : AnyObject])
                    titles.append(recommend)
                    // 添加控制器
                    let firstVC = TopicViewController()
                    firstVC.topicTitle = recommend
                    homeTopicVCs.append(firstVC)
                    completionHandler(titles, homeTopicVCs)
                }
            }
        }
    
    }
    
    /// 获取首页不同分类的新闻内容(和视频内容使用一个接口)
    class func loadHomeCategoryNewsFeed(category: String, completionHandler:@escaping (_ nowTime: TimeInterval,_ newsTopics: [WeiTouTiao])->()) {
        
        let appKey:String = "4eacfe0de4fc322b"
        
        let date = NSDate()
        let timeInterval:TimeInterval = date.timeIntervalSince1970
        let salt:String = NSString(format: "%f" , timeInterval) as String
        
        let word:String = "good"
        let code:String = "veaOCHiBKKTkOFzRnZ5TckzsHzrxE4Ym"
        let rawString:String = appKey + word + salt + code
        let sign:NSString = (rawString as NSString).getMd5() as NSString
        
        let url = BASE_TRANS_URL
        let params = ["q": word,
                      "from": "EN",
                      "to":"zh_CHS",
                      "appKey": appKey,
                      "salt":salt,
                      "sign":sign
                      ] as [String : Any]
        let nowTime = NSDate().timeIntervalSince1970
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                let datas = json["data"].array
                var topics = [WeiTouTiao]()
                for data in datas! {
                    let content = data["content"].stringValue
                    let contentData: NSData = content.data(using: String.Encoding.utf8)! as NSData
                    do {
                        // jsonObject主要将序列化成UTF-8点NSData实例转换成NSDic或者NSArray或者NSString对象
                        let dict = try JSONSerialization.jsonObject(with: contentData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        // 取出标题
                        let topic = WeiTouTiao(dict: dict as! [String : AnyObject])
                        print(dict)
                        print("---------------------------------")
                        topics.append(topic)
                    } catch {
                        
                    }
                }
                completionHandler(nowTime, topics)
            }
        }
    }
    
    /// 获取头条号 关注
    class func loadEntryList(completionHandler:@escaping (_ concerns: [ConcernToutiaohao])->()) {
        let url = BASE_URL + "entry/list/v1/?"
        let params = ["device_id": device_id,
                      "iid": IID]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let data = json["data"].arrayObject {
                    var concerns = [ConcernToutiaohao]()
                    for item in data {
                        let concern = ConcernToutiaohao(dict: item as! [String : AnyObject])
                        concerns.append(concern)
                    }
                    completionHandler(concerns)
                }
            }
        }
    }
    
    
    /// -------------------------- 视 频 video --------------------------
    
       
    // --------------------------  微  头  条  --------------------------
    
    /// 获取微头条数据
    class func loadWeiTouTiaoData(completionHandler: @escaping (_ weitoutiaos: [WeiTouTiao]) -> ()) {
        let url = BASE_URL + "api/news/feed/v54/?"
        let params = ["iid": IID,
                      "category": "weitoutiao",
                      "count": 20,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let dataJSONs = json["data"].array else {
                    return
                }
                var weitoutiaos = [WeiTouTiao]()
                for dataJSON in dataJSONs {
                    if let content = dataJSON["content"].string {
                        let data = content.data(using: String.Encoding.utf8)! as Data
                        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        let weitoutiao = WeiTouTiao(dict: dict as! [String : AnyObject])
                        weitoutiaos.append(weitoutiao)
                    }
                }
                completionHandler(weitoutiaos)
            }
        }
    }
    
    /// 点击了关注按钮
    class func loadFollowInfo(user_id: Int, completionHandler: @escaping (_ isFllowing: Bool)->()) {
        let url = BASE_URL + "2/relation/follow/v2/?"
        let params = ["iid": IID,
                      "user_id": user_id,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let data = json["data"].dictionary else {
                    return
                }
                guard data["description"]?.string == "关注成功" else {
                    return
                }
                if let user = data["user"]?.dictionaryObject {
                    let user_info = WTTUser(dict: user as [String : AnyObject])
                    completionHandler(user_info.is_following!)
                }
            }
        }
        
    }
    
    /// 点击了取消关注按钮
    class func loadUnfollowInfo(user_id: Int, completionHandler: @escaping (_ isFllowing: Bool)->()) {
        let url = BASE_URL + "/2/relation/unfollow/?"
        let params = ["iid": IID,
                      "user_id": user_id,
                      "device_id": device_id] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                guard let data = json["data"].dictionary else {
                    return
                }
                if let user = data["user"]?.dictionaryObject {
                    let user_info = WTTUser(dict: user as [String : AnyObject])
                    completionHandler(user_info.is_following!)
                }
            }
        }
        
    }
    
    // --------------------------------- 我的 mine  ---------------------------------
    /// 我的界面 cell 数据
    class func loadMineCellData(completionHandler: @escaping (_ sectionsArray: [AnyObject])->()) {
        let url = BASE_URL + "user/tab/tabs/?"
        let params = ["iid": IID]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                if let data = json["data"].dictionary {
                    if let sections = data["sections"]?.arrayObject {
                        var sectionArray = [AnyObject]()
                        for section in sections {
                            var rows = [MineCellModel]()
                            for row in section as! [AnyObject] {
                                let mineCell = MineCellModel(dict: row as! [String : AnyObject])
                                rows.append(mineCell)
                            }
                            sectionArray.append(rows as AnyObject)
                        }
                        completionHandler(sectionArray)
                    }
                }
            }
        }
    }
    
    /// 我的关注 
    class func loadMyFollow(completionHandler: @escaping (_ concerns: [MyConcern])->()) {
        let url = BASE_URL + "concern/v2/follow/my_follow/?"
        let params = ["device_id": device_id]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                if let datas = json["data"].arrayObject {
                    var concerns = [MyConcern]()
                    for data in datas {
                        let myConcern = MyConcern(dict: data as! [String: AnyObject])
                        concerns.append(myConcern)
                    }
                    
                    completionHandler(concerns)
                }
            }
        }
    }
    
    /// 关注详情
    class func loadOneFollowDetail(userId: Int, completionHandler: @escaping (_ follewDetail: FollowDetail)->()) {
        let url = BASE_URL + "user/profile/homepage/v3/?"
        let params = ["user_id": userId] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"].string == "success" else {
                    return
                }
                let followDetail = FollowDetail(dict: json["data"].dictionaryObject! as [String : AnyObject])
                completionHandler(followDetail)
            }
        }
    }
    
}
