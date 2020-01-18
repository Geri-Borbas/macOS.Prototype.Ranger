//
//  NSRect+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 18..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


extension NSRect
{
    
    
    func shorter(by height: CGFloat) -> NSRect
    {
        return NSRect(
            x: self.origin.x,
            y: self.origin.y,
            width: self.size.width,
            height: self.size.height - height
        )
    }
}
