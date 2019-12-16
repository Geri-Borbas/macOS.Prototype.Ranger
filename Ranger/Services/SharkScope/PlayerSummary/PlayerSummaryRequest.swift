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
    
    
    typealias ResponseType = Metadata
    
    
    var path: String { "metadata" }
    var parameters:  [String: String] { [:] }
}
