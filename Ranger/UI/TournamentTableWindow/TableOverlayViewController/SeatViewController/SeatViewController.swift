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
        // Cast.
        guard let view = view as? SeatView
        else { return }
        
        // Visibility.
        view.circleBackgroundImageView.isHidden = true
        view.ringButton.isHidden = true
        view.nameImageView.isHidden = true
        view.nameTextField.isHidden = true
        view.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = true }
    }
    
    func layoutZero(for player: Model.Player)
    {
        // Cast.
        guard let view = view as? SeatView
        else { return }
        
        // Visibility.
        view.circleBackgroundImageView.isHidden = false
        view.ringButton.isHidden = false
        view.nameImageView.isHidden = false
        view.nameTextField.isHidden = false
        view.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = true }
        
        // Apply finishes color.
        view.ringButton.contentTintColor = NSColor.darkGray
        view.nameImageView.contentTintColor = NSColor.darkGray
        
        // Set name.
        view.nameTextField.stringValue = player.name
    }
    
    func layout(for player: Model.Player)
    {
        // Cast.
        guard let view = view as? SeatView
        else { return }
        
        // Visibility.
        view.circleBackgroundImageView.isHidden = false
        view.ringButton.isHidden = false
        view.nameImageView.isHidden = false
        view.nameTextField.isHidden = false
        view.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = false }
        
        // Layout finishes color.
        var finishesColor = NSColor.lightGray
        if
            let finishes = player.sharkScope.statistics?.byPositionPercentage.trendLine.slope,
            player.stack > 0.0
        { finishesColor = ColorRanges.finishes.color(for: finishes) }
        
        // Apply finishes color.
        view.ringButton.contentTintColor = finishesColor
        view.nameImageView.contentTintColor = finishesColor
        
        // Set name.
        view.nameTextField.stringValue = player.name
        
        // Tables.
        view.tablesTextField.integerValue = Int.random(in: 1...40)
        
        // Statistics.
        let vpip = Float.random(in: 0...1)
        let pfr = Float.random(in: 0...1)
        let m = Int.random(in: 1...180)
        let hands = Int.random(in: 0...200)
        
        view.layoutVpip(for: vpip)
        view.layoutPfr(for: pfr)
        
        // Hand count.
        view.handsTextField.integerValue = Int.random(in: 0...200)
        
        // M.
        view.mTextField.integerValue = m
        view.mHandsTextField.integerValue = hands
        view.mBox.toolTip = "\(m) M (\(hands) hands)"
    }
    
    
    // MARK: - Layout Scale
    
    func scale(to scale: CGFloat)
    {
        if let seatView = view as? SeatView
        { seatView.scale(to: scale) }
    }
    
}
