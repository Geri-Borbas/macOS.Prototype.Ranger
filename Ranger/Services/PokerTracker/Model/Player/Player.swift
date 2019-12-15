//
//  LiveTable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class Player: Entry
{
    
    
    let id_player: Int
    let player_name: String
    
    
    required init(row: Row) throws
    {
        id_player = try row.columns[0].int()
        player_name = try row.columns[1].string()
    }
}


extension Player: Equatable
{
    static func == (lhs: Player, rhs: Player) -> Bool
    {
        return lhs.id_player == rhs.id_player
    }
}


extension Player: CustomStringConvertible
{
    var description: String
    {
        return "id_player: \(id_player), player_name: \(player_name)"
    }
}
