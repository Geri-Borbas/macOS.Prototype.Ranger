//
//  TournamentsQuery.swift
//  SharkScope
//
//  Created by Geri Borbás on 2020. 01. 19..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


/// Tournaments (undocumented)
/// See `Tournaments.md` for more.
public struct TournamentsRequest: ApiRequest
{
    
    
    public typealias ApiResponseType = Tournaments
    
    
    let network: String
    let player: String
    
    public var basePath: String { "/poker-statistics/" }
    public var contentType: ContentType { .CSV }
    public var path: String { "networks/\(network)/players/\(player)/tournaments.csv" }
    public var parameters: KeyValuePairs<String, String> { [:] }
    public var useCache: Bool = true
}



