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
    
    @IBOutlet weak var tableComboBox: NSComboBox!
    @IBOutlet weak var levelLabel: NSTextField!
    @IBOutlet weak var stacksLabel: NSTextField!
    @IBOutlet weak var playersTableView: NSTableView!
    
    
    // MARK: - Model Outlets
    
    @IBOutlet weak var viewModel: TourneyTableViewModel!
    
    
    // MARK: - Events
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Kick off updates.
        viewModel.start(onTick:
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
        
        print(comboBox.indexOfSelectedItem)
    }
    
    
    // MARK: - Layout
    
    func layoutTableSelector()
    {
        // Empty.
        var items: [String] = []
        
        // Lookup data.
        guard let liveTourneyTableCollection = viewModel.pokerTracker.liveTourneyTableCollection, liveTourneyTableCollection.rows.count > 0
        else
        {
            // Empty state otherwise.
            tableComboBox.removeAllItems()
            print("No live tables found.")
            return
        }
        
        // Format.
        items = liveTourneyTableCollection.rows.map(
        {
            (eachTable: LiveTourneyTable) -> String in
            String(format: "Table %d - %.0f/%.0f Ante %.0f (%d players)",
                   eachTable.id_live_table,
                   eachTable.amt_sb,
                   eachTable.amt_bb,
                   eachTable.amt_ante,
                   eachTable.cnt_players
            )
        })
        
        // Only if changed.
        if items.elementsEqual(tableComboBox.objectValues as! [String])
        { return }
        
        // Add tables.
        tableComboBox.removeAllItems()
        tableComboBox.addItems(withObjectValues: items)
        tableComboBox.selectItem(at: 0)
    }
    
    func layoutTableSummary()
    {
        // Variables.
        var smallBlind:Double = 0
        var bigBlind:Double = 0
        var ante:Double = 0
        var players:Double = 0
        
        // Check data.
        guard let liveTourneyTableCollection = viewModel.pokerTracker.liveTourneyTableCollection, liveTourneyTableCollection.rows.count > 0
        else
        {
            // Empty state otherwise.
            levelLabel.attributedStringValue = NSMutableAttributedString(string: "")
            stacksLabel.attributedStringValue = NSMutableAttributedString(string: "")
            print("No live tables found.")
            return
        }
        
        // Fetch data from first live table.
        let selectedLiveTourneyTable = liveTourneyTableCollection.rows[tableComboBox.indexOfSelectedItem]
        smallBlind = selectedLiveTourneyTable.amt_sb
        bigBlind = selectedLiveTourneyTable.amt_bb
        ante = selectedLiveTourneyTable.amt_ante
        players = Double(selectedLiveTourneyTable.cnt_players)
        
        // Model.
        let M:Double = smallBlind + bigBlind + 9 * ante
        let M_5:Double = M * 5
        let M_10:Double = M * 10
        
        // View Model.
        let M_Rounded = String(format: "%.0f", ceil(M * 100) / 100)
        let M_5_Rounded = String(format: "%.0f", ceil(M_5 * 100) / 100)
        let M_10_Rounded = String(format: "%.0f", ceil(M_10 * 100) / 100)
        
        // Format.
        let font = levelLabel.font!
        
        let lightAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.light),
            .foregroundColor : NSColor.systemGray
        ]
        
        let boldAttribute: [NSAttributedString.Key: Any]  = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold)
        ]
        
        let redAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemRed
        ]
        
        let orangeAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemOrange
            ]
        
        let yellowAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemYellow
            ]
        
        let levelString = NSMutableAttributedString(string: "")
            levelString.append(NSMutableAttributedString(string: String(format: "%.0f/%.0f", smallBlind, bigBlind), attributes:boldAttribute))
            levelString.append(NSMutableAttributedString(string: String(format: " Ante %.0f (%.0f players)", ante, players), attributes:lightAttribute))
        
        let stackString = NSMutableAttributedString(string: "")
        
            // M.
            stackString.append(NSMutableAttributedString(string: "1M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_Rounded), attributes:redAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M / bigBlind, players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 5M.
            stackString.append(NSMutableAttributedString(string: "5M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_5_Rounded), attributes:orangeAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_5 / bigBlind, 5 * players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 10M.
            stackString.append(NSMutableAttributedString(string: "10M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_10_Rounded), attributes:yellowAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_10 / bigBlind, 10 * players), attributes:lightAttribute))
        
        // Set.
        levelLabel.attributedStringValue = levelString
        stacksLabel.attributedStringValue = stackString
    }
}

