//
//  BasicPlayerStatistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit

    
public class HandPlayer: Entry
{
    
    
    public let id_tourney: Int
    public let id_player: Int
    public let id_hand: Int
    
    public let player_name: String
    public let player_name_search: String
    public let hand_no: String
    public let flg_hero: Bool
    
    public let position: Int
    public let seat: Int
    
    public let amt_before: Double
    public let amt_blind: Double
    public let amt_ante: Double
    public let amt_won: Double
    
    // Calculations.
    public var stack: Double { amt_before + amt_won }
    
    
    public required init(row: Row) throws
    {
        id_tourney = try row.columns[0].int()
        id_player = try row.columns[1].int()
        id_hand = try row.columns[2].int()
        
        player_name = try row.columns[3].string()
        player_name_search = try row.columns[4].string()
        hand_no = try row.columns[5].string()
        flg_hero = try row.columns[6].bool()
        
        position = try row.columns[7].int()
        seat = try row.columns[8].int()
        
        amt_before = try row.columns[9].double()
        amt_blind = try row.columns[10].double()
        amt_ante = try row.columns[11].double()
        amt_won = try row.columns[12].double()
    }
}


extension HandPlayer: Equatable
{
    
    
    public static func == (lhs: HandPlayer, rhs: HandPlayer) -> Bool
    {
        return (
            lhs.id_hand == rhs.id_hand
        )
    }
}


extension HandPlayer: CustomStringConvertible
{
    
    
    public var description: String
    {
        return "id_hand: \(id_hand)"
    }
}
