//
//  ViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class ViewController: NSViewController, NSControlTextEditingDelegate
{

    
    @IBOutlet weak var levelLabel: NSTextField!
    @IBOutlet weak var stacksLabel: NSTextField!
    
    lazy var pokerTracker: PokerTracker = PokerTracker()
    lazy var sharkScope: SharkScope = SharkScope()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // startLiveTableMonitoring()
        
        sharkScope.test()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func startLiveTableMonitoring()
    {
        // Schedule polling.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { _ in
            print("Tick.")
            try? self.pokerTracker.fetchLiveTourneyTableCollection()
            self.layout()
        }
        
        layout()
    }
    
    @IBAction func buttonDidClick(_ sender: Any)
    {
        // https://developer.apple.com/documentation/coregraphics/1454852-cgwindowlistcreateimage?language=objc
        // https://stackoverflow.com/questions/21947646/take-screenshots-of-specific-application-window-on-mac
        
        print("Capture window content")
        
        // let screenShot:CGImage? = CGWindowListCreateImage(
        //     CGRect.null,
        //     CGWindowListOption.optionAll, // CGWindowListOption.optionIncludingWindow,
        //     CGWindowID(NSApplication.shared.mainWindow!.windowNumber),
        //     CGWindowImageOption.bestResolution)
        
        // optionAll: CGWindowListOption
        // optionOnScreenOnly: CGWindowListOption
        // optionOnScreenAboveWindow: CGWindowListOption
        // optionOnScreenBelowWindow: CGWindowListOption
        // optionIncludingWindow: CGWindowListOption
        // excludeDesktopElements: CGWindowListOption
        
        // let image = NSImage(cgImage: cgImage!, size: window.frame.size)
    }
    
    func layout()
    {
        // Variables.
        var smallBlind:Double = 0
        var bigBlind:Double = 0
        var ante:Double = 0
        var players:Double = 0
        
        // Fetch data from first live table.
        if (pokerTracker.liveTourneyTableCollection?.rows.count ?? 0 > 0)
        {
            smallBlind = pokerTracker.liveTourneyTableCollection?.rows[0].amt_sb ?? 0
            bigBlind = pokerTracker.liveTourneyTableCollection?.rows[0].amt_bb ?? 0
            ante = pokerTracker.liveTourneyTableCollection?.rows[0].amt_ante ?? 0
            players = Double(pokerTracker.liveTourneyTableCollection?.rows[0].cnt_players ?? 0)
        }
        else
        { print("No live tables found.") }
        
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
        let lightAttribute = [NSAttributedString.Key.font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.light)]
        let boldAttribute = [NSAttributedString.Key.font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.heavy)]
        
        let levelString = NSMutableAttributedString(string: "")
            levelString.append(NSMutableAttributedString(string: String(format: "%.0f/%.0f", smallBlind, bigBlind), attributes:boldAttribute))
            levelString.append(NSMutableAttributedString(string: String(format: " Ante %.0f (%.0f players)", ante, players), attributes:lightAttribute))
        
        let stackString = NSMutableAttributedString(string: "")
        
            // M.
            stackString.append(NSMutableAttributedString(string: "1M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_Rounded), attributes:boldAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M / bigBlind, players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 5M.
            stackString.append(NSMutableAttributedString(string: "5M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_5_Rounded), attributes:boldAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_5 / bigBlind, 5 * players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 10M.
            stackString.append(NSMutableAttributedString(string: "10M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_10_Rounded), attributes:boldAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_10 / bigBlind, 10 * players), attributes:lightAttribute))
        
        // Set.
        levelLabel.attributedStringValue = levelString
        stacksLabel.attributedStringValue = stackString
    }
}

