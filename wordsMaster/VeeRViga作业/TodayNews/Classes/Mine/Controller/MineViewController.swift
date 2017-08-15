//
//  MineViewController.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 2017/6/13.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit
import IBAnimatable

class MineViewController: UITableViewController {

    fileprivate var sections = [AnyObject]()
    fileprivate var concerns = [MyConcern]()
    // 记录点击的顶部标题
    var topicTitle: TopicTitle?
    // 存放新闻主题的数组
    fileprivate var newsTopics = [WeiTouTiao]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        /// 我的 我的界面 cell 数据
//        NetworkTool.loadMineCellData { (sectionArray) in
//            let dict = ["text": "我的关注", "grey_text": ""]
//            let myConcern = MineCellModel(dict: dict as [String : AnyObject])
//            var myConcerns = [MineCellModel]()
//            myConcerns.append(myConcern)
//            self.sections.append(myConcerns as AnyObject)
//            self.sections += sectionArray
//            self.tableView.reloadData()
//            NetworkTool.loadMyFollow { (concerns) in
//                self.concerns = concerns
//                if concerns.count != 0 {
//                    let indexSet = IndexSet(integer: 0)
//                    self.tableView.reloadSections(indexSet, with: .automatic)
//                }
//            }
//        }
        if self.topicTitle!.category == "subscription" { // 头条号
//            tableView.tableHeaderView = toutiaohaoHeaderView
        }
        NetworkTool.loadHomeCategoryNewsFeed(category: topicTitle!.category!) { (nowTime, newsTopics) in
            self.newsTopics = newsTopics
            self.tableView.reloadData()
        }
        
        
    }
    
//    extension MineViewController: NoLoginHeaderViewDelegate {
//        /// 更多登录方式按钮点击
//        func noLoginHeaderViewMoreLoginButotnClicked() {
////            let storyboard = UIStoryboard(name: "MoreLoginViewController", bundle: nil)
////            let moreLoginVC = storyboard.instantiateViewController(withIdentifier: "MoreLoginViewController") as! MoreLoginViewController
////            moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - 40)))
////            present(moreLoginVC, animated: true, completion: nil)
//        }
//    }

//    // 头部视图
//    fileprivate lazy var noLoginHeaderView: NoLoginHeaderView = {
//        let noLoginHeaderView = NoLoginHeaderView.headerView()
//        noLoginHeaderView.delegate = self
//        noLoginHeaderView.pictureGallery()
//        return noLoginHeaderView
//    }()
}



extension MineViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.globalBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = true
//        tableView.tableHeaderView = NoLoginHeaderView
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(r: 240, g: 240, b: 240)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MineFirstSectionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MineFirstSectionCell.self))
        tableView.register(UINib(nibName: String(describing: MineOtherCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MineOtherCell.self))
    }
    
}

// MARK: - // MARK: - Table view data source
extension MineViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if topicTitle!.category == "video" {
            return screenHeight * 0.4
        } else if topicTitle!.category == "subscription" { // 头条号
            return 68
        }
        let weitoutiao = newsTopics[indexPath.row]
        return weitoutiao.homeCellHeight!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 1 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        view.backgroundColor = UIColor.globalBackgroundColor()
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(String(describing: HomeTopicCell.self), owner: nil, options: nil)?.last as! HomeTopicCell
        cell.weitoutiao = newsTopics[indexPath.row]
        
        return cell
        
    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let myConcernVC = MyConcernController()
            myConcernVC.myConcerns = concerns
            navigationController?.pushViewController(myConcernVC, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelagate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y;
//        if offsetY < 0 {
//            let totalOffset = kMineHeaderViewHieght + abs(offsetY)
//            let f = totalOffset / kMineHeaderViewHieght
////            noLoginHeaderView.bgImageView.frame = CGRect(x: -screenWidth * (f - 1) * 0.5, y: offsetY, width: screenWidth * f, height: totalOffset)
////            
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MineViewController: MineFirstSectionCellDelegate {
    /// 点击了 第一个 cell 的标题
    func mineFirstSectionCellTitleButtonClicked() {
        let myConcernVC = MyConcernController()
        myConcernVC.myConcerns = concerns
        navigationController?.pushViewController(myConcernVC, animated: true)
    }
    /// 点击了第几个关注
    func mineFirstSectionCellDidSelected(myConcern: MyConcern) {
        let followDetail = FollowDetailViewController()
        followDetail.userid = myConcern.userid ?? 0
        navigationController?.pushViewController(followDetail, animated: true)
    }
}
