//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct Metadata: RootResponse
{ public let Response: MetadataResponse }


public struct MetadataResponse: Response
{


    public let metadataHash: String
    public let timestamp: StringFor<Date>
    public let success: StringFor<Bool>

    // let MetadataResponse: Any
    public let UserInfo: UserInfo
}
