//
//  SeatViewOutlets.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 26..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class SeatViewOutlets: NSObject
{

    
    // Circle.
    @IBOutlet weak var ringButton: NSButton!
    
    // Names / Tables.
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var tablesTextField: NSTextField!
    @IBOutlet weak var nameImageView: NSImageView!
    
    // M.
    @IBOutlet weak var mTextField: NSTextField!
    @IBOutlet weak var mHandsTextField: NSTextField!
    @IBOutlet weak var mBox: NSBox!
    
    // Statistics.
    @IBOutlet weak var vpipTextField: NSTextField!
    @IBOutlet weak var pfrTextField: NSTextField!
    @IBOutlet weak var handsTextField: NSTextField!
    @IBOutlet weak var vpipBox: NSBox!
    @IBOutlet weak var pfrBox: NSBox!
}
