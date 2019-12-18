//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct Metadata: RootResponse
{ let Response: MetadataResponse }


struct MetadataResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    // let MetadataResponse: Any
    let UserInfo: UserInfo
}
