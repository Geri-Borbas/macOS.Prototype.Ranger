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
    
    
    struct DataPoint: Decodable, Equatable
    {
        
        
        let x: Double
        let y: Double
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
            return
        }
        
        // Map data points if any.
        self.id = statisticalDataSet.id
        if let data: [Statistics.StatisticalDataSet.Data] = statisticalDataSet.Data
        {
            self.dataPoints = data.map
            {
                eachData in
                DataPoint(
                    x: Double(eachData.x) ?? 0.0,
                    y: Double(eachData.Y.first?.value ?? "0.0") ?? 0.0
                )
            }
        }
        else
        { self.dataPoints = [] }
    }
}
