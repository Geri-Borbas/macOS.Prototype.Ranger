//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension TableSimulator
{
    
    
    struct Configuration: Decodable
    {
        

        var setting: Bool
                
        
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "TableSimulator.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
    }
}
