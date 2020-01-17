//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension SharkScope
{
    
    
    public struct Configuration: Decodable
    {
        

        let Username: String
        let Password: String
        let UserAgent: String
        
        
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "SharkScope.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
    }
}
