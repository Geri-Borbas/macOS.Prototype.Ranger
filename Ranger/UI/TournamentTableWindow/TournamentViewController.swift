//
//  TourneyViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class TournamentViewController: NSViewController
{

    
    // MARK: - UI
    
    weak var playersTable: PlayersTableViewController?
    weak var tableOverlay: TableOverlayViewController?
    
    @IBOutlet weak var summaryLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    
    
    // MARK: - Model
    
    @IBOutlet weak var viewModel: TournamentViewModel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // View model hook.
        viewModel.delegate = self
        
        // Fetch SharkScope status.
        viewModel.fetchSharkScopeStatus{ _ in self.layoutStatus() }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        // Wire up child view controller references.
        switch segue.destinationController
        {
            case let playersTableViewController as PlayersTableViewController:
                self.playersTable = playersTableViewController
                self.playersTable?.delegate = self
            case let tableOverlayViewController as TableOverlayViewController:
                self.tableOverlay = tableOverlayViewController
                self.tableOverlay?.delegate = self
            default:
                break
        }
    }
    
    
    // MARK: - Hooks
    
    func update(with tableWindowInfo: TableWindowInfo)
    {
        // Inject into view model (may push back changes if any).
        viewModel.update(with: tableWindowInfo)
        
        // UI.
        alignWindow(to: tableWindowInfo)
    }
    
    func alignWindow(to tableWindowInfo: TableWindowInfo)
    {        
        // Only if any.
        guard let window = self.view.window
        else { return }
        
        // Align.
        window.setFrame(tableWindowInfo.UIKitBounds, display: true)
        window.order(NSWindow.OrderingMode.above, relativeTo: tableWindowInfo.number)
        
        // Disable drag.
        window.isMovable = false
    }
    
    
    // MARK: - User Events
    
    @IBAction func fetchAllDidClick(_ sender: AnyObject)
    {
        // Checks.
        guard let playersTableViewController = self.playersTable else { return }
                
        // Fetch SharkScope for all (gonna push changes back each).
        for eachRow in 0...playersTableViewController.tableView.numberOfRows
        { playersTableViewController.viewModel.fetchSharkScopeStatisticsForPlayer(inRow: eachRow) }
    }
    
    
    // MARK: - Layout
    
    func layout()
    {
        // Summary.
        let summary = viewModel.summary(with: summaryLabel.font!)
        summaryLabel.attributedStringValue = summary
        
        // Players.
        playersTable?.tableView.reloadData()
    }
    
    func layoutStatus()
    {
        // Window tracking.
        var windowStatus = ""
        if let tournamentInfo = viewModel.tournamentInfo
        { windowStatus = "Tracking tournament \(tournamentInfo.tournamentNumber) table \(tournamentInfo.tableNumber). " }
        
        // PokerTracker.
        let pokerTrackerStatus = (viewModel.latestProcessedHandNumber == "") ? "" : "Hand #\(viewModel.latestProcessedHandNumber) processed. "
        
        // Composite (with SharkScope)
        statusLabel.stringValue = "\(windowStatus)\(pokerTrackerStatus)\(viewModel.sharkScopeStatus)"
    }
    
    func updateWindowShadow()
    {
        // Only if any.
        guard let window = self.view.window
        else { return }
        
        window.invalidateShadow()
    }
}


// MARK: - Tournament Events

extension TournamentViewController: TournamentViewModelDelegate
{
    
    
    func tournamentPlayersDidChange(tournamentPlayers: [Model.Player])
    {
        playersTable?.update(with: tournamentPlayers)
        updateWindowShadow()
    }
    
    func tournamentDidChange(tournamentInfo: TournamentInfo)
    {
        playersTable?.update(with: tournamentInfo)
        updateWindowShadow()
    }
}


// MARK: - Players Table View Controller Events

extension TournamentViewController: PlayersTableViewControllerDelegate
{
    
    
    func playersTableDidChange()
    {
        layout()
        
        // Update overlay with processed player data.
        if
            let players = playersTable?.viewModel.players,
            let tournamentInfo = playersTable?.viewModel.tournamentInfo
        {
            tableOverlay?.update(with: players, tournamentInfo: tournamentInfo)
            updateWindowShadow()
        }
        
        // Fetch SharkScope status.
        viewModel.fetchSharkScopeStatus{ _ in self.layoutStatus() }
    }
}


// MARK: - Table Overlay Events

extension TournamentViewController: TableOverlayViewControllerDelegate
{
    
    
    func seatDidClick(seatViewController: SeatViewController)
    { playersTable?.selectRow(at: seatViewController.seat) }
}
