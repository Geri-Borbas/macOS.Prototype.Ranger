//
//  Model.Players.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 23..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PokerTracker
import SharkScope


extension Model
{


    public struct Players
    {
        
        
        public static func playersOfLatestHand(inTournament tournamentNumber: String, handOffset: Int = 0) -> [Player]
        {
            // Attempt to get `HandPlayer` collection from PokerTracker.
            guard let handPlayers = try? PokerTracker.Service().fetch(PokerTracker.LatestHandPlayerQuery(
                tourneyNumber: tournamentNumber,
                handOffset: handOffset
            ))
            else { return [] }
            
            // Create models.
            let players = handPlayers.map
            {
                eachHandPlayer in
                Model.Player(
                    name: eachHandPlayer.player_name,
                    handPlayer: eachHandPlayer)
            }
            
            return players
        }
        
        public static func cachedPlayers() -> [Player]
        { [] }
        
        public static func someAwesomePlayer() -> [Player]
        {
            return [
                Model.Player(name: "Borbas.Geri"),
                Model.Player(name: "rehakzsolt"),
                Model.Player(name: "Oliana88")
            ]
        }
    }
}
