//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension TableSimulator
{
    
    
    struct Configuration: Decodable
    {
        

        var tournamentTypes: [TournamentType]
                
            
        struct TournamentType: Decodable
        {
            
            
            let name: String
            let number: String
            let handsPlayed: Int
            let blindLevelTime: Double
            let blindLevels: [String]
                                  
            
            func blindLevel(for elapsedTime: TimeInterval) -> String
            {
                let blindLevel: Double = floor(elapsedTime / blindLevelTime)
                let blindLevelIndex = Int(min(blindLevel, Double(blindLevels.count - 1)))
                return blindLevels[blindLevelIndex]
            }
        }
            
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "TableSimulator.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
        
        func handsPlayedForTournamentNumberIfAny(tournamentNumber: String) -> Int
        {
            // Lookup.
            guard let tournamentType = tournamentTypes.filter({ eachTournamentType in eachTournamentType.number == tournamentNumber }).first
            else { return 0 }
            
            // Return.
            return tournamentType.handsPlayed
        }
        
    }
}
