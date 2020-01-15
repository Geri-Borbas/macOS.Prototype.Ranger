//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerQuery: Query
{
    
    
    typealias EntryType = Player_
    
    
    let playerIDs: [Int]
    var string: String
    {
        let stringPlayerIDs = playerIDs.map{ eachPlayerID in String(eachPlayerID) }
        let joinedPlayerIDs = stringPlayerIDs.joined(separator: ",")
        return "SELECT player.id_player, player.player_name FROM player WHERE player.id_player IN(\(joinedPlayerIDs))"
    }
    
    
    init(playerIDs: [Int])
    {
        self.playerIDs = playerIDs
    }
}
