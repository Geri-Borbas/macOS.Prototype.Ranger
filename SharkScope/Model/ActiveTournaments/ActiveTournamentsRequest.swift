//
//  ActiveTournamentsRequest.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.6.1. PLAYERS’ ACTIVE TOURNAMENTS
/// Requests the active tournaments for multiple players. A number of players
/// is provided and the active tournaments are returned for those players that
/// are currently playing and are not blocked. All other players are omitted
/// from the response. If the player is a group then only the players that are
/// not blocked are included.
///
/// Cost 1 per player (players inquired within the past 3 hours cost nothing).
public struct ActiveTournamentsRequest: ApiRequest
{
    
    
    public typealias ApiResponseType = ActiveTournaments
    
    
    let network: String
    let player: String
    
    public var path: String { "activeTournaments" }
    public var parameters: KeyValuePairs<String, String>
    {
        [
            "network1" : network,
            "player1" : player
        ]
    }
    public var useCache: Bool = false
}
