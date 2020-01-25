//
//  Parameters.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 03..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class ColorRangeProvider: NSObject
{
    
    
    @objc dynamic var JSON: String?
    
    @objc dynamic var value_1: NSNumber = 0.0
    @objc dynamic var color_1: NSColor = NSColor.red
    
    @objc dynamic var value_2: NSNumber = 0.0
    @objc dynamic var color_2: NSColor = NSColor.orange
    
    @objc dynamic var value_3: NSNumber = 0.0
    @objc dynamic var color_3: NSColor = NSColor.yellow
    
    @objc dynamic var value_4: NSNumber = 0.0
    @objc dynamic var color_4: NSColor = NSColor.green
        
    
    func color(for value: Float) -> NSColor
    {
        if let JSON = JSON
        {
            switch JSON
            {
                case "Finishes.ColorRanges":
                    return ColorRanges.finishes.color(for: Double(value))
                default:
                    print("\(JSON).json not found.")
            }
        }
        
        if (value > value_4.floatValue)
        { return color_4 }
        
        if (value > value_3.floatValue)
        { return color_3 }
        
        if (value > value_2.floatValue)
        { return color_2 }
        
        if (value > value_1.floatValue)
        { return color_1 }
        
        return color_1
    }
}
