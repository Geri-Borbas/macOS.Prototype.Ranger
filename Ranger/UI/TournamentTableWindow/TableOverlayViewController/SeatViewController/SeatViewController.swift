//
//  SeatViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 24..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class SeatViewController: NSViewController
{

    
    // Injected upon seque from `seque.identifier`
    var seat: Int = 0
    
    // Injected upon load via storyboard value.
    @objc dynamic var side: String = ""
    
    
    @IBOutlet weak var ringImageView: NSImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ringImageView.contentTintColor = (side == "Left") ? NSColor.systemOrange : NSColor.systemYellow
        print("SeatViewController.viewDidLoad(), seat: \(seat), side: \(side)")
    }
    
    func setup(with player: Model.Player)
    {
        
    }
    
}
