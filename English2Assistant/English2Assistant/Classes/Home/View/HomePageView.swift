//
//  HomePageView.swift
//  TodayNews
//
//  Created by 杨蒙 on 2017/7/5.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

protocol HomePageViewDelegate : class {
    func pageView(_ pageView : HomePageView, targetIndex : Int)
}

class HomePageView: UIView {

    weak var homePageDelegate: HomePageViewDelegate?
    
    fileprivate var oldIndex: Int = 0
    fileprivate var currentIndex: Int = 0
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScroll: Bool = false
    
    var titles: [TopicTitle]? {
        didSet {
//            titleView.titles = titles
        }
    }
    
    var childVcs: [TopicViewController]? {
        didSet {
            let vc = childVcs![currentIndex]
            vc.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
            scrollView.addSubview(vc.view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
        
    fileprivate lazy var titleView: HomeTitleView = {
        let titleView = HomeTitleView()
        titleView.delegate = self
        return titleView
    }()
        
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomePageView {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(titleView)
        addSubview(scrollView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0)
            make.bottom.equalTo(scrollView.snp.top)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension HomePageView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 取出子控制器
        let vc = childVcs![index]
        vc.view.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.addSubview(vc.view)
    }
    
    // scrollView 刚开始滑动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 记录刚开始拖拽是的 index
        oldIndex = index
    }
    
    // scrollView 结束滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 与刚开始拖拽时的 index 进行比较
        // 检查是否需要改变 label 的位置
        homePageDelegate?.pageView(self, targetIndex: index)
    }
}


// MARK:- 遵守HYTitleViewDelegate
extension HomePageView : HomeTitleViewDelegate {
    func titleView(_ titleView: HomeTitleView, targetIndex: Int) {
        currentIndex = targetIndex
        let offset = CGPoint(x: screenWidth * CGFloat(targetIndex), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}
