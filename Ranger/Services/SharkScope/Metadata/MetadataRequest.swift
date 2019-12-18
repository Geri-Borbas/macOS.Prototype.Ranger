//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct MetadataRequest: Request
{
    
    
    typealias RootResponseType = Metadata
    
    
    var path: String { "metadata" }
    var parameters:  [String: String] { [:] }
    var useCache: Bool = true
}
