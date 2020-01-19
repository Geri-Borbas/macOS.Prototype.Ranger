//
//  Request.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public enum ContentType: String
{
    case JSON = "application/json"
    case CSV = "application/csv"
}


public protocol Request
{
    
    
    associatedtype RootResponseType where RootResponseType: Decodable
    
    
    var basePath: String { get }
    var path: String { get }
    var parameters: KeyValuePairs<String, String> { get }
    
    var contentType: ContentType { get }
    var useCache: Bool { get set }
}


extension Request
{

    
    public var basePath: String
    { SharkScope.Service.basePath }

    public var contentType: ContentType
    { .JSON }
    
    public func usingCache() -> Self
    {
        var copy = self
        copy.useCache = true
        return copy
    }
    
    public func withoutCache() -> Self
    {
        var copy = self
        copy.useCache = false
        return copy
    }    
}
