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
    public let cnt_p_3bet_def_opp: Int
    public let cnt_p_3bet_def_action_call: Int
    
    public let cnt_p_4bet: Int
    public let cnt_p_4bet_opp: Int

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
        cnt_p_3bet_def_opp = try row.columns[18].int()
        cnt_p_3bet_def_action_call = try row.columns[19].int()
        cnt_p_4bet = try row.columns[20].int()
        cnt_p_4bet_opp = try row.columns[21].int()

        // Flop.
        cnt_f_cbet = try row.columns[22].int()
        cnt_f_cbet_opp = try row.columns[23].int()
        cnt_f_cbet_def_action_fold = try row.columns[24].int()
        cnt_f_cbet_def_opp = try row.columns[25].int()
        cnt_f_cbet_def_action_call = try row.columns[26].int()
        cnt_f_cbet_def_action_raise = try row.columns[27].int()

        // Turn.
        cnt_t_cbet = try row.columns[28].int()
        cnt_t_cbet_opp = try row.columns[29].int()
        cnt_t_cbet_def_action_fold = try row.columns[30].int()
        cnt_t_cbet_def_opp = try row.columns[31].int()
        cnt_t_cbet_def_action_call = try row.columns[32].int()
        cnt_t_cbet_def_action_raise = try row.columns[33].int()

        // Showdown.
        cnt_wtsd = try row.columns[34].int()
        cnt_f_saw = try row.columns[35].int()
        cnt_wtsd_won = try row.columns[36].int()
        cnt_f_saw_won = try row.columns[37].int()
    }
}

extension DetailedStatistics: Equatable
{
    
    
    public static func == (lhs: DetailedStatistics, rhs: DetailedStatistics) -> Bool
    {
        return (
            lhs.id_player == rhs.id_player &&
            lhs.VPIP.value == rhs.VPIP.value &&
            lhs.aligned.PFR.value == rhs.aligned.PFR.value
        )
    }
}


extension DetailedStatistics: CustomStringConvertible
{
    
    
    public var description: String
    {
        return "id_player: \(id_player), id_site: \(id_site), str_player_name: \(str_player_name), cnt_vpip: \(cnt_vpip), cnt_hands: \(cnt_hands), cnt_walks: \(cnt_walks), cnt_pfr: \(cnt_pfr), cnt_pfr_opp: \(cnt_pfr_opp) \n VPIP:\(String(format: "%.2f%%", VPIP.value)), aligned.PFR:\(String(format: "%.2f%%", aligned.PFR.value))"
    }
}


// MARK: - Statistics

extension DetailedStatistics
{
    
    
    public struct Statistic: CustomStringConvertible
    {
        
        
        public let name: String
        public let value: Double
        public let count: Int
        public let opportunities: Int
        
        public var description: String
        {
            let valueDescription = (opportunities > 0) ? String(format: "%.0f (%d/%d)", value, count, opportunities) : "-"
            return String(format: "%@: %@", name, valueDescription)
        }
    }
        
    
    /// Total number of hands played.
    /// **Formula:** Total Number of Hands Played
    /// **Function:** `cnt_hands`
    public var hands: Int { cnt_hands }
    
    /// Percentage of the time that a player voluntarily contributed money to the pot, given that he had a chance to do so.
    /// **Formula:** Number of Times Player Put Money In Pot / (Number of Hands - Number of Walks).
    /// **Function:** `(cnt_vpip / (cnt_hands - cnt_walks)) * 100`
    public var VPIP: Statistic
    {
        Statistic(
            name: "VPIP",
            value: (Double(cnt_vpip) / Double(cnt_hands - cnt_walks)) * 100.0,
            count: cnt_vpip,
            opportunities: cnt_hands - cnt_walks
        )
    }
    
    /// Percentage of the time that a player put in any raise preflop, given that he had a chance to do so.
    /// **Formula:** Number of Times Player Raised Preflop / (Number of Hands - Number of Walks).
    /// **Function:** `(cnt_pfr / cnt_pfr_opp) * 100`
    public var PFR: Statistic
    {
        Statistic(
        name: "PFR",
            value: (Double(cnt_pfr) / Double(cnt_pfr_opp)) * 100.0,
            count: cnt_pfr,
            opportunities: cnt_pfr_opp
        )
    }
    
    /// Percentage of the time that a player opened the pot by raising from the cutoff, button, or small blind.
    /// **Formula:** Number of Times Player Attempted to Steal Blinds / Number of Times Player Could Attempt to Steal Blinds.
    /// **Function:** `(cnt_steal_att / cnt_steal_opp) * 100`
    public var attemptToSteal: Statistic
    {
        Statistic(
            name: "Steal · Attempt",
            value: (Double(cnt_steal_att) / Double(cnt_steal_opp)) * 100,
            count: cnt_steal_att,
            opportunities: cnt_steal_opp
        )
    }
    
    /// Percentage of the time that a player folded when in a blind and facing an open raise from the cutoff, button, or small blind without any other players being involved.
    /// **Formula:** Number of Times Player Folded Blind to a Steal / Number of Times Player Could Fold Blind to a Steal.
    /// **Function:** `(cnt_steal_def_action_fold / cnt_steal_def_opp) * 100`
    public var foldToSteal: Statistic
    {
        Statistic(
            name: "Steal · Fold",
            value: (Double(cnt_steal_def_action_fold) / Double(cnt_steal_def_opp)) * 100,
            count: cnt_steal_def_action_fold,
            opportunities: cnt_steal_def_opp
        )
    }
    
    /// Percentage of the time that a player called from either blind when facing an open raise from the cutoff, button, or small blind.
    /// **Formula:** Number of Times Player Called a Steal Attempt / Number of Times Player Could Call a Steal Attempt.
    /// **Function:** `(cnt_steal_def_action_call / cnt_steal_def_opp) * 100`
    public var callSteal: Statistic
    {
        Statistic(
            name: "Steal · Call",
            value: (Double(cnt_steal_def_action_call) / Double(cnt_steal_def_opp)) * 100,
            count: cnt_steal_def_action_call,
            opportunities: cnt_steal_def_opp
        )
    }
    
    /// Percentage of the time that a player 3Bet preflop when in a blind and facing an open raise from the cutoff, button, or small blind.
    /// **Formula:** Number of Times Player 3Bet When Facing Steal / Number of Times Player Could 3Bet When Facing Steal.
    /// **Function:** `(cnt_steal_def_action_raise / cnt_steal_def_3bet_opp) * 100`
    public var raiseSteal: Statistic
    {
        Statistic(
            name: "Steal · Raise",
            value: (Double(cnt_steal_def_action_raise) / Double(cnt_steal_def_3bet_opp)) * 100,
            count: cnt_steal_def_action_raise,
            opportunities: cnt_steal_def_3bet_opp
        )
    }
    
    /// Percentage of the time that a player 3Bet preflop given that he had a chance to do so.
    /// Formula: Number of 3Bets Preflop / Number of Times Player Could 3Bet Preflop.
    /// **Function:** `(cnt_p_3bet / cnt_p_3bet_opp) * 100`
    public var preflop3Bet: Statistic
    {
        Statistic(
            name: "3Bet · Attempt",
            value: (Double(cnt_p_3bet) / Double(cnt_p_3bet_opp)) * 100,
            count: cnt_p_3bet,
            opportunities: cnt_p_3bet_opp
        )
    }

    /// Percentage of the time that a player folded to a preflop 3 bet, given that he had a chance to do so regardless of other prior actions.
    /// **Formula:** Number of Times Player Folded to a 3Bet Preflop / Number of Times Player Could Fold to a 3Bet Preflop.
    /// **Function:** `(cnt_p_3bet_def_action_fold / cnt_p_3bet_def_opp) * 100`
    public var foldToPreflop3Bet: Statistic
    {
        Statistic(
            name: "3Bet · Fold",
            value: (Double(cnt_p_3bet_def_action_fold) / Double(cnt_p_3bet_def_opp)) * 100,
            count: cnt_p_3bet_def_action_fold,
            opportunities: cnt_p_3bet_def_opp
        )
    }

    /// Percentage of the time that a player called a preflop 3Bet, given that he had a chance to do so regardless of other prior actions.
    /// **Formula:** Number of Times Player Called a 3Bet Preflop / Number of Times Player Could Call a 3Bet Preflop.
    /// **Function:** `(cnt_p_3bet_def_action_call / cnt_p_3bet_def_opp) * 100`
    public var callPreflop3Bet: Statistic
    {
        Statistic(
            name: "3Bet · Call",
            value: (Double(cnt_p_3bet_def_action_call) / Double(cnt_p_3bet_def_opp)) * 100,
            count: cnt_p_3bet_def_action_call,
            opportunities: cnt_p_3bet_def_opp
        )
    }

    /// Percentage of the time that a player 4Bet or higher preflop given that he had a chance to do so.
    /// **Formula:** Number of Times Player 4Bet or Higher Preflop / Number of Times Player Could 4Bet or Higher Preflop.
    /// **Function:** `(cnt_p_4bet / cnt_p_4bet_opp) * 100`
    public var raisePreflop3Bet: Statistic
    {
        Statistic(
            name: "3Bet · Raise",
            value: (Double(cnt_p_4bet) / Double(cnt_p_4bet_opp)) * 100,
            count: cnt_p_4bet,
            opportunities: cnt_p_4bet_opp
        )
    }
    
    /// Percentage of the time that a player bet the flop given that he had a chance to do so and he made the last raise preflop.
    /// **Formula:** Number of Times Player Continuation Bet on the Flop / Number of Times Player Could Continuation Bet on the Flop.
    /// **Function:** `(cnt_f_cbet / cnt_f_cbet_opp) * 100`
    public var flopCBet: Statistic
    {
        Statistic(
            name: "Flop CBet · Attempt",
            value: (Double(cnt_f_cbet) / Double(cnt_f_cbet_opp)) * 100,
            count: cnt_f_cbet,
            opportunities: cnt_f_cbet_opp
        )
    }
    
    /// Percentage of the time that a player folds to a flop bet given that the bettor was the last raiser preflop.
    /// **Formula:** Number of Times Player Folded to a Continuation Bet on the Flop / Number of Times Player Could Fold to a Continuation Bet on the Flop.
    /// **Function:** `(cnt_f_cbet_def_action_fold / cnt_f_cbet_def_opp) * 100`
    public var foldToFlopCBet: Statistic
    {
        Statistic(
            name: "Flop CBet · Fold",
            value: (Double(cnt_f_cbet_def_action_fold) / Double(cnt_f_cbet_def_opp)) * 100,
            count: cnt_f_cbet_def_action_fold,
            opportunities: cnt_f_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player called a flop bet given that the betting player had also made the last preflop raise.
    /// **Formula:** Number of Times Player Called a Continuation Bet on the Flop / Number of Times Player Could Call a Continuation Bet on the Flop.
    /// **Function:** `(cnt_f_cbet_def_action_call / cnt_f_cbet_def_opp) * 100`
    public var callFlopCBet: Statistic
    {
        Statistic(
            name: "Flop CBet · Call",
            value: (Double(cnt_f_cbet_def_action_call) / Double(cnt_f_cbet_def_opp)) * 100,
            count: cnt_f_cbet_def_action_call,
            opportunities: cnt_f_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player raised a flop bet given that the betting player had also made the last preflop raise.
    /// **Formula:** Number of Times Player Raised a Continuation Bet on the Flop / Number of Times Player Could Raise a Continuation Bet on the Flop.
    /// **Function:** `(cnt_f_cbet_def_action_raise / cnt_f_cbet_def_opp) * 100`
    public var raiseFlopCBet: Statistic
    {
        Statistic(
            name: "Flop CBet · Raise",
            value: (Double(cnt_f_cbet_def_action_raise) / Double(cnt_f_cbet_def_opp)) * 100,
            count: cnt_f_cbet_def_action_raise,
            opportunities: cnt_f_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player bet the turn given that he continuation bet the flop and had a chance to do so.
    /// **Formula:** Number of Times Player Continuation Bet on the Turn / Number of Times Player Could Continuation Bet on the Turn.
    /// **Function:** `(cnt_t_cbet / cnt_t_cbet_opp) * 100`
    public var turnCBet: Statistic
    {
        Statistic(
            name: "Turn CBet · Attempt",
            value: (Double(cnt_t_cbet) / Double(cnt_t_cbet_opp)) * 100,
            count: cnt_t_cbet,
            opportunities: cnt_t_cbet_opp
        )
    }
    
    /// Percentage of the time that a player folded to a continuation bet on the turn.
    /// **Formula:** Number of Times Player Folded to a Continuation Bet on the Turn / Number of Times Player Could Fold to a Continuation Bet on the Turn.
    /// **Function:** `(cnt_t_cbet_def_action_fold / cnt_t_cbet_def_opp) * 100`
    public var foldToTurnCBet: Statistic
    {
        Statistic(
            name: "Turn CBet · Fold",
            value: (Double(cnt_t_cbet_def_action_fold) / Double(cnt_t_cbet_def_opp)) * 100,
            count: cnt_t_cbet_def_action_fold,
            opportunities: cnt_t_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player called a continuation bet on the turn.
    /// **Formula:** Number of Times Player Called a Continuation Bet on the Turn / Number of Times Player Could Call a Continuation Bet on the Turn.
    /// **Function:** `(cnt_t_cbet_def_action_call / cnt_t_cbet_def_opp) * 100`
    public var callTurnCBet: Statistic
    {
        Statistic(
            name: "Turn CBet · Call",
            value: (Double(cnt_t_cbet_def_action_call) / Double(cnt_t_cbet_def_opp)) * 100,
            count: cnt_t_cbet_def_action_call,
            opportunities: cnt_t_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player raised a continuation bet on the turn.
    /// **Formula:** Number of Times Player Raised a Continuation Bet on the Turn / Number of Times Player Could Raise a Continuation Bet on the Turn.
    /// **Function:** `(cnt_t_cbet_def_action_raise / cnt_t_cbet_def_opp) * 100`
    public var raiseTurnCBet: Statistic
    {
        Statistic(
            name: "Turn CBet · Raise",
            value: (Double(cnt_t_cbet_def_action_raise) / Double(cnt_t_cbet_def_opp)) * 100,
            count: cnt_t_cbet_def_action_raise,
            opportunities: cnt_t_cbet_def_opp
        )
    }
    
    /// Percentage of the time that a player went to showdown, given that he saw the flop.
    /// **Formula:** Number of Times Player Went to Showdown / Number of Times Player Saw the Flop.
    /// **Function:** `(cnt_wtsd / cnt_f_saw) * 100`
    public var wentToShowdown: Statistic
    {
        Statistic(
            name: "WTSD",
            value: (Double(cnt_wtsd) / Double(cnt_f_saw)) * 100,
            count: cnt_wtsd,
            opportunities: cnt_f_saw
        )
    }
    
    /// Percentage of the time that a player won some money at showdown, given that he got to showdown.
    /// **Formula:** Number of Times Player Won Money at Showdown / Number of Times Player Went to Showdown.
    /// **Function:** `(cnt_wtsd_won / cnt_wtsd) * 100`
    public var wonAtShowdown: Statistic
    {
        Statistic(
            name: "WSD",
            value: (Double(cnt_wtsd_won) / Double(cnt_wtsd)) * 100,
            count: cnt_wtsd_won,
            opportunities: cnt_wtsd
        )
    }
    
    /// Percentage of the time that a player won some money in some fashion, given that he saw the flop.
    /// **Formula:** Number of Times Player Saw the Flop and Won Money / Number of Times Player Saw the Flop.
    /// **Function:** `(cnt_f_saw_won / cnt_f_saw) * 100`
    public var wonWhenSawFlop: Statistic
    {
        Statistic(
            name: "WWSF",
            value: (Double(cnt_f_saw_won) / Double(cnt_f_saw)) * 100,
            count: cnt_f_saw_won,
            opportunities: cnt_f_saw
        )
    }
    
    
}


// MARK: - Aligned Statistics

extension DetailedStatistics
{
    
    
    
    public var aligned: Aligned
    { Aligned(statistics: self) }
    
    
    public struct Aligned
    {
    
        
        let statistics: DetailedStatistics
        
    
        /// Same as `PFR`, except it uses the same opportunities denominator as `VPIP`.
        /// **Function:** `(cnt_pfr / (cnt_hands - cnt_walks)) * 100`
        public var PFR: Statistic
        {
            Statistic(
                name: "PFR (aligned)",
                value: (Double(statistics.cnt_pfr) / Double(statistics.cnt_hands - statistics.cnt_walks)) * 100.0,
                count: statistics.cnt_pfr,
                opportunities: statistics.cnt_hands - statistics.cnt_walks
            )
        }
        
        /// Same as `raiseSteal`, except it uses the same opportunities denominator as `foldToSteal`.
        /// **Function:** `(cnt_steal_def_action_raise / cnt_steal_def_opp) * 100`
        public var raiseSteal: Statistic
        {
            Statistic(
                name: "Steal · Raise (aligned)",
                value: (Double(statistics.cnt_steal_def_action_raise) / Double(statistics.cnt_steal_def_opp)) * 100,
                count: statistics.cnt_steal_def_action_raise,
                opportunities: statistics.cnt_steal_def_opp
            )
        }

        /// Same as `raisePreflop3Bet`, except it uses the same opportunities denominator as `foldToPreflop3Bet`.
        /// **Function:** `(cnt_p_4bet / cnt_p_3bet_def_opp) * 100`
        public var raisePreflop3Bet: Statistic
        {
            Statistic(
                name: "3Bet · Raise (aligned)",
                value: (Double(statistics.cnt_p_4bet) / Double(statistics.cnt_p_3bet_def_opp)) * 100,
                count: statistics.cnt_p_4bet,
                opportunities: statistics.cnt_p_3bet_def_opp
            )
        }
    }
}
