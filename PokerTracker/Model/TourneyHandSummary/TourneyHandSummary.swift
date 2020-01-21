//
//  TourneyHandSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit

    
public class TourneyHandSummary: Entry
{
    
    
    
    public let id_hand: Int
    public let hand_no: Int
    // public let date_played: Date
    public let blinds_name: String
    
    
    public required init(row: Row) throws
    {
        id_hand = try row.columns[0].int()
        hand_no = try row.columns[1].int()
        // date_played = try row.columns[2].date().date(in: TimeZone.current)
        blinds_name = try row.columns[3].string()
    }
}


extension TourneyHandSummary: Equatable
{
    
    
    public static func == (lhs: TourneyHandSummary, rhs: TourneyHandSummary) -> Bool
    {
        return (
            lhs.id_hand == rhs.id_hand
        )
    }
}


extension TourneyHandSummary: CustomStringConvertible
{
    
    
    public var description: String
    {
        return "id_hand: \(id_hand)"
    }
}
