//
//  LiveTourneyPlayerQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct LiveTourneyPlayerQuery: Query
{
    
    
    public typealias EntryType = LiveTourneyPlayer
    
    
    public var string: String
    { return "SELECT * FROM live_tourney_player" }
}
