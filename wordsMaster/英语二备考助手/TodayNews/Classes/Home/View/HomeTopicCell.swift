//
//  HomeTopicCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 2017/7/2.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

protocol HomeTopicCellDelegate: class {
    /// 用户头像区域点击
    func videoheadTopicCellButtonClick(videoTopic: WeiTouTiao)
}

class HomeTopicCell: UITableViewCell {
    
    weak var delegate: HomeTopicCellDelegate?
    /// 新闻标题
    @IBOutlet weak var newsTitleLabel: UILabel!
    /// 置顶 / 热
    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var hotLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var hotLabelLeading: NSLayoutConstraint!
    /// 专题
    @IBOutlet weak var specicalLabel: UILabel!
    @IBOutlet weak var specicalLabelLeading: NSLayoutConstraint!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 评论
    @IBOutlet weak var commentLabel: UILabel!
    /// 发布时间
    @IBOutlet weak var createTimeLabel: UILabel!
    /// 发布时间
    @IBOutlet weak var middleView: UIImageView!
    /// 右侧按钮图片
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightButtonWidth: NSLayoutConstraint!
    
    var weitoutiao: WeiTouTiao? {
        didSet {
            guard (weitoutiao!.has_image != nil
                || weitoutiao!.large_image_list.count >= 0
                || weitoutiao!.image_list.count == 1) else {
                return
            }
            
            if let title = weitoutiao!.title {
                newsTitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                newsTitleLabel.numberOfLines = 0
                newsTitleLabel.text = String(title)
            }
            if let hot_label = weitoutiao!.label {
                if hot_label == "置顶" {
                    hotLabel.isHidden = false
                    hotLabel.text = hot_label
                } else {
                    hotLabel.isHidden = true
                }
            }
            if weitoutiao!.image_list.count != 0 {
                middleView.kf.setImage(with: URL(string: (weitoutiao?.image_list[0].url)!))
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotLabel.layer.borderColor = UIColor(r: 212, g: 61, b: 61).cgColor
        hotLabel.layer.borderWidth = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension HomeTopicCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ThumbCollectionViewCell.self), for: indexPath) as! ThumbCollectionViewCell
        if indexPath.item == 0 {
            let thumbImage = weitoutiao!.image_list[0]
            cell.thumbImageURL = (thumbImage.url)!
        } else {
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageW = (screenWidth - 2 * kMargin - 2 * 6) / 3
        let imageH = imageW * 0.8
        return CGSize(width: imageW, height: imageH)
    }
    
    
}



