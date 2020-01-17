//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct UserInfo: Decodable, Equatable
{


    public let hasFacebook: StringFor<Bool>
    public let hasTwitter: StringFor<Bool>
    public let loggedIn: StringFor<Bool>
    public let optedInForNewsletter: StringFor<Bool>
    public let Username: String
    public let Country: String
    public let Regions: [Region]
    public let Currency: String
    public let RemainingSearches: Int // This is not wrapped, fun
    public let ExpirationDate: Date? // Nor this
    public let RequestLanguages: String
    public let Subscriptions: Subscriptions
    // let AuthorizedNetworks: [Any]


    public struct Region: Decodable, Equatable
    {


        public let code: String
        public let name: String
    }


    public struct Subscriptions: Decodable, Equatable
    {


        public let freeSearchesRemaining: StringFor<Int>
        public let totalSearchesRemaining: StringFor<Int>
        public let Subscription: Subscription?


        public struct Subscription: Decodable, Equatable
        {


            public let expirationDate: StringFor<Date>
            public let primary: StringFor<Bool>
            public let accessLevel: StringFor<Int>
            public let _class: String
        }
    }
}
