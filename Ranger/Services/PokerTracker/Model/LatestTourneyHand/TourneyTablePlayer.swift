//
//  BasicPlayerStatistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class TourneyTablePlayer: Entry
{
    
    
    let id_tourney: Int
    let id_player: Int
    let id_hand: Int
    
    let player_name: String
    let player_name_search: String
    let hand_no: String
    let flg_hero: Bool
    
    let position: Int
    let seat: Int
    
    let amt_before: Double
    let amt_blind: Double
    let amt_ante: Double
    let amt_won: Double
    
    // Calculations.
    let stack: Double
    
    
    required init(row: Row) throws
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
        
        // Calculations.
        stack = amt_before + amt_won
    }
}


extension TourneyTablePlayer: Equatable
{
    static func == (lhs: TourneyTablePlayer, rhs: TourneyTablePlayer) -> Bool
    {
        return (
            lhs.id_hand == rhs.id_hand
        )
    }
}


extension TourneyTablePlayer: CustomStringConvertible
{
    var description: String
    {
        return "id_hand: \(id_hand)"
    }
}
