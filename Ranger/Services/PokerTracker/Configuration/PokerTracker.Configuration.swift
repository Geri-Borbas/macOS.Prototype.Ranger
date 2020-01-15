//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension PT
{
    
    
    struct Configuration: Decodable
    {
        

        let host: String
        let port: Int
        let user: String
        let password: String
        let ssl: Bool
        let database: String
        
        
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "PokerTracker.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
    }
}
