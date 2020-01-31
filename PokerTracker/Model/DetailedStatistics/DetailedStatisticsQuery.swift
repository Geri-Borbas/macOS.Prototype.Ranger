//
//  BasicPlayerStatisticsQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import Cocoa

 
public struct DetailedStatisticsQuery: Query
{
    
    
    public typealias EntryType = DetailedStatistics
    
    
    let playerNames: [String]
    let tourneyNumber: String?
    
    public var string: String
    {
        // Load query file.
        let queryFilePath = Bundle(identifier: "com.eppz.PokerTracker")?.path(forResource: "DetailedStatisticsQuery", ofType: "sql")
        guard let path = queryFilePath, let queryTemplateString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        else { return "" }
        
        // Inject player names
        let joinedPlayerNames = playerNames.joined(separator: "', '")
        let whereCondition = "player.player_name IN('\(joinedPlayerNames)')"
        var queryString = queryTemplateString.replacingOccurrences(of: "$_WHERE_CONDITION", with: whereCondition)
        
        // Inject tourney number if any.
        queryString = queryString
            .replacingOccurrences(
                of: "$_TOURNEY_NUMBER",
                with: tourneyNumber ?? "%"
            )
        
        // Debug.
        if (playerNames == ["Borbas.Geri"])
        {
            NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            NSPasteboard.general.setString(queryString, forType: NSPasteboard.PasteboardType.string)
        }
        
        return queryString
    }
    
    
    public init(playerNames: [String], tourneyNumber: String? = nil)
    {
        self.playerNames = playerNames
        self.tourneyNumber = tourneyNumber
    }
}
