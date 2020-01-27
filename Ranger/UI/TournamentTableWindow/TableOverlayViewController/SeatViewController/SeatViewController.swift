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

    // UI.
    @IBOutlet weak var outlets: SeatViewOutlets!
        
    // Binds.
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
        
        if (player.stack == 0)
        { layoutZero(for: player) }
        else
        { layout(for: player) }
    }
    
    
    // MARK: - Layout
    
    func layoutEmpty()
    {
        // Visibility.
        outlets.circleBackgroundImageView.isHidden = true
        outlets.ringButton.isHidden = true
        outlets.nameImageView.isHidden = true
        outlets.nameTextField.isHidden = true
        outlets.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = true }
    }
    
    func layoutZero(for player: Model.Player)
    {
        // Visibility.
        outlets.circleBackgroundImageView.isHidden = false
        outlets.ringButton.isHidden = false
        outlets.nameImageView.isHidden = false
        outlets.nameTextField.isHidden = false
        outlets.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = true }
        
        // Apply finishes color.
        outlets.ringButton.contentTintColor = NSColor.darkGray
        outlets.nameImageView.contentTintColor = NSColor.darkGray
        
        // Set name.
        outlets.nameTextField.stringValue = player.name
    }
    
    func layout(for player: Model.Player)
    {
        // Visibility.
        outlets.circleBackgroundImageView.isHidden = false
        outlets.ringButton.isHidden = false
        outlets.nameImageView.isHidden = false
        outlets.nameTextField.isHidden = false
        outlets.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = false }
        
        // Layout finishes color.
        var finishesColor = NSColor.lightGray
        if
            let finishes = player.sharkScope.statistics?.byPositionPercentage.trendLine.slope,
            player.stack > 0.0
        { finishesColor = ColorRanges.finishes.color(for: finishes) }
        
        // Apply finishes color.
        outlets.ringButton.contentTintColor = finishesColor
        outlets.nameImageView.contentTintColor = finishesColor
        
        // Set name.
        outlets.nameTextField.stringValue = player.name
        
        // Tables.
        outlets.tablesTextField.integerValue = Int.random(in: 1...40)
        
        // Statistics.
        outlets.vpipTextField.floatValue = Float.random(in: 0...1)
        outlets.vpipTextField.toolTip = "\(Int.random(in: 0...100))/\(Int.random(in: 0...100))"
        outlets.pfrTextField.floatValue = Float.random(in: 0...1)
        outlets.pfrTextField.toolTip = "\(Int.random(in: 0...100))/\(Int.random(in: 0...100))"
        outlets.handsTextField.integerValue = Int.random(in: 0...200)
        
        // M.
        outlets.mTextField.integerValue = Int.random(in: 5...50)
        outlets.mHandsTextField.integerValue = Int.random(in: 0...200)
    }
    
    
    // MARK: - Layout Scale
    
    func scale(to scale: CGFloat)
    {
        if let seatView = view as? SeatView
        { seatView.scale(to: scale) }
    }
    
}
