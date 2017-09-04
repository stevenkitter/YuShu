//
//  RefreshHeader.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import MJRefresh
import NVActivityIndicatorView
class RefreshHeader: MJRefreshHeader {
    let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: KNaviColor, padding: nil)
    
    override func prepare() {
        super.prepare()
        self.mj_h = 60
        self.addSubview(activityView)
    }
    override func placeSubviews() {
        super.placeSubviews()
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
                self.activityView.stopAnimating()
            case .pulling:
                self.activityView.stopAnimating()
            case .refreshing:
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
