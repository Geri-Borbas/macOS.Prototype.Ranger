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
            guard let cacheFileURLs = ApiRequestCache().cachedFiles(at: "networks/pokerstars/players")
            else { return [] }
            
            // Map names.
            let cachedPlayerNames = cacheFileURLs.map
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
        
        public static func optedOutPlayers() -> [Player]
        {
            // Only if any.
            guard let cacheFileURLs = ApiRequestCache().cachedFiles(at: "networks/pokerstars/players")
            else { return [] }

            let optedOutPlayerCacheFileURLs = cacheFileURLs.filter
            {
                eachCacheFileURL in
                
                // Read.
                guard let eachCacheFileContents = try? String(contentsOfFile: eachCacheFileURL.path, encoding: String.Encoding.utf8)
                else { return false }
                
                // Lookup term.
                return eachCacheFileContents.contains("Player not found or has opted out.")
            }
        
            // Map names.
            let cachedPlayerNames = optedOutPlayerCacheFileURLs.map
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
        { return load("Regs") }
        
        static func load(_ plistFileName: String) -> [Player]
        {
            // Resolve Documents directory.
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { return [] }
                    
            // Append path.
            let plistFileURL = documentsDirectory.appendingPathComponent(plistFileName).appendingPathExtension("plist")
            
            // Load and decode.
            let data = try! Data(contentsOf: plistFileURL)
            let decoder = PropertyListDecoder()
            
            guard let playerNames = try? decoder.decode(Model.PlayerNames.self, from: data)
            else { return [] }
            
            return playerNames.playerNames.map
            {
                eachPlayerName in
                Model.Player(name: eachPlayerName)
            }
        }
    }
}
