//
//  Response.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public protocol RootResponse: Decodable
{
    
    
    associatedtype ResponseType where ResponseType: Response
    
    
    var Response: ResponseType { get }
}



