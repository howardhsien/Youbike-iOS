//
//  FZURefreshHead.swift
//  FZURefresh
//
//  Created by 吴浩文 on 15/8/2.
//  Copyright (c) 2015年 吴浩文. All rights reserved.
//

import UIKit

var KVOContext = ""
let imageViewW: CGFloat = 113
let labelTextW: CGFloat = 150

public class FZURefreshHead: UIView {
    var action: (() -> ())
    var scrollView: UIScrollView
    var headImageView: UIImageView
    var originTop: CGFloat
    
    init(action :(() -> ()), frame: CGRect, scrollView:UIScrollView) {
        self.action = action
        self.scrollView = scrollView
        self.headImageView = UIImageView(frame: CGRectMake((frame.size.width - imageViewW) / 2, -scrollView.frame.origin.y, imageViewW, frame.size.height))
        self.headImageView.contentMode = .Center
        self.originTop = scrollView.contentInset.top
        super.init(frame: frame)
        self.addSubview(headImageView)
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .Initial, context: &KVOContext)
    }
    
    required public init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    var imgName:String {
        set {
            if(Int(newValue)<15) {
                self.headImageView.image = UIImage(named: "FZURefresh-1")
            } else if Int(newValue)>60+15 {
                self.headImageView.image = UIImage(named: "FZURefresh-60")
            } else {
                self.headImageView.image = UIImage(named: "FZURefresh-\(Int(newValue)!-15)")
            }
        }
        get {return self.imgName}
    }
    
    func stopAnimation()
    {
        UIView.animateWithDuration(0.25) {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originTop, 0, 0, 0)
        }
        self.headImageView.stopAnimating()
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        let y = self.scrollView.contentOffset.y
        let top = self.scrollView.contentInset.top
        
        //print(y, top)
        
        if y <= -kFZURefreshHeadViewHeight - top + 10 && scrollView.dragging == false && self.headImageView.isAnimating() == false {
            start()
        }
        
        if (y <= 0) {
            self.imgName = "\((Int)(abs(y+top)))"
        }
    }
    
    func start() {
        var results = [UIImage]()
        for i in 1...60{
            if let image = UIImage(named: "FZURefresh-\(i)") {
                results.append(image)
            }
        }
        self.headImageView.animationImages = results
        self.headImageView.animationDuration = 1.5
        
        self.headImageView.startAnimating()
        UIView.animateWithDuration(0.25) {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originTop + kFZURefreshHeadViewHeight, 0, 0, 0)
            self.scrollView.contentOffset = CGPoint(x: 0, y: -self.originTop - kFZURefreshHeadViewHeight)
        }
        self.action()
    }
    
    deinit {
        let scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
    }
}
