//
//  TextFieldData.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 31..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI



protocol TextFieldData
{
    
    
    func apply(to textField: NSTextField)
}

struct TextFieldStringData: TextFieldData
{
    
    
    var value: String?
    
    init(value: String?)
    { self.value = value }
    
    func apply(to textField: NSTextField)
    { if let value = value { textField.stringValue = value } else { textField.stringValue = "-" } }
}

struct TextFieldFloatData: TextFieldData
{
    
    
    var value: Float?
    
    var floatValue: Float?
    { Float(value ?? 0) }
        
    init(value: Float?)
    { self.value = value }
        
    func apply(to textField: NSTextField)
    { if let value = value { textField.floatValue = value } else { textField.stringValue = "-" }  }
}

struct TextFieldDoubleData: TextFieldData
{
    
    
    var value: Double?
    
    
    init(value: Double?)
    { self.value = value }
        
    func apply(to textField: NSTextField)
    { if let value = value { textField.doubleValue = value } else { textField.stringValue = "-" }  }
}

struct TextFieldIntData: TextFieldData
{
    
    
    var value: Int?
    
    
    init(value: Int?)
    { self.value = value }
        
    func apply(to textField: NSTextField)
    { if let value = value { textField.integerValue = value } else { textField.stringValue = "-" }  }
}
