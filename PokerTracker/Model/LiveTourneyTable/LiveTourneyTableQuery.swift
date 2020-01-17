//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation

        
public struct LiveTourneyTableQuery: Query
{
    
    
    public typealias EntryType = LiveTourneyTable
    
    
    public var string: String
    { return "SELECT * FROM live_tourney_table ORDER BY live_tourney_table.id_live_table ASC" }
}
