//
//  UserRequest.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


/// 3.9.1. LOGIN
/// Performs a login confirmation. The response only contains the
/// UserInfo element if successful.
public struct UserRequest: ApiRequest
{
    
    
    public typealias ApiResponseType = User
    
    
    public var path: String { "user" }
    public var parameters: KeyValuePairs<String, String> { [:] }
    public var useCache: Bool = true
    
    
    public init()
    { }
}
