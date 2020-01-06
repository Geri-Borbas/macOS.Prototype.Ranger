//
//  NSMenuItem+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 06..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


extension NSMenuItem
{
    
    
    func with(target: AnyObject?) -> NSMenuItem
    {
        self.target = target
        return self
    }
    
    func with(representedObject: Any?, target: AnyObject?) -> NSMenuItem
    {
        self.representedObject = representedObject
        self.target = target
        return self
    }
}
