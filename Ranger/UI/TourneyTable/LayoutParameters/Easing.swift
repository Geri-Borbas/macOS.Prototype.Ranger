//
//  Easing.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 04..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


/// More at https://github.com/eppz/Unity.Library.eppz_easing
extension Float
{
    
    
    var linear: Float
    { self }
    
    var easeIn: Float
    { pow(self, 2) }
    
    var easeIn_2: Float
    { pow(self, 3) }
    
    var easeIn_3: Float
    { pow(self, 8) }
    
    var easeOut: Float
    { 1 - pow(1 - self, 2) }
    
    var easeOut_2: Float
    { 2 * self - pow(self, 2) }
    
    var easeOut_3: Float
    { 1 - pow(1 - self, 8) }
    
    func ease(name: String) -> Float
    {
        switch name
        {
            case "linear": return self.linear
            case "easeIn": return self.easeIn
            case "easeIn_2": return self.easeIn_2
            case "easeIn_3": return self.easeIn_3
            case "easeOut": return self.easeOut
            case "easeOut_2": return self.easeOut_2
            case "easeOut_3": return self.easeOut_3
            default: return self
        }
    }
}
