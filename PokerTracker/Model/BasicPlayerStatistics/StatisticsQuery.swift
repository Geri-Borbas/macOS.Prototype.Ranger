//
//  BasicPlayerStatisticsQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation

 
public struct StatisticsQuery: Query
{
    
    
    public typealias EntryType = Statistics
    
    
    let playerIDs: [Int]
    let tourneyNumber: String?
    
    public var string: String
    {
        // Load query file.
        let queryFilePath = Bundle(identifier: "com.eppz.PokerTracker")?.path(forResource: "StatisticsQuery", ofType: "sql")
        guard let path = queryFilePath, let queryTemplateString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
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
    
    
    public init(playerIDs: [Int], tourneyNumber: String? = nil)
    {
        self.playerIDs = playerIDs
        self.tourneyNumber = tourneyNumber
    }
}
