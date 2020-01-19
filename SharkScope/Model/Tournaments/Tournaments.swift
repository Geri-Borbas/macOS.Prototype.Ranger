//
//  Tournaments.swift
//  SharkScope
//
//  Created by Geri Borbás on 2020. 01. 19..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftCSV


public struct Tournaments: Equatable
{

    
    let tournaments: [Tournament]
    
    
    struct Tournament: Equatable
    {
        
        
        let Network: String     // PokerStars
        let Player: String      // "@rtemur"
        let GameID: String      // 2783430466
        let Stake: Float        // 3.19
        let Date: Date          // 2020-01-15 17:18 (PST finish date)
        let Entrants: Int       // 45
        let Rake: Float         // 0.31
        let Game: String        // H
        let Structure: String   // No Limit
        let Speed: String       // Turbo
        let Result: Float       // -3.19
        let Position: Int       // 15
        let Flags: String       // Bounty OnDemand Multi Entry
        let Currency: String    // USD
        
        
        init(with row: [String:String])
        {
            self.Network = Tournament.value(from: row["Network"])
            self.Player = Tournament.value(from: row[" Player"])
            self.GameID = Tournament.value(from: row[" Game ID"])
            self.Stake = Tournament.value(from: row[" Stake"])
            self.Date = Tournament.value(from: row[" Date"])
            self.Entrants = Tournament.value(from: row[" Entrants"])
            self.Rake = Tournament.value(from: row[" Rake"])
            self.Game = Tournament.value(from: row[" Game"])
            self.Structure = Tournament.value(from: row[" Structure"])
            self.Speed = Tournament.value(from: row[" Speed"])
            self.Result = Tournament.value(from: row[" Result"])
            self.Position = Tournament.value(from: row[" Position"])
            self.Flags = Tournament.value(from: row[" Flags"])
            self.Currency = Tournament.value(from: row[" Currency"])
        }
        
        static func value(from string: String?) -> String
        { string ?? "" }
        
        static func value(from string: String?) -> Int
        { Int(string ?? "0") ?? 0 }
        
        static func value(from string: String?) -> Float
        { Float(string ?? "0.0") ?? 0.0 }
        
        static func value(from string: String?) -> Date
        {
            // Parse date.
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd HH:mm"
                dateFormatter.timeZone = TimeZone(abbreviation: "PST")
            
            return dateFormatter.date(from: string ?? "") ?? Foundation.Date()
        }
    }
    
    
    init(with csvString: String) throws
    {
        let csv = try CSV(string: csvString)
        
        self.tournaments = csv.namedRows.map
        {
            eachNamedRow in
            Tournament(with: eachNamedRow)
        }
    }
}
