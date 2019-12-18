//
//  LiveTourneyTableQuery.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.1.1. METADATA
/// Requests metadata information from the server. If the hash parameter
/// is specified and the value provided is the latest metadata hash, the
/// response is set to cache on the client. The response header will not
/// contain an appVersion attribute even if there is a valid application
/// version.
struct MetadataRequest: Request
{
    
    
    typealias RootResponseType = Metadata
    
    
    var path: String { "metadata" }
    var parameters:  [String: String] { [:] }
    var useCache: Bool = true
}
