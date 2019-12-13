//
//  LiveTourneyTables.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


class LiveTourneyTableCollection: Collection
{
    
    
    typealias RowType = LiveTourneyTable
    var rows: [LiveTourneyTable]
    
    var queryString: String
    { return "SELECT * FROM public.live_tourney_table" }
    
    
    init()
    { rows = [] }
}
