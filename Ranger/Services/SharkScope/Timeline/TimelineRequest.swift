//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.3.14. TIMELINE
/// The request retrieves the player’s timeline with all events.
struct TimelineRequest: Request
{
    
    
    typealias RootResponseType = Timeline
    
    
    let network: String
    let player: String
    var path: String { "networks/\(network)/players/\(player)/timeline" }
    var parameters: KeyValuePairs<String, String> { [:] }
    var useCache: Bool = true
}
