//
//  RoundView.swift
//  SwiftRoundView
//
//  Created by Pengfei_Luo on 15/12/22.
//  Copyright © 2015年 骆朋飞. All rights reserved.
//

 /// swift 轮播图：无限滚动 + 定时

import UIKit
import SDWebImage
protocol RoundViewDelegate {
    func roundViewDidSelectedAtIndex(index : NSInteger)
}


private let cellIdentifier = "cellIdentifier"
class RoundView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    
    var imageList : [String]!
    private lazy var collection : UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = self.frame.size
        
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.pagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        return collectionView
        
    }()
    
    lazy var pageControl : UIPageControl! = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.imageList.count
        pageControl.frame = CGRectMake(0,self.frame.size.height - 5,self.frame.size.width,10)
        return pageControl
    }()
    
    init(frame: CGRect,imageList : [String]) {
        super.init(frame: frame)
        self.imageList = imageList
        self.addSubview(collection)
        self.insertSubview(self.pageControl, aboveSubview: self.collection)
        initTimer()
    }
    
    var currentIndex : NSInteger!
    var timer : NSTimer!
    var dataCurrentIndex = 0
    
    var didSelectedRoundViewBlock:((NSInteger) -> Void)!
    
    var delegate : RoundViewDelegate?
  
}

extension RoundView {
    func initTimer() {
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RoundView.timerAction), userInfo: nil, repeats: true)
        }
    }
    //销毁定时器
    func invalidateTimer() {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }
    
    func timerAction() {
        let indexPath = NSIndexPath(forItem: 2, inSection: 0)
        self.collection.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func scrollViewCollectionAnimation(scrollView : UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let offsetWidth = scrollView.bounds.size.width
        let offset = offsetX / offsetWidth - 1
        if offset != 0 {
            dataCurrentIndex = (Int(offset) + dataCurrentIndex + imageList.count) + imageList.count
            let indexPath = NSIndexPath(forItem: 1, inSection: 0)
            self.collection.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
            
            UIView.setAnimationsEnabled(false)
            self.collection.reloadItemsAtIndexPaths([indexPath])
            UIView.setAnimationsEnabled(true)
            
            self.pageControl.currentPage = currentIndex;
        }
    }
    
}

extension RoundView : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
// MARK: - 选中cell
        if let block = didSelectedRoundViewBlock {
            block(currentIndex)
        }
        
       
        if delegate != nil {
            delegate?.roundViewDidSelectedAtIndex(currentIndex)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        initTimer()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewCollectionAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollViewCollectionAnimation(scrollView)
    }
    
}
//延展 给已有的类增加方法，也可以遵守协议
extension RoundView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let index = (indexPath.item - 1 + self.imageList.count + dataCurrentIndex) % self.imageList.count
        currentIndex = index;
        let imageView = UIImageView(frame: bounds)
        imageView.sd_setImageWithURL(NSURL(string: self.imageList[index]), placeholderImage: UIImage(named: "1"))
        cell.contentView.addSubview(imageView)
        cell.contentMode = UIViewContentMode.ScaleAspectFill
        return cell
        
    }
    
    
}
