//
//  BasicPlayerStatistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


public class Statistics: Entry
{
    
    
    public let id_player: Int
    public let id_site: Int
    public let str_player_name: String
    public let cnt_vpip: Int
    public let cnt_hands: Int
    public let cnt_walks: Int
    public let cnt_pfr: Int
    public let cnt_pfr_opp: Int
    
    
    public required init(row: Row) throws
    {
        
        id_player = try row.columns[0].int()
        id_site = try row.columns[1].int()
        str_player_name = try row.columns[2].string()
        cnt_vpip = try row.columns[3].int()
        cnt_hands = try row.columns[4].int()
        cnt_walks = try row.columns[5].int()
        cnt_pfr = try row.columns[6].int()
        cnt_pfr_opp = try row.columns[7].int()
    }
}

extension Statistics: Equatable
{
    
    
    public static func == (lhs: Statistics, rhs: Statistics) -> Bool
    {
        return (
            lhs.id_player == rhs.id_player &&
            lhs.VPIP.value == rhs.VPIP.value &&
            lhs.PFR.value == rhs.PFR.value
        )
    }
}


extension Statistics: CustomStringConvertible
{
    
    
    public var description: String
    {
        return "id_player: \(id_player), id_site: \(id_site), str_player_name: \(str_player_name), cnt_vpip: \(cnt_vpip), cnt_hands: \(cnt_hands), cnt_walks: \(cnt_walks), cnt_pfr: \(cnt_pfr), cnt_pfr_opp: \(cnt_pfr_opp) \n VPIP:\(String(format: "%.2f%%", VPIP.value)), PFR:\(String(format: "%.2f%%", PFR.value))"
    }
}


// MARK: - Statistics

extension Statistics
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
