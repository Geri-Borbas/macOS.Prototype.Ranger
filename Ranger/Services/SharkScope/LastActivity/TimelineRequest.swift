//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.3.13. LAST ACTIVITY
/// The request retrieves the last activity timestamp of the player or
/// group. If the last activity is unknown the request returns 0. Only
/// valid for registered users with an active subscription.
struct TimelineRequest: Request
{
    
    
    typealias RootResponseType = Timeline
    
    
    let network: String
    let player: String
    var path: String { "networks/\(network)/players/\(player)/timeline" }
    var parameters:  [String: String] { [:] }
    var useCache: Bool = true
}
