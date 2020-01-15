//
//  LiveTourneyPlayerQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension PokerTracker
{
        
        
    struct LiveTourneyPlayerQuery: Query
    {
        
        
        typealias EntryType = LiveTourneyPlayer
        
        
        var string: String
        { return "SELECT * FROM live_tourney_player" }
    }
}
