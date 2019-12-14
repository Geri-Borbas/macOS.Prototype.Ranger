//
//  BasicPlayerStatisticsCollection.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class BasicPlayerStatisticsCollection: Collection
{
    
    
    typealias RowType = BasicPlayerStatistics
    var rows: [BasicPlayerStatistics]
    
    var queryString: String
    {
        let queryFilePath = Bundle.main.path(forResource: "BasicPlayerStatisticsQuery", ofType: "sql")
        guard let queryString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
        else { return "" }
        return queryString
    }
    
    
    init()
    { rows = [] }
}
