//
//  FZURefreshFoot.swift
//  FZURefresh
//
//  Created by 吴浩文 on 15/8/2.
//  Copyright (c) 2015年 吴浩文. All rights reserved.
//

import UIKit

public class FZURefreshFoot: UIView {
    
    var scrollView:UIScrollView
    var loadMoreAction: (() -> Void)
    var isEndLoadMore = false
    
    enum RefreshStatus{
        case Normal, LoadMore, End
    }
    
    var refreshStatus:RefreshStatus = .Normal
    
    var originInset: UIEdgeInsets
    
    var activityView: UIActivityIndicatorView
    
    
    init(action: (() -> ()), scrollView:UIScrollView){
        self.loadMoreAction = action
        self.scrollView = scrollView
        refreshStatus = .Normal
        self.originInset = scrollView.contentInset
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        super.init(frame: CGRectZero)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        activityView.frame = CGRect(origin: CGPoint(x: (scrollView.frame.size.width-activityView.frame.size.width)/2.0, y: kFZURefreshFootViewHeight/2.0), size: activityView.frame.size)
        self.addSubview(activityView)
    }
    
    required public init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        let contentHeight = self.scrollView.contentSize.height
        let scrollHeight = self.scrollView.frame.size.height  - self.originInset.top - self.originInset.bottom
        var rect:CGRect = self.frame;
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        
        let y = scrollView.contentOffset.y
        
        if keyPath == "contentSize" {
            willMoveToSuperview(nil)
        } else if keyPath == "contentOffset" {
            if y > 0 {
                let nowContentOffsetY:CGFloat = y + self.scrollView.frame.size.height
                
                if (nowContentOffsetY - scrollView.contentSize.height) > 0 && scrollView.contentOffset.y != 0 {
                    
                    if isEndLoadMore == false && refreshStatus == .Normal {
                        refreshStatus = .LoadMore
                        loadMoreAction()
                        
                        activityView.startAnimating()
                        UIView.animateWithDuration(0.25) {
                            self.scrollView.contentInset = UIEdgeInsetsMake(self.originInset.top, 0, kFZURefreshFootViewHeight, 0)
                        }
                    }
                }
            }
        }
    }
    
    func getViewControllerWithView(vcView:UIView) -> AnyObject {
        if( (vcView.nextResponder()?.isKindOfClass(UIViewController) ) == true){
            return vcView.nextResponder() as! UIViewController
        }
        
        if(vcView.superview == nil){
            return vcView
        }
        return self.getViewControllerWithView(vcView.superview!)
    }
    
    deinit {
        let scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentSize", context: &KVOContext)
    }
}