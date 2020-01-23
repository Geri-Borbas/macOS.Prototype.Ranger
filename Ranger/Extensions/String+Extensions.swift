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


