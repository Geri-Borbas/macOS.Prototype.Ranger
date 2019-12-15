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
    
    
    let playerIDs: [Int]
    var string: String
    {
        let queryFilePath = Bundle.main.path(forResource: "BasicPlayerStatisticsQuery", ofType: "sql")
        guard let queryTemplateString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
        else { return "" }
        
        let stringPlayerIDs = playerIDs.map{ eachPlayerID in String(eachPlayerID) }
        let joinedPlayerIDs = stringPlayerIDs.joined(separator: ",")
        let whereCondition = "player.id_player IN(\(joinedPlayerIDs))"
        let queryString = queryTemplateString.replacingOccurrences(of: "$WHERE_CONDITION", with: whereCondition)
        
        return queryString
    }
    
    
    init(playerIDs: [Int])
    {
        self.playerIDs = playerIDs
    }
}
