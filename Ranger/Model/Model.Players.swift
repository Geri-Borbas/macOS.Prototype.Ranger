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
        {
            // Only if any.
            guard let cachedFileURLs = ApiRequestCache().cachedFiles(at: "networks/pokerstars/players")
            else { return [] }
        
            // Map names.
            let cachedPlayerNames = cachedFileURLs.map
            {
                eachCachedFileURL in
                eachCachedFileURL.deletingPathExtension().lastPathComponent
            }
            
            // Create models.
            let players = cachedPlayerNames.map
            {
                eachCachedPlayerName in
                Model.Player(name: eachCachedPlayerName)
            }
            
            return players
        }
        
        public static func regs() -> [Player]
        {
            return [
                Model.Player(name: "Borbas.Geri"),
                Model.Player(name: "rehakzsolt"),
                Model.Player(name: "Oliana88"),
                Model.Player(name: "quAAsar"),
                Model.Player(name: "wASH1K"),
                Model.Player(name: "NNiubility"),
                Model.Player(name: "rybluk"),
                Model.Player(name: "wttomi"),
                Model.Player(name: "Tillotam"),
                Model.Player(name: "Tian You520"),
                Model.Player(name: "Gugrand"),
                Model.Player(name: "flokinho86"),
                Model.Player(name: "federaluiasi"),
                Model.Player(name: "@rtemur"),
                Model.Player(name: "LuckyMarat"),
                Model.Player(name: "AlekseyM1983"),
                Model.Player(name: "SpOs Im GoOd"),
                Model.Player(name: "fülemüle")
            ].sorted()
            
            // let playerName = "g1anfar"
            // let playerName = "ScauHades"
        }
    }
}
