//
//  SeatViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 24..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


protocol SeatViewControllerDelegate
{
    
    
    func seatDidClick(seatViewController: SeatViewController)
}


class SeatViewController: NSViewController
{


    // Injected upon seque from `seque.identifier`
    var seat: Int = 0
    
    // Injected upon load via storyboard value.
    @objc dynamic var side: String = ""


    @IBOutlet weak var ringButton: NSButton!
    var delegate: SeatViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        layoutEmpty()
    }
    
    
    // MARK: - User Events
    
    @IBAction func ringDidClick(_ sender: AnyObject)
    { delegate?.seatDidClick(seatViewController: self) }
    
    
    // MARK: - Hooks
    
    func update(with player: Model.Player?)
    {
        // Only if any.
        guard let player = player
        else { return layoutEmpty() }
        
        layout(for: player)
    }
    
    
    // MARK: - Layout
    
    func layoutEmpty()
    {
        ringButton.contentTintColor = NSColor.darkGray
        ringButton.toolTip = nil
    }
    
    func layout(for player: Model.Player)
    {
        // Layout color.
        if let finishes = player.sharkScope.statistics?.byPositionPercentage.trendLine.slope
        { ringButton.contentTintColor = ColorRanges.finishes.color(for: finishes) }
        else
        { ringButton.contentTintColor = NSColor.lightGray }
        
        // Log.
        ringButton.toolTip = player.name
    }
    
}
