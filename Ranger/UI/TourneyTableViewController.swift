//
//  ViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics
// import SwiftUI


class TourneyTableViewController: NSViewController, NSComboBoxDelegate
{

    
    // MARK: - UI Outlets
    
    @IBOutlet weak var tablesComboBox: NSComboBox!
    @IBOutlet weak var blindsLabel: NSTextField!
    @IBOutlet weak var stacksLabel: NSTextField!
    @IBOutlet weak var playersTableView: NSTableView!
    
    
    // MARK: - Model Outlets
    
    @IBOutlet weak var viewModel: TourneyTableViewModel!
    
    
    // MARK: - Events
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Kick off updates.
        viewModel.start(onChange:
        {
            self.layoutTableSelector()
            self.layoutTableSummary()
            self.playersTableView.reloadData()
        })
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification)
    {
        guard let comboBox: NSComboBox = (notification.object as? NSComboBox)
        else { return }
        
        // Select model.
        viewModel.selectedTableIndex = comboBox.indexOfSelectedItem
        
        // Log.
        print("comboBox.indexOfSelectedItem: \(comboBox.indexOfSelectedItem)")
    }
    
    
    // MARK: - Layout
    
    func layoutTableSelector()
    {
        // Add tables (move down to ViewModel using ComboBoxDataSource delegates).
        tablesComboBox.removeAllItems()
        tablesComboBox.addItems(withObjectValues: viewModel.tables)
        tablesComboBox.selectItem(at: 0)
    }
    
    func layoutTableSummary()
    {
        let tableSummary = viewModel.tableSummary(for: tablesComboBox.indexOfSelectedItem, font: blindsLabel.font!)
        blindsLabel.attributedStringValue = tableSummary.blinds
        stacksLabel.attributedStringValue = tableSummary.stacks
    }
}

