//
//  RefreshFooter.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import MJRefresh
class RefreshFooter: MJRefreshAutoFooter {
    let label = UILabel().then {
        $0.textColor = UIColor.darkGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
        $0.hidesWhenStopped = true
    }
    override func prepare() {
        
        super.prepare()
        self.mj_h = 60;
        self.addSubview(self.label)
        self.addSubview(self.activityView)
    }
    override func placeSubviews() {
        super.placeSubviews()
        label.frame = self.bounds
        activityView.center = CGPoint(x: self.mj_w * 0.5, y: self.mj_h * 0.5)

    }
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }

    override var state: MJRefreshState {
        set {
            let oldState = state
            if newValue == oldState {
                return
            }
            super.state = newValue
            switch newValue {
            case .idle:
                label.text = "-- 更多 --"
                self.activityView.stopAnimating()
            case .noMoreData:
                label.text = "-- 结束 --"
                self.activityView.stopAnimating()
            case .refreshing:
                label.text = ""
                self.activityView.startAnimating()
            default:
                break
            }
        }
        get {
            return super.state
        }
    }

}
