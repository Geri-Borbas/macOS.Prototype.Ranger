//
//  Watcher.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 15..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


struct WindowInfo
{
    
    
    var name: String
    var number: Int
    var bounds: CGRect
}


class WindowTracker
{
    
    
    public var tickCount: Int = 0
    public var firstTourneyLobbyWindowInfo: WindowInfo?
    private var appWindow: NSWindow = NSWindow()
    
    
    // MARK: - Binds
    
    private var onTick: (() -> Void)?
    
    
    func start(onTick: @escaping (() -> Void))
    {
        // Retain.
        self.onTick = onTick
        
        // Get app window.
        self.appWindow = NSApplication.shared.windows.first!
        
        // Kickoff timer.
        let interval = 1.0 / 60.0
        let timer = Timer(timeInterval: interval, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    
    // MARK: - Window lookup
    
    func searchFirstTourneyLobbyWindowInfo() -> WindowInfo?
    {
        // Get windows.
        let windowInfoList = CGWindowListCopyWindowInfo(
            CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly),
            kCGNullWindowID
        ) as! [[String:Any]]
        
        // Filter PokerStars Tournament Table windows.
        let tourneyLobbyWindows = windowInfoList.filter
        {
            (eachWindowInfo: [String:Any]) in
            (
                (eachWindowInfo["kCGWindowOwnerName"] as? String) == "PokerStarsEU" &&
                (eachWindowInfo["kCGWindowName"] as? String)?.contains("Tournament") ?? false &&
                (eachWindowInfo["kCGWindowName"] as? String)?.contains("Table") ?? false &&
                (eachWindowInfo["kCGWindowName"] as? String)?.contains("Logged In") ?? false
            )
        }
        .map
        {
            eachPokerStarsWindowInfo in
            WindowInfo(
                name: eachPokerStarsWindowInfo["kCGWindowName"] as! String,
                number: eachPokerStarsWindowInfo["kCGWindowNumber"] as! Int,
                bounds: CGRect.init(dictionaryRepresentation:(eachPokerStarsWindowInfo["kCGWindowBounds"] as! CFDictionary)) ?? CGRect()
            )
        }
        
        // Only with Tournament Lobby Window.
        guard let firstTourneyLobbyInfo = tourneyLobbyWindows.first
        else { return nil }
        
        return firstTourneyLobbyInfo
    }
    
    
    // MARK: - Window align
    
    @objc func tick()
    {
        firstTourneyLobbyWindowInfo = searchFirstTourneyLobbyWindowInfo()
        
        // Align App Window if Lobby Window any.
        if let lobbyWindowInfo = firstTourneyLobbyWindowInfo
        {
            let convertedBounds = CGRect.init(
                x: lobbyWindowInfo.bounds.minX,
                y: NSScreen.main!.frame.size.height - lobbyWindowInfo.bounds.minY - lobbyWindowInfo.bounds.size.height,
                width: lobbyWindowInfo.bounds.size.width,
                height: lobbyWindowInfo.bounds.size.height
            )
            
            appWindow.setFrame(
                NSRect(
                    x: convertedBounds.origin.x,
                    y: convertedBounds.origin.y - appWindow.frame.size.height,
                    width: convertedBounds.size.width,
                    height: appWindow.frame.size.height
                ),
                display: true
            )
            
            // Put above.
            appWindow.order(NSWindow.OrderingMode.above, relativeTo: lobbyWindowInfo.number)
            
            // Prevent dragging.
            appWindow.isMovable = false
        }
        else
        {
            // Enable dragging.
            appWindow.isMovable = true
        }
        
        // Callback.
        onTick?()
    }
}
