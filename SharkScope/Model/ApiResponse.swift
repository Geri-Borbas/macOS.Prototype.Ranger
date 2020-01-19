//
//  ApiResponse.swift
//  SharkScope
//
//  Created by Geri Borbás on 2020. 01. 19..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


public protocol ApiResponse: Decodable
{
    
    
    /// Response should be initalized either from JSON or CSV string.
    init(from string: String) throws
    
    /// Response should be represented as string (for disk caching).
    func stringRepresentation(from data: Data) throws -> String
}
