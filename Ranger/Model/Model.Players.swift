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
            guard let handPlayers = try? PokerTracker.Service.fetch(PokerTracker.LatestHandPlayerQuery(
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
                
                // Cached Tournaments.
                Model.Player(name: "rehakzsolt"),
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
                Model.Player(name: "fülemüle"),
                Model.Player(name: "B0aR"),
                Model.Player(name: "Gromobix"),
                Model.Player(name: "LaPC"),
                Model.Player(name: "Alfa2012"),
                Model.Player(name: "ShipItSicmik777"),
                Model.Player(name: "balder24"),
                Model.Player(name: "moozeev"),
                
                // Enpty.
                Model.Player(name: "g1anfar"),
                Model.Player(name: "ScauHades"),
                Model.Player(name: "carlos1020"),
                
                // Opted-Out.
                Model.Player(name: "Oliana88"),
                Model.Player(name: "wolfeboyocd"),
                Model.Player(name: "denis1986211"),
                
                // And me.
                Model.Player(name: "Borbas.Geri"),
                
            ].sorted()
        }
    }
}
