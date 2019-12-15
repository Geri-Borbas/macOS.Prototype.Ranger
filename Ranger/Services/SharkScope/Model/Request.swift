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
    
    
    associatedtype ResponseType where ResponseType: Decodable
    
    
    var path: String { get }
    var parameters:  [String: String] { get }
}
