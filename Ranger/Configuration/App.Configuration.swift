//
//  Configuration.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


extension App
{
    
    
    struct Configuration: Decodable
    {
        
        
        /// Automatically close table window once the tourney is over.
        /// Opted-out by default, window has to be closed manually.
        var autoCloseTableWindow: Bool = false
                
        
        static func load() -> Configuration
        {
            let url = Bundle.main.url(forResource: "App.Configuration", withExtension: "plist")!
            let data = try! Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try! decoder.decode(Configuration.self, from: data)
        }
    }
}
