//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation

        
public struct TourneyHandSummaryQuery: Query
{
    
    
    public typealias EntryType = TourneyHandSummary
    
    
    let tourneyNumber: String
    
    public var string: String
    {
        // Load query file.
        let queryFilePath = Bundle(identifier: "com.eppz.PokerTracker")?.path(forResource: "TourneyHandSummaryQuery", ofType: "sql")
        guard let path = queryFilePath, let queryTemplateString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        else { return "" }
        
        // Inject parameter.
        let queryString = queryTemplateString
            .replacingOccurrences(
                of: "$_TOURNEY_NUMBER",
                with: tourneyNumber
        )
        
        return queryString
    }
    
    
    public init(tourneyNumber: String)
    {
        self.tourneyNumber = tourneyNumber
    }
}
