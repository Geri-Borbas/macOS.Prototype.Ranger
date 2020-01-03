//
//  Parameters.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 03..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class LayoutParameters: NSObject
{
    
    
    @objc dynamic var multiplier: NSNumber = 1.0 // 1
    @objc dynamic var minimum: NSNumber = 0.0 // 0
    @objc dynamic var maximum: NSNumber = 1.0 // 1500
    
    
    func adjusted(value: Float) -> Float
    {
        // Only if adjustments any.
        if (
            multiplier == 1.0 &&
            minimum == 0.0 &&
            maximum == 1.0
            )
        { return value }
        
        // 1100
        let multipliedValue = (value * multiplier.floatValue) // 1100
        let size = maximum.floatValue - minimum.floatValue // 1500
        let offsetMultipliedValue = max(multipliedValue - minimum.floatValue, 0.0) // 1100
        let adjustedValue = offsetMultipliedValue / size // 1100 / 1500
        let cappedValue = min(adjustedValue, 1.0) // 0.7333333333
        
//        print("value: \(value)")
//        print("multipliedValue: \(multipliedValue)")
//        print("size: \(size)")
//        print("offsetMultipliedValue: \(offsetMultipliedValue)")
//        print("adjustedValue: \(adjustedValue)")
//        print("cappedValue =: \(cappedValue)")
        
        return cappedValue // 0.25
    }
}
