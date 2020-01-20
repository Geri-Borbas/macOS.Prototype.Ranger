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


// Ida wrote this: \\7[pp p'.'x++3 ææ…]umntu.t6
// Her first line of code at age of 19 months, yay! :)


public protocol ApiRequest
{

    
    associatedtype ApiResponseType where ApiResponseType: ApiResponse
    
    
    var basePath: String { get }
    var path: String { get }
    var parameters: KeyValuePairs<String, String> { get }
    
    var contentType: ContentType { get }
    var useCache: Bool { get set }
}


extension ApiRequest
{

    
    public var basePath: String
    { "/api/searcher/" }

    public var contentType: ContentType
    { .JSON }
    
    public var urlComponents: URLComponents
    {
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "sharkscope.com"
            urlComponents.path = self.basePath + self.path
            urlComponents.queryItems = self.parameters.map { eachElement in URLQueryItem(name: eachElement.key, value: eachElement.value) }
        
        return urlComponents
    }
    
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
