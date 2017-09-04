//
//  WXActivityIndicatorView.swift
//  InternManager
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import NVActivityIndicatorView

class WXActivityIndicatorView {
    static let activityData = ActivityData(size: CGSize(width: 40, height: 40), message: nil, messageFont: nil, type: .ballPulse, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
    static func start() {
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    static func stop() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}
