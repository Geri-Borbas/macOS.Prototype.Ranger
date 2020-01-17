//
//  TrendLine.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 05..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


struct LinearRegression
{
    
    
    let slope: Double
    let offset: Double
    let max: Double
    
    
    init(x: [Double], y: [Double])
    {
        let sum1 = Self.average(Self.multiply(x, y)) - Self.average(x) * Self.average(y)
        let sum2 = Self.average(Self.multiply(x, x)) - pow(Self.average(x), 2)
        self.slope = sum1 / sum2
        self.offset = Self.average(y) - slope * Self.average(x)
        self.max = y.max() ?? 0
    }
    
    static func average(_ values: [Double]) -> Double
    { return values.reduce(0, +) / Double(values.count) }

    static func multiply(_ x: [Double], _ y: [Double]) -> [Double]
    { return zip(x, y).map(*) }
}
