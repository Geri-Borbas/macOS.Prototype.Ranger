//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct Timeline: RootResponse
{ let Response: TimelineResponse }


struct TimelineResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    // let PlayerResponse: Any
    let UserInfo: UserInfo
}
