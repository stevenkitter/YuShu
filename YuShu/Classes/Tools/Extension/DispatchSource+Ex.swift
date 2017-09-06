//
//  DispatchSource+Ex.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/6.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
public extension DispatchSource {
    public class func timer(interval: DispatchTimeInterval, queue: DispatchQueue, handler: @escaping () -> Void) -> DispatchSourceTimer {
        let source = DispatchSource.makeTimerSource(queue: queue)
        source.setEventHandler(handler: handler)
        source.scheduleRepeating(deadline: .now(), interval: interval, leeway: .nanoseconds(0))
        source.resume()
        return source
    }
}
