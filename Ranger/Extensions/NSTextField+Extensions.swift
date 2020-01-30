//
//  NSTextField+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 27..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


extension NSTextField
{
    
    
    var fontSize: CGFloat
    {
        get
        {
            if
                let font = self.font,
                let sizeObject = font.fontDescriptor.object(forKey: NSFontDescriptor.AttributeName.size),
                let size = sizeObject as? CGFloat
            { return size }
            return NSFont.systemFontSize
        }
        
        set
        {
            if let font = self.font
            { self.font = NSFont(descriptor: font.fontDescriptor, size: newValue) }
        }
    }
}
