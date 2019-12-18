//
//  Response.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public protocol Response: Decodable
{
    
    
    var metadataHash: String { get }
    var timestamp: StringFor<Date> { get }
    var success: StringFor<Bool> { get }
    
    var UserInfo: UserInfo { get }
}
