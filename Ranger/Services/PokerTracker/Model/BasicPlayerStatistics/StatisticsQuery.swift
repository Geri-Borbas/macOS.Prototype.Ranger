//
//  BasicPlayerStatisticsQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension PokerTracker
{
    
        
    struct StatisticsQuery: Query
    {
        
        
        typealias EntryType = Statistics
        
        
        let playerIDs: [Int]
        let tourneyNumber: String?
        var string: String
        {
            // Load query file.
            let queryFilePath = Bundle.main.path(forResource: "StatisticsQuery", ofType: "sql")
            guard let queryTemplateString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
            else { return "" }
            
            // Inject player ids.
            let stringPlayerIDs = playerIDs.map{ eachPlayerID in String(eachPlayerID) }
            let joinedPlayerIDs = stringPlayerIDs.joined(separator: ",")
            let whereCondition = "player.id_player IN(\(joinedPlayerIDs))"
            var queryString = queryTemplateString.replacingOccurrences(of: "$_WHERE_CONDITION", with: whereCondition)
            
            // Inject tourney number if any.
            queryString = queryString
                .replacingOccurrences(
                    of: "$_TOURNEY_NUMBER",
                    with: tourneyNumber ?? "%"
                )
            
            return queryString
        }
        
        
        init(playerIDs: [Int], tourneyNumber: String? = nil)
        {
            self.playerIDs = playerIDs
            self.tourneyNumber = tourneyNumber
        }
    }
}
