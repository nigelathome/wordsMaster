//
//  TopicViewController.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 2017/6/11.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {

    // 记录点击的顶部标题
    var topicTitle: TopicTitle?
    
    // 存放新闻主题的数组
    fileprivate var newsTopics = [WeiTouTiao]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.tableHeaderView =  noLoginHeaderView
        
        NetworkTool.loadHomeCategoryNewsFeed(category: topicTitle!.category!) { (nowTime, newsTopics) in
            self.newsTopics = newsTopics
            self.tableView.reloadData()
        }
        
//        NSLog("A - %@", Thread.current)
//        DispatchQueue.main.sync(execute: { () -> Void in
//            NSLog("B - %@", Thread.current)
//        })
//        NSLog("C - %@", Thread.current)
//        
//        
//        let queue = DispatchQueue(label:"myQueue", attributes:.init(rawValue: 0))
//        NSLog("A - %@", Thread.current)
//        queue.async(execute: { () -> Void in
//            NSLog("B - %@", Thread.current)
//            queue.sync(execute: { () -> Void in
//                NSLog("C - %@", Thread.current)
//            })
//            NSLog("D - %@", Thread.current)
//        })
//        NSLog("E - %@", Thread.current)
        
//        //1.创建队列组
//        let group = DispatchGroup()
//        //2.创建队列
//        let queue = DispatchQueue.global()
//        gldispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        //3.多次使用队列组的方法执行任务, 只有异步方法
//        //3.1.执行3次循环
//        dispatch_group_async(group, queue) { () -> Void in
//            for _ in 0..<3 {
//                NSLog("group-01 - %@", Thread.current)
//            }
//        }
//        //3.2.主队列执行8次循环
//        dispatch_group_async(group, dispatch_get_main_queue()) { () -> Void in
//            for _ in 0..<8 {
//                NSLog("group-02 - %@", Thread.current)
//            }
//        }
//        //3.3.执行5次循环
//        dispatch_group_async(group, queue) { () -> Void in
//            for _ in 0..<5 {
//                NSLog("group-03 - %@", Thread.current)
//            }
//        }
//        //4.都完成后会自动通知
//        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
//            NSLog("完成 - %@", Thread.current)
//        }
        
//        let mainQue = OperationQueue.main
//         mainQue.maxConcurrentOperationCount = 1
//        //1.创建NSBlockOperation对象
//        let operation = BlockOperation { () -> Void in
//            NSLog("sohu%@", Thread.current)
//        }
//        
//        //2.添加多个Block
//        for i in 0..<9 {
//            operation.addExecutionBlock { () -> Void in
//                NSLog("sohu第%ld次 - %@", i, Thread.current)
//            }
//            
//        }
        
        //2.开始任务
//        operation.start()
        
        
        
       
//       mainQue.addOperation(operation)
        
//        let userQue = OperationQueue()
        
        
    }
    
    // 头部视图
    fileprivate lazy var noLoginHeaderView: NoLoginHeaderView = {
        let noLoginHeaderView = NoLoginHeaderView.headerView()
        noLoginHeaderView.frame = noLoginHeaderView.galleryScrollView.frame
        noLoginHeaderView.delegate = self
        noLoginHeaderView.pictureGallery()
        return noLoginHeaderView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame:self.view.frame)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0)

//         tableView.backgroundColor = UIColor.red
        tableView.backgroundColor = UIColor.globalBackgroundColor()
        return tableView
    }()
    
}

extension TopicViewController: NoLoginHeaderViewDelegate {
    /// 点击
    func noLoginHeaderViewMoreLoginButotnClicked() {
        let storyboard = UIStoryboard(name: "MoreLoginViewController", bundle: nil)
        let moreLoginVC = storyboard.instantiateViewController(withIdentifier: "MoreLoginViewController") as! MoreLoginViewController
        moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - 40)))
        present(moreLoginVC, animated: true, completion: nil)
    }
}

extension TopicViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(view)
        }
    }
}

// MARK: - Table view data source
extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
//        let weitoutiao = newsTopics[indexPath.row]
//        return weitoutiao.homeCellHeight!
        
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed(String(describing: HomeTopicCell.self), owner: nil, options: nil)?.last as! HomeTopicCell
        cell.weitoutiao = newsTopics[indexPath.row]
        let title:String = String(format: "胜仗之间：人民军队如何打赢未来战争%d", indexPath.item + 1);
        cell.newsTitleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicDetailVC = TopicDetailController()
        navigationController?.pushViewController(topicDetailVC, animated: true)
    
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
}

