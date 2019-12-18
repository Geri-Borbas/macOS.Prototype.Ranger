//
//  Query.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


protocol Request
{
    
    
    associatedtype RootResponseType where RootResponseType: Decodable
    
    
    var path: String { get }
    var parameters:  [String: String] { get }
    var useCache: Bool { get set }
}


extension Request
{

    
    func withoutCache() -> Self
    {
        var copy = self
        copy.useCache = false
        return copy
    }
    
}