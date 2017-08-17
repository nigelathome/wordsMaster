//
//  NoLoginView.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 2017/6/13.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit

protocol NoLoginHeaderViewDelegate: class {
    /// 更多登录方式按钮点击
    func noLoginHeaderViewMoreLoginButotnClicked()
    
}

class NoLoginHeaderView: UIView, UIScrollViewDelegate {
    
    weak var delegate: NoLoginHeaderViewDelegate?
    @IBOutlet weak var galleryScrollView: UIScrollView!    // 实现图片轮播的滚动；
    @IBOutlet weak var galleryPageControl: UIPageControl!  // 提示当前滚动的图片，指示器；
    var timer:Timer!
    @IBOutlet weak var picTitle: UILabel!
    @IBOutlet weak var picNum: UILabel!
    
    @IBOutlet weak var comments: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.height = screenHeight * 0.4
    }
    
    class func headerView() -> NoLoginHeaderView {
        let headerView = Bundle.main.loadNibNamed(String(describing: self), owner: nil
            , options: nil)?.last as! NoLoginHeaderView
        return headerView
    }
    
    func pictureGallery(){   //实现图片滚动播放；
        //image width
        let imageW:CGFloat = self.galleryScrollView.frame.size.width;//获取ScrollView的宽作为图片的宽；
        let imageH:CGFloat = self.galleryScrollView.frame.size.height;//获取ScrollView的高作为图片的高；
        let imageY:CGFloat = 0;//图片的Y坐标就在ScrollView的顶端；
        let totalCount:NSInteger = 3;//轮播的图片数量；
        self.galleryPageControl!.numberOfPages = totalCount;
        self.galleryPageControl?.currentPage = 0;
        self.galleryPageControl?.defersCurrentPageDisplay = false
        self.addSubview(self.galleryPageControl!)
        for index in 0..<totalCount {
            let imageView:UIImageView = UIImageView();
            let imageX:CGFloat = CGFloat(index) * imageW;
            imageView.frame = CGRect(x:imageX, y:imageY, width:imageW, height:imageH);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            let name:String = String(format: "galary%d", index+1);
            imageView.image = UIImage(named: name);
            self.galleryScrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.galleryScrollView.addSubview(imageView)//把图片加入到ScrollView中去，实现轮播的效果；
            
            let picName:UILabel = UILabel()
            picName.frame = self.picTitle.frame
            picName.lineBreakMode = NSLineBreakMode.byWordWrapping
            picName.numberOfLines = 0
            picName.text = String(format: "他装修新房入住后 邻居：对面才是你家展示图片%d", index+1)
            picName.textColor = UIColor.white
            imageView.addSubview(picName)
        }
        
        let picNumValue:NSInteger = 3
        self.picNum.text = String(format: "%d 图", picNumValue);
        self.addSubview(self.picNum)
        
        let commentNumValue:NSInteger = 4105
        self.comments.text = String(format: "%d 评", commentNumValue);
        self.addSubview(self.comments)
 
        
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(totalCount);//这里的宽度就是所有的图片宽度之和；
        self.galleryScrollView.contentSize = CGSize(width:contentW, height:0);
        self.galleryScrollView.isPagingEnabled = true;
        self.galleryScrollView.delegate = self;
        self.addTimer()
    }
    
    //开启定时器
    func addTimer(){
        self.timer = Timer.scheduledTimer(timeInterval:2, target:self, selector:#selector(nextImage), userInfo:nil, repeats:true)
    }
    
    //关闭定时器
    func removeTimer(){
        self.timer.invalidate()
    }
    
    func nextImage(sender:AnyObject){//图片轮播；
        if self.galleryPageControl?.currentPage == self.galleryPageControl!.numberOfPages-1 {
            self.galleryPageControl?.currentPage = 0
        } else { //        依次往后滚动视图
            self.galleryPageControl?.currentPage += 1
        }

        // 设置图片显示
        let page : CGFloat = (CGFloat)((self.galleryPageControl?.currentPage)!)
        let xPoint = page * (self.galleryScrollView?.frame.width)!
        self.galleryScrollView?.contentOffset = CGPoint(x:xPoint, y:0);
    }
    
    //UIScrollViewDelegate中重写的方法；
    //处理所有ScrollView的滚动之后的事件，注意 不是执行滚动的事件；
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
