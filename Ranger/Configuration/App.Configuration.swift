//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension App
{
    
    
    struct Configuration: Decodable
    {
        

        /// The app can opt-in to be run in simulation mode. With simulation mode
        /// the `TableTracker` gives back simulated table window data, and the
        /// `TourneyTableViewController` bypasses window alignment on updates.
        var isSimulationMode: Bool = false
        
        /// Convinience shorthand for `isSimulationMode == false`.
        var isLiveMode: Bool { isSimulationMode == false }
        
        /// Contains simulated tourney data (pointing to actual PokerTracker database
        /// entries). With `Simulation.handOffset` one can opt-in to test different
        /// hands in time instead of using the latest hand of the tourney by default.
        var simulation: Simulation
        
        /// Automatically close table window once the tourney is over.
        /// Opted-out by default, window has to be closed manually.
        var autoCloseTableWindow: Bool = false
        
        
        struct Simulation: Decodable
        {
            
            
            var tournamentNumber: String
            var handOffset: Int
            var smallBlind: Int
            var bigBlind: Int
            var ante: Int
        }
                
        
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "App.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
    }
}
