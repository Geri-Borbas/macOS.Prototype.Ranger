//
//  ActiveTournamentsRequest.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.3.2. COMPLETED TOURNAMENTS
/// Requests a specific number of recent tournaments. The response contains only
/// up to the number of tournaments requested. The number of tournaments requested
/// and the ordering is defined in the “order” parameter which is similar to the
/// Limit constraint and takes the same arguments, with one addition: “player”
/// ordering. When requesting tournaments for a group you may use player ordering
/// (e.g. order=player,1~1000) to return the tournaments for each player in order.
/// This is more efficient when requesting a large number of tournaments for a large
/// number of users and you want to perform the request in chunks (i.e. order=player,
/// 1~1000 then order=player,1~2000, etc.).
///
/// Cost 1 Search per 100 tournaments returned.
struct CompletedTournamentsRequest: Request
{
    
    
    typealias RootResponseType = CompletedTournaments
    
    
    let network: String
    let player: String
    let amount: Int
    var path: String { "networks/\(network)/players/\(player)/completedTournaments" }
    var parameters: KeyValuePairs<String, String>
    {
        (amount == 0) ? [:] :
        [
            "order" : "player,1~\(amount)",
        ]
    }
    var useCache: Bool = true
    
    
    init(network: String, player: String, amount: Int = 0)
    {
        self.network = network
        self.player = player
        self.amount = amount
    }
}
