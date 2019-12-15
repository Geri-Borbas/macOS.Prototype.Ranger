//
//  Watcher.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 15..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


struct Window
{
    
    
    let name: String
    let number: Int
    let bounds: CGRect
}


class Watcher
{
    
    
    var running: Bool = true
    var windows: [Window] = []
    
    
    func start()
    {
        // let interval = 2.0 // 1.0 / 60.0
        // let timer = Timer(timeInterval: interval, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        // RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
       
        let queue = DispatchQueue.global(qos: .background) // (label: "loop")   
        // queue.qos = .bac
        queue.async
        {
            while self.running
            {
                Thread.sleep(forTimeInterval: 1.0 / 60.0)
                DispatchQueue.main.async()
                { self.tick() }
            }
        }
    }
    
    // @objc
    func tick()
    {
        updateWindows()
        
        // Only with Tournament Lobby Window.
        guard let tournamentLobbyWindow = windows.first else
        { return }
                
        // Align.
        let alignedBounds = CGRect.init(
            x: tournamentLobbyWindow.bounds.minX,
            y: NSScreen.main!.frame.size.height - tournamentLobbyWindow.bounds.minY - tournamentLobbyWindow.bounds.size.height,
            width: tournamentLobbyWindow.bounds.size.width,
            height: tournamentLobbyWindow.bounds.size.height
        )
        
        NSApplication.shared.mainWindow?.setFrameTopLeftPoint(alignedBounds.origin)
    }
    
    func updateWindows()
    {
        // Get windows.
        let windowInfoList = CGWindowListCopyWindowInfo(CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly), kCGNullWindowID) as! [[String:Any]]
        
        // Filter PokerStars Tournament Lobby windows.
        windows = windowInfoList.filter
        {
            (eachWindowInfo: [String:Any]) in
            (
                eachWindowInfo["kCGWindowOwnerName"] as! String == "PokerStarsEU" &&
                (eachWindowInfo["kCGWindowName"] as! String).contains("Tournament") &&
                (eachWindowInfo["kCGWindowName"] as! String).contains("Lobby")
            )
        }
        .map
        {
            eachPokerStarsWindowInfo in
            Window(
                name: eachPokerStarsWindowInfo["kCGWindowName"] as! String,
                number: eachPokerStarsWindowInfo["kCGWindowNumber"] as! Int,
                bounds: CGRect.init(dictionaryRepresentation:(eachPokerStarsWindowInfo["kCGWindowBounds"] as! CFDictionary)) ?? CGRect()
            )
        }
    }
}

//    [
//        "kCGWindowMemoryUsage": 1248,
//        "kCGWindowAlpha": 1,
//        "kCGWindowIsOnscreen": 1,
//        "kCGWindowSharingState": 1,
//        "kCGWindowStoreType": 1,
//        "kCGWindowName": PokerStars Lobby,
//        "kCGWindowOwnerPID": 63403,
//        "kCGWindowNumber": 3929,
//        "kCGWindowOwnerName": PokerStarsEU,
//        "kCGWindowLayer": 0,
//        "kCGWindowBounds":
//        {
//            Height = 869;
//            Width = 1110;
//            X = 75;
//            Y = 46;
//        }
//    ]
//
