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
    
    func update(with player: Model.Player?, tournamentInfo: TournamentInfo)
    {
        // Only if any.
        guard let player = player
        else { return layoutEmpty() }
        
        if (player.stack == 0)
        { layoutZero(for: player) }
        else
        { layout(for: player, tournamentInfo: tournamentInfo) }
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
    
    func layout(for player: Model.Player, tournamentInfo: TournamentInfo)
    {
        // Cast.
        guard let view = view as? SeatView
        else { return }
        
        // Visibility.
        view.circleBackgroundImageView.isHidden = false
        view.ringButton.isHidden = false
        view.nameImageView.isHidden = false
        view.nameTextField.isHidden = false
        view.statisticsViews.forEach{ $0.isHidden = false }
        
        // Set name.
        view.nameTextField.stringValue = player.name
        
        // Layout finishes color.
        var finishesColor = NSColor.lightGray
        if let finishes = player.sharkScope.statistics?.byPositionPercentage.trendLine.slope
        { finishesColor = ColorRanges.finishes.color(for: finishes) }
        
        // Apply finishes color.
        view.ringButton.contentTintColor = finishesColor
        view.nameImageView.contentTintColor = finishesColor
        
        // Tables.
        if let tables = player.sharkScope.tables
        {
            view.tablesTextField.isHidden = false
            view.tablesTextField.integerValue = tables
        }
        else
        { view.tablesTextField.isHidden = true }
        
        // PokerTracker statistics.
        if let statistics = player.pokerTracker?.statistics
        {
            view.pokerTrackerStatisticsViews.forEach{ $0.isHidden = false }
            
            // Calculations.
            let M = Float(player.stack) / tournamentInfo.orbitCost
            let hands = Int(M * Float(tournamentInfo.players))
        
            // Preflop.
            view.layoutVpip(for: Float(statistics.VPIP))
            view.layoutPfr(for: Float(statistics.PFR))
        
            // Hand count.
            view.handsTextField.integerValue = statistics.hands
        
            // M.
            view.mTextField.floatValue = M
            view.mHandsTextField.integerValue = hands
            view.mBox.fillColor = ColorRanges.M.color(for: Double(M))
            view.mHandsTextField.textColor = ColorRanges.M.color(for: Double(M))
            view.mBox.toolTip = "\(M) M (\(hands) hands)"
        }
        else
        { view.pokerTrackerStatisticsViews.forEach{ $0.isHidden = true } }
    }
    
    
    // MARK: - Layout Scale
    
    func scale(to scale: CGFloat)
    {
        if let seatView = view as? SeatView
        { seatView.scale(to: scale) }
    }
    
}
