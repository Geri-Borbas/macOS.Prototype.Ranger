//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct BasicPlayerStatisticsQuery: Query
{
    
    
    typealias EntryType = BasicPlayerStatistics
    
    
    var string: String
    {
        let queryFilePath = Bundle.main.path(forResource: "BasicPlayerStatisticsQuery", ofType: "sql")
        guard let queryString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
        else { return "" }
        return queryString
    }
}
