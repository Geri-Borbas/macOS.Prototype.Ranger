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
    
    var player: Model.Player?
        
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
    
    override func rightMouseDown(with event: NSEvent)
    {
        // Only if any.
        guard
            let player = player,
            let statistics = player.pokerTracker?.statistics
        else { return }
        
        NSMenu.popUpContextMenu(
            NSMenu().with(items:
            [
                player.name,
                "-",
                statistics.VPIP.description,
                statistics.PFR.description,
                statistics.aligned.PFR.description,
                "-",
                statistics.attemptToSteal.description,
                statistics.foldToSteal.description,
                statistics.callSteal.description,
                statistics.raiseSteal.description,
                statistics.aligned.raiseSteal.description,  
            ]),
            with: event,
            for: self.view
        )
    }
    
    
    // MARK: - Hooks
    
    func update(with player: Model.Player?, tournamentInfo: TournamentInfo)
    {
        // Only if any.
        guard let player = player
        else { return layoutEmpty() }
        
        // Retain (for context menu).
        self.player = player
        
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
        view.statisticsViews.forEach{ eachStatisticsView in eachStatisticsView.isHidden = true }
        
        // Apply finishes color.
        view.ringButton.contentTintColor = NSColor.darkGray
    }
    
    func layout(for player: Model.Player, tournamentInfo: TournamentInfo)
    {
        // Cast.
        guard let view = view as? SeatView
        else { return }
        
        // Visibility.
        view.circleBackgroundImageView.isHidden = false
        view.ringButton.isHidden = false
        view.statisticsViews.forEach{ $0.isHidden = false }
        
        // Set name.
        view.ringButton.toolTip = player.name
        
        // Layout finishes color.
        var finishesColor = NSColor.lightGray
        if let finishes = player.sharkScope.statistics?.byPositionPercentage.trendLine.slope
        { finishesColor = ColorRanges.finishes.color(for: finishes) }
                
        // Apply finishes color.
        view.ringButton.contentTintColor = finishesColor
        
        // Tables.
        if let tables = player.sharkScope.tables
        {
            view.tablesTextField.isHidden = false
            view.tablesTextField.integerValue = tables
            
            let tablesColor = ColorRanges.tables.color(for: tables)
            view.tablesTextField.textColor = tablesColor
            view.tablesBox.borderColor = tablesColor
        }
        else
        {
            view.tablesTextField.isHidden = true
            view.tablesBox.isHidden = true
            
        }
        
        // PokerTracker statistics.
        if let statistics = player.pokerTracker?.statistics
        {
            view.pokerTrackerStatisticsViews.forEach{ $0.isHidden = false }
            
            // Calculations.
            let M = Float(player.stack) / tournamentInfo.orbitCost
        
            // Preflop.
            view.layoutVpip(for: Float(statistics.VPIP.value))
            view.layoutPfr(for: Float(statistics.aligned.PFR.value))
        
            // Hand count.
            view.handsTextField.integerValue = statistics.hands
        
            // M.
            let mColor = ColorRanges.M.color(for: Double(M))
            view.mTextField.floatValue = M
            view.mTextField.textColor = mColor
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
