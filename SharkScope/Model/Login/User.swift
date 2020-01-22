//
//  User.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct User: RootResponse
{ public let Response: UserResponse }


public struct UserResponse: Response
{


    public let metadataHash: String
    public let timestamp: StringFor<Date>
    public let success: StringFor<Bool>

    public let UserInfo: UserInfo
}
