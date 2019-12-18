//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct UserInfo: Decodable
{


    let hasFacebook: StringFor<Bool>
    let hasTwitter: StringFor<Bool>
    let loggedIn: StringFor<Bool>
    let optedInForNewsletter: StringFor<Bool>
    let Username: String
    let Country: String
    let Regions: [Region]
    let Currency: String
    let RemainingSearches: Int // This are not wrapped, fun
    let ExpirationDate: Date // Nor this
    let RequestLanguages: String
    let Subscriptions: Subscriptions
    // let AuthorizedNetworks: [Any]


    struct Region: Decodable
    {


        let code: String
        let name: String
    }


    struct Subscriptions: Decodable
    {


        let freeSearchesRemaining: StringFor<Int>
        let totalSearchesRemaining: StringFor<Int>
        let Subscription: Subscription


        struct Subscription: Decodable
        {


            let expirationDate: StringFor<Date>
            let primary: StringFor<Bool>
            let accessLevel: StringFor<Int>
            let _class: String
        }
    }
}
