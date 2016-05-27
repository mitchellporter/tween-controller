//
//  TweenDescriptor.swift
//  TweenController
//
//  Created by Dalton Claybrook on 5/9/16.
//  Copyright © 2016 Claybrook Software. All rights reserved.
//

public protocol TweenIntervalType {
    var interval: HalfOpenInterval<Double> { get }
    var isIntervalClosed: Bool { get set }
    func containsProgress(progress: Double) -> Bool
    func handleProgressUpdate(progress: Double)
}

extension TweenIntervalType {
    public func containsProgress(progress: Double) -> Bool {
        if isIntervalClosed {
            return (interval.start...interval.end).contains(progress)
        } else {
            return interval.contains(progress)
        }
    }
}

public class TweenDescriptor<T:Tweenable>: TweenIntervalType {
    
    public let fromValue: T
    public let toValue: T
    public let interval: HalfOpenInterval<Double>
    public var isIntervalClosed: Bool = false
    public var updateBlock: ((T) -> ())?
    
    init(fromValue: T, toValue: T, interval: HalfOpenInterval<Double>) {
        self.fromValue = fromValue
        self.toValue = toValue
        self.interval = interval
    }
    
    public func handleProgressUpdate(progress: Double) {
        guard let block = updateBlock where containsProgress(progress) else { return }
        let percent = percentFromProgress(progress)
        block(T.valueBetween(fromValue, toValue, percent: percent))
    }
    
    //MARK: Private
    
    private func percentFromProgress(progress: Double) -> Double {
        return (progress - interval.start) / (interval.end - interval.start)
    }
}
