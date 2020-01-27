//
//  ColorRanges.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 25..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import Cocoa


struct ColorRanges: Decodable
{
    
    
    let colorRanges: [ColorRange]
    
    
    struct ColorRange: Decodable
    {
        
        
        let min: Double?
        let max: Double?
        let color: String
        
        var minimum: Double { min ?? -Double.infinity }
        var maximum: Double { max ?? +Double.infinity }
    }
    
    
    init?(named jsonFileName: String)
    {
        // Try to load / decode JSON.
        guard
            let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
            let data = Optional(try! Data(contentsOf: url)),
            let decoded = Optional(try! JSONDecoder().decode(ColorRanges.self, from: data))
        else { return nil }
        
        // Set.
        self = decoded
    }
}


extension ColorRanges
{
    
    
    static var M: ColorRanges = ColorRanges(named: "M.ColorRanges")!
    static var VPIP: ColorRanges = ColorRanges(named: "VPIP.ColorRanges")!
    static var PFR: ColorRanges = ColorRanges(named: "PFR.ColorRanges")!
    static var finishes: ColorRanges = ColorRanges(named: "Finishes.ColorRanges")!
}


extension ColorRanges
{
    
    
    func colorName(for value: Double) -> String
    {
        colorRanges.reduce(
            "black",
            {
                color, eachColorRange in
                (eachColorRange.minimum <= value && value < eachColorRange.maximum) ? eachColorRange.color : color
            }
        )
    }
    
    func color(for value: Double) -> NSColor
    { NSColor(named: colorName(for: value)) ?? NSColor.black }
}
