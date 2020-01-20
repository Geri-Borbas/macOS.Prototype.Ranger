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
public struct TimelineRequest: ApiRequest
{
    
    
    public typealias ApiResponseType = Timeline
    
    
    let network: String
    let player: String
    
    public var path: String { "networks/\(network)/players/\(player)/timeline" }
    public var parameters: KeyValuePairs<String, String> { [:] }
    public var useCache: Bool = true
    
    
    public init(network: String, player: String)
    {
        self.network = network
        self.player = player
    }
}
