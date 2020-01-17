//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct Timeline: RootResponse
{ public let Response: TimelineResponse }


public struct TimelineResponse: Response
{


    public let metadataHash: String
    public let timestamp: StringFor<Date>
    public let success: StringFor<Bool>

    // let PlayerResponse: Any
    public let UserInfo: UserInfo
}
