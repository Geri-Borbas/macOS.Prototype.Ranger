//
//  PlayersTableViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 17..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class PlayersTableViewController: NSViewController,

    PlayersTableHeaderViewDelegate,
    PlayersTableViewDelegate
{
    
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    // MARK: - Model
    
    @IBOutlet weak var viewModel: PlayersTableViewModel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Double click.
        tableView.doubleAction = #selector(tableDidDoubleClick)
    }
    
    public func update(with players: [Model.Player])
    { viewModel.update(with: players, onChange: viewModelDidChange) }
    
    
    // MARK: - Events
    
    @objc func tableDidDoubleClick()
    {
        // Skip header row double click.
        guard tableView.clickedRow > -1 else { return }
        
        // Fetch SharkScope (gonna push changes back).
        viewModel.fetchSharkScopeStatisticsForPlayer(inRow: tableView.clickedRow)
    }
    
    func tableHeaderContextMenu(for column: NSTableColumn) -> NSMenu?
    { return viewModel.tableHeaderContextMenu(for: column) }
    
    func fetchCompletedTournementsRequested(for playerName: String)
    { viewModel.fetchCompletedTournamentsForPlayer(withName: playerName) }
    
    
    // MARK: - Layout
    
    func viewModelDidChange()
    { tableView.reloadData() }
}


// MARK: - TableView Data

extension PlayersTableViewController: NSTableViewDataSource
{
    
    
    func numberOfRows(in tableView: NSTableView) -> Int
    { return viewModel.players.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Checks.
        guard let column = tableColumn else { return nil }
        guard viewModel.players.count > row else { return nil }
        
        // Get data.
        let player = viewModel.players[row]
        
        // Create / Reuse cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? PlayerCellView else { return nil }
        
        // Apply data.
        cellView.setup(with: player, in: tableColumn)
        
        // Select row if was selected before.
        if (viewModel.selectedPlayer == player)
        { tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false) }
        
        // Fade if no stack (yet hardcoded).
        if
            let rowView = tableView.rowView(atRow: row, makeIfNecessary: false),
            player.isPlaying,
            player.stack <= 0
        { rowView.alphaValue = 0.4 }
        
        return cellView
    }
}


// MARK: - TableView Events

extension PlayersTableViewController: NSTableViewDelegate
{
    
    
    // Plug custom row view.
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    { return PlayersTableRowView() }
    
    // Save selection.
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        // Checks.
        guard viewModel.players.count > row else { return false }
        
        // Get data.
        let player = viewModel.players[row]
        
        // Retain selection.
        viewModel.selectedPlayer = player
        
        return true
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor])
    {
        // Sort view model using table sort descriptors.
        viewModel.sort(using: tableView.sortDescriptors)
        
        // Update table view.
        viewModelDidChange()
    }
}
