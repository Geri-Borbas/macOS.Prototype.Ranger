//
//  BasicPlayerStatistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


public class DetailedStatistics: Entry
{
    
    
    public let id_player: Int
    public let id_site: Int
    public let str_player_name: String
    
    // Basic.
    public let cnt_hands: Int
    public let cnt_vpip: Int
    public let cnt_walks: Int
    public let cnt_pfr: Int
    public let cnt_pfr_opp: Int
    
    // Steal.
    public let cnt_steal_att: Int
    public let cnt_steal_opp: Int
    public let cnt_steal_def_action_fold: Int
    public let cnt_steal_def_opp: Int
    public let cnt_steal_def_action_call: Int
    public let cnt_steal_def_action_raise: Int
    public let cnt_steal_def_3bet_opp: Int
    
    // 3Bet.
    public let cnt_p_3bet: Int
    public let cnt_p_3bet_opp: Int
    public let cnt_p_3bet_def_action_fold: Int
    public let cnt_f_3bet_def_action_fold: Int
    public let cnt_t_3bet_def_action_fold: Int
    public let cnt_r_3bet_def_action_fold: Int
    public let cnt_p_3bet_def_opp: Int
    public let cnt_f_3bet_def_opp: Int
    public let cnt_t_3bet_def_opp: Int
    public let cnt_r_3bet_def_opp: Int
    public let cnt_p_3bet_def_action_call: Int
    public let cnt_f_3bet_def_action_call: Int
    public let cnt_t_3bet_def_action_call: Int
    public let cnt_r_3bet_def_action_call: Int
    public let cnt_p_raise_3bet: Int
    public let cnt_p_4bet_opp: Int
    public let cnt_p_5bet_opp: Int
    
    // Flop.
    public let cnt_f_cbet: Int
    public let cnt_f_cbet_opp: Int
    public let cnt_f_cbet_def_action_fold: Int
    public let cnt_f_cbet_def_opp: Int
    public let cnt_f_cbet_def_action_call: Int
    public let cnt_f_cbet_def_action_raise: Int
    
    // Turn.
    public let cnt_t_cbet: Int
    public let cnt_t_cbet_opp: Int
    public let cnt_t_cbet_def_action_fold: Int
    public let cnt_t_cbet_def_opp: Int
    public let cnt_t_cbet_def_action_call: Int
    public let cnt_t_cbet_def_action_raise: Int
    
    // Showdown.
    public let cnt_wtsd: Int
    public let cnt_f_saw: Int
    public let cnt_wtsd_won: Int
    public let cnt_f_saw_won: Int
    
    
    public required init(row: Row) throws
    {
        // Basic.
        id_player = try row.columns[0].int()
        id_site = try row.columns[1].int()
        str_player_name = try row.columns[2].string()
        cnt_hands = try row.columns[3].int()
        cnt_vpip = try row.columns[4].int()
        cnt_walks = try row.columns[5].int()
        cnt_pfr = try row.columns[6].int()
        cnt_pfr_opp = try row.columns[7].int()
        
        // Steal.
        cnt_steal_att = try row.columns[8].int()
        cnt_steal_opp = try row.columns[9].int()
        cnt_steal_def_action_fold = try row.columns[10].int()
        cnt_steal_def_opp = try row.columns[11].int()
        cnt_steal_def_action_call = try row.columns[12].int()
        cnt_steal_def_action_raise = try row.columns[13].int()
        cnt_steal_def_3bet_opp = try row.columns[14].int()
        
        // 3Bet.
        cnt_p_3bet = try row.columns[15].int()
        cnt_p_3bet_opp = try row.columns[16].int()
        cnt_p_3bet_def_action_fold = try row.columns[17].int()
        cnt_f_3bet_def_action_fold = try row.columns[18].int()
        cnt_t_3bet_def_action_fold = try row.columns[19].int()
        cnt_r_3bet_def_action_fold = try row.columns[20].int()
        cnt_p_3bet_def_opp = try row.columns[21].int()
        cnt_f_3bet_def_opp = try row.columns[22].int()
        cnt_t_3bet_def_opp = try row.columns[23].int()
        cnt_r_3bet_def_opp = try row.columns[24].int()
        cnt_p_3bet_def_action_call = try row.columns[25].int()
        cnt_f_3bet_def_action_call = try row.columns[26].int()
        cnt_t_3bet_def_action_call = try row.columns[27].int()
        cnt_r_3bet_def_action_call = try row.columns[28].int()
        cnt_p_raise_3bet = try row.columns[29].int()
        cnt_p_4bet_opp = try row.columns[30].int()
        cnt_p_5bet_opp = try row.columns[31].int()
        
        // Flop.
        cnt_f_cbet = try row.columns[32].int()
        cnt_f_cbet_opp = try row.columns[33].int()
        cnt_f_cbet_def_action_fold = try row.columns[34].int()
        cnt_f_cbet_def_opp = try row.columns[35].int()
        cnt_f_cbet_def_action_call = try row.columns[36].int()
        cnt_f_cbet_def_action_raise = try row.columns[37].int()
        
        // Turn.
        cnt_t_cbet = try row.columns[38].int()
        cnt_t_cbet_opp = try row.columns[39].int()
        cnt_t_cbet_def_action_fold = try row.columns[40].int()
        cnt_t_cbet_def_opp = try row.columns[41].int()
        cnt_t_cbet_def_action_call = try row.columns[42].int()
        cnt_t_cbet_def_action_raise = try row.columns[43].int()
        
        // Showdown.
        cnt_wtsd = try row.columns[44].int()
        cnt_f_saw = try row.columns[45].int()
        cnt_wtsd_won = try row.columns[46].int()
        cnt_f_saw_won = try row.columns[47].int()
    }
}

extension DetailedStatistics: Equatable
{
    
    
    public static func == (lhs: DetailedStatistics, rhs: DetailedStatistics) -> Bool
    {
        return (
            lhs.id_player == rhs.id_player &&
            lhs.VPIP.value == rhs.VPIP.value &&
            lhs.PFR.value == rhs.PFR.value
        )
    }
}


extension DetailedStatistics: CustomStringConvertible
{
    
    
    public var description: String
    {
        return "id_player: \(id_player), id_site: \(id_site), str_player_name: \(str_player_name), cnt_vpip: \(cnt_vpip), cnt_hands: \(cnt_hands), cnt_walks: \(cnt_walks), cnt_pfr: \(cnt_pfr), cnt_pfr_opp: \(cnt_pfr_opp) \n VPIP:\(String(format: "%.2f%%", VPIP.value)), PFR:\(String(format: "%.2f%%", PFR.value))"
    }
}


// MARK: - Statistics

extension DetailedStatistics
{
    
    
    public struct Statistic
    {
        
        
        public let value: Double
        public let count: Int
        public let opportunities: Int
    }
        
    
    /// Total number of hands played.
    /// Formula: Total Number of Hands Played
    /// Function: cnt_hands
    public var hands: Int { cnt_hands }
    
    /// Percentage of the time that a player voluntarily contributed money to the pot, given that he had a chance to do so.
    /// Formula: Number of Times Player Put Money In Pot / (Number of Hands - Number of Walks)
    /// Function: (cnt_vpip / (cnt_hands - cnt_walks)) * 100
    public var VPIP: Statistic
    {
        Statistic(
            value: (Double(cnt_vpip) / Double(cnt_hands - cnt_walks)) * 100.0,
            count: cnt_vpip,
            opportunities: cnt_hands - cnt_walks
        )
    }
    
    /// Percentage of the time that a player put in any raise preflop, given that he had a chance to do so.
    /// Formula: Number of Times Player Raised Preflop / (Number of Hands - Number of Walks)
    /// Function: (cnt_pfr / cnt_pfr_opp) * 100
    public var PFR: Statistic
    {
        Statistic(
            value: (Double(cnt_pfr) / Double(cnt_pfr_opp)) * 100.0,
            count: cnt_pfr,
            opportunities: cnt_pfr_opp
        )
    }
}
