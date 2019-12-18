//
//  SharkScopeResponse.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerSummaryRequest: Request
{
    
    
    typealias RootResponseType = PlayerSummary
    
    
    let network: String
    let player: String
    var path: String { "networks/\(network)/players/\(player)" }
    var parameters:  [String: String] { [:] }
    var useCache: Bool = true
}
