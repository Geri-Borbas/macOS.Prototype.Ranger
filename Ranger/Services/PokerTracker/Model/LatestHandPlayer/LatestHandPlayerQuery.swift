//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension PokerTracker
{
    
        
    struct LatestHandPlayerQuery: Query
    {
        
        
        typealias EntryType = HandPlayer
        
        
        let tourneyNumber: String
        let handOffset: Int
        var string: String
        {
            // Load query file.
            let queryFilePath = Bundle.main.path(forResource: "LatestHandPlayerQuery", ofType: "sql")
            guard let queryTemplateString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
            else { return "" }
            
            // Inject parameter.
            let queryString = queryTemplateString
                .replacingOccurrences(
                    of: "$_TOURNEY_NUMBER",
                    with: tourneyNumber)
                .replacingOccurrences(
                    of: "$_OFFSET",
                    with: String(handOffset)
            )
            
            return queryString
        }
        
        
        init(tourneyNumber: String, handOffset: Int = 0)
        {
            self.tourneyNumber = tourneyNumber
            self.handOffset = handOffset
        }
    }
}
