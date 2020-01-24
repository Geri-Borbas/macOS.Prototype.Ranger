//
//  TableOverlayViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 24..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class TableOverlayViewController: NSViewController
{

    
    @IBOutlet weak var ring_1: NSImageView!
    @IBOutlet weak var ring_2: NSImageView!
    @IBOutlet weak var ring_3: NSImageView!
    @IBOutlet weak var ring_4: NSImageView!
    @IBOutlet weak var ring_5: NSImageView!
    @IBOutlet weak var ring_6: NSImageView!
    @IBOutlet weak var ring_7: NSImageView!
    @IBOutlet weak var ring_8: NSImageView!
    @IBOutlet weak var ring_9: NSImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        guard
            let seatViewController = segue.destinationController as? SeatViewController,
            let sequeIdentifier = segue.identifier,
            let seat = Int(sequeIdentifier)
        else { return }
        
        // Inject seat index from seque identifier (set in storyboard).
        seatViewController.seat = seat
    }
    
}
