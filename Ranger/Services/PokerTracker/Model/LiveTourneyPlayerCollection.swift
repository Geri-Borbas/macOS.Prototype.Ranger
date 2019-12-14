//
//  LiveTourneyPlayerTable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class LiveTourneyPlayerCollection: Collection
{
    
    
    typealias RowType = LiveTourneyPlayer
    var rows: [LiveTourneyPlayer]
    
    var queryString: String
    { return "SELECT * FROM public.live_tourney_player" }
    
    
    init()
    { rows = [] }
}
