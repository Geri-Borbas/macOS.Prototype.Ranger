//
//  GraphData.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 04..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


struct GraphData: Decodable, Equatable
{
            
    
    let id: String
    let dataPoints: [DataPoint]
    let trendLine: TrendLine
    
    
    struct DataPoint: Decodable, Equatable
    {
        
        
        let x: Double
        let y: Double
    }
    
    
    struct TrendLine: Decodable, Equatable
    {
        
        
        let slope: Double
        let offset: Double
        let max: Double
    }
    
    
    init(from statisticalDataSet: Statistics.StatisticalDataSet?)
    {
        // Only if any.
        guard let statisticalDataSet = statisticalDataSet
        else
        {
            // Initialize empty if none.
            self.id = ""
            self.dataPoints = []
            self.trendLine = TrendLine(slope: 0, offset: 0, max: 0)
            return
        }
        
        // Map data points if any.
        self.id = statisticalDataSet.id
        if let data: [Statistics.StatisticalDataSet.Data] = statisticalDataSet.Data
        {
            self.dataPoints = data.enumerated().map
            {
                (arguments) -> GraphData.DataPoint in
                let (eachIndex, eachData) = arguments
                
                return DataPoint(
                    x: Double(eachIndex), // Double(eachData.x) ?? 0.0,
                    y: Double(eachData.Y.first?.value ?? "0.0") ?? 0.0
                )
            }
        }
        else
        { self.dataPoints = [] }
        
        // Trendline.
        let linearRegression = LinearRegression(x: dataPoints.map{$0.x}, y: dataPoints.map{$0.y})
        self.trendLine = TrendLine(slope: linearRegression.slope, offset: linearRegression.offset, max: linearRegression.max)
    }
}
