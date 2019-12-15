//
//  LiveTourneyTable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class LiveTourneyTable: Entry
{
    

    let id_live_table: Int
    let amt_ante: Double
    let amt_sb: Double
    let amt_bb: Double
    // amt_avg_stack
    // amt_min_stack
    // amt_pot
    // amt_rake
    let cnt_players: Int
    // cnt_saw_flop
    // winner
    // cnt_hands
    // amt_pot_1
    // amt_pot_2
    // amt_pot_3
    // amt_pot_4
    // amt_pot_5
    // amt_pot_6
    // amt_pot_7
    // amt_pot_8
    // amt_pot_9
    // amt_rake_1
    // amt_rake_2
    // amt_rake_3
    // amt_rake_4
    // amt_rake_5
    // amt_rake_6
    // amt_rake_7
    // amt_rake_8
    // amt_rake_9
    // cnt_players_1
    // cnt_players_2
    // cnt_players_3
    // cnt_players_4
    // cnt_players_5
    // cnt_players_6
    // cnt_players_7
    // cnt_players_8
    // cnt_players_9
    // cnt_saw_flop_1
    // cnt_saw_flop_2
    // cnt_saw_flop_3
    // cnt_saw_flop_4
    // cnt_saw_flop_5
    // cnt_saw_flop_6
    // cnt_saw_flop_7
    // cnt_saw_flop_8
    // cnt_saw_flop_9
    // winner_1
    // winner_2
    // winner_3
    // winner_4
    // winner_5
    // winner_6
    // winner_7
    // winner_8
    // winner_9
    
    
    required init(row: Row) throws
    {
        id_live_table = try row.columns[0].int()
        amt_ante = try row.columns[1].double()
        amt_sb = try row.columns[2].double()
        amt_bb = try row.columns[3].double()
        cnt_players = try row.columns[8].int()
    }  
}


extension LiveTourneyTable: Equatable
{
    static func == (lhs: LiveTourneyTable, rhs: LiveTourneyTable) -> Bool
    {
        return lhs.id_live_table == rhs.id_live_table
    }
}


extension LiveTourneyTable: CustomStringConvertible
{
    var description: String
    {
        return "id_live_table: \(id_live_table), amt_ante: \(amt_ante), amt_sb: \(amt_sb), amt_bb: \(amt_bb), cnt_players: \(cnt_players))"
    }
}
