//
//  SharkScopeResponse.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.3.1. SUMMARY
/// Requests player summary information. The response contains basic
/// information about the user as well as all free statistical
/// information and a small number of most recent tournament results.
struct PlayerSummaryRequest: Request
{
    
    
    typealias RootResponseType = PlayerSummary
    
    
    let network: String
    let player: String
    var path: String { "networks/\(network)/players/\(player)" }
    var parameters: KeyValuePairs<String, String>
    {
        // TODO: Persist filter settings per player.
        (player == "Borbas.Geri") ? [ "filter" : "Date:1Y" ] : [:]
    }
    var useCache: Bool = true
}
