//
//  String+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 23..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import Cocoa


extension String
{

    
    func copyToClipboard()
    {
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(self, forType: NSPasteboard.PasteboardType.string)
    }
    
    func contains(each strings: [String]) -> Bool
    {
        strings.reduce(
            true,
            {
                contains, eachString in
                contains && self.contains(eachString)
            }
        )
    }
    
    func contains(any strings: [String]) -> Bool
    {
        strings.reduce(
            true,
            {
                contains, eachString in
                contains && self.contains(eachString)
            }
        )
    }
    
    func contained(in strings: [String]) -> Bool
    {
        strings.reduce(
            false,
            {
                contains, eachString in
                contains || self == eachString
            }
        )
    }
}

extension Optional where Wrapped == String
{

    
    func copyToClipboard()
    {
        if let string = self
        {
            NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            NSPasteboard.general.setString(string, forType: NSPasteboard.PasteboardType.string)
        }
    }
}


