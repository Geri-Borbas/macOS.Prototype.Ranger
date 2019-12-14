//
//  LiveTourneyPlayerTable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class PlayerCollection: Collection
{
    
    
    typealias RowType = Player
    var rows: [Player]
    
    var queryString: String
    { return "SELECT id_player, player_name FROM player WHERE id_player IN($1);" }
    
    
    init()
    { rows = [] }
    
    
    func fetch(for playerIDs: [Int], connection: Connection?) throws
    {
        let stringPlayerIDs = playerIDs.map{ eachPlayerID in String(eachPlayerID) }
        try fetch(connection: connection,
                  queryParameters: [ stringPlayerIDs.joined(separator: ",") ])
    }
}

