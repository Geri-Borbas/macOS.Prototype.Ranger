//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct TourneyTablePlayerQuery: Query
{
    
    
    typealias EntryType = TourneyTablePlayer
    
    
    let tourneyNumber: String
    var string: String
    {
        // Load query file.
        let queryFilePath = Bundle.main.path(forResource: "TourneyTablePlayer", ofType: "sql")
        guard let queryTemplateString = try? String(contentsOfFile: queryFilePath!, encoding: String.Encoding.utf8)
        else { return "" }
        
        // Inject parameter.
        let queryString = queryTemplateString.replacingOccurrences(of: "$_TOURNEY_NUMBER", with: tourneyNumber)
        
        return queryString
    }
    
    
    init(tourneyNumber: String)
    {
        self.tourneyNumber = tourneyNumber
    }
}
