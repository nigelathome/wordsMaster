//
//  HomeViewController.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 17/2/7.
//  Copyright © 2017年 hrscy. All rights reserved.
//
// 1.首页 控制器

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置导航栏颜色
//        navigationController?.navigationBar.barTintColor = UIColor.globalRedColor()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.globalBackgroundColor()
        // 设置导航栏属性
//        navigationController?.navigationBar.barStyle = .black
      
        automaticallyAdjustsScrollViewInsets = true
        /// 获取标题数据
        NetworkTool.loadHomeTitlesData(fromViewController: String(describing: HomeViewController.self)) { (topTitles, homeTopicVCs) in
            // 将所有子控制器添加到父控制器中
            for childVc in homeTopicVCs {
                self.addChildViewController(childVc)
            }
            self.setupUI()
            
//            self.pageView.titles = topTitles
            self.pageView.childVcs = self.childViewControllers as? [TopicViewController]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate lazy var pageView: HomePageView = {
        let pageView = HomePageView()
        return pageView
    }()
    
}

extension HomeViewController {
    
    fileprivate func setupUI() {
        
        view.addSubview(pageView)
        
        pageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(view).offset(0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    /// UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationController?.pushViewController(HomeSearchViewController(), animated: false)
        return true
    }
}
