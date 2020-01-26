//
//  TableOverlayViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 24..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


protocol TableOverlayViewControllerDelegate
{
    
    
    func seatDidClick(seatViewController: SeatViewController)
    // func seatDidClick(containing player: Model.Player)
}


class TableOverlayViewController: NSViewController
{

    
    var delegate: TableOverlayViewControllerDelegate?
    
    /// `SeatViewController` instances indexed by `seat` number (1..9).
    var seats: [Int:SeatViewController] = [:]
    
    
    // MARK: - Lifecycle
     
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        guard
            let seatViewController = segue.destinationController as? SeatViewController,
            let sequeIdentifier = segue.identifier,
            let seat = Int(sequeIdentifier)
        else { return }
        
        // Inject seat index from seque identifier (set in storyboard).
        seatViewController.seat = seat
        
        // Wire up callbacks.
        seatViewController.delegate = self
        
        // Collect.
        seats[seat] = seatViewController
    }
    
    
    // MARK: - Hooks
    
    func update(with players: [Model.Player])
    {
        // Determine hero seat if any.
        guard
            let hero = players.filter({ eachPlayer in eachPlayer.isHero }).first,
            let heroSeat = hero.pokerTracker?.handPlayer?.seat
        else { return }
                
        // Remove every player from seats.
        seats.values.forEach
        { eachSeatViewController in eachSeatViewController.update(with: nil) }
        
        // Add new players.
        players.forEach
        {
            eachPlayer in
            
            // Convert PokerTracker table seat to screen seat.
            if
                let eachScreenSeat = eachPlayer.screenSeat(heroSittingAt: heroSeat),
                let eachSeatViewController = seats[eachScreenSeat]
            { eachSeatViewController.update(with: eachPlayer) }
        }
    }
    
    
    // MARK: - Layout Size
    
    override func viewDidLayout()
    {
        let scale = CGFloat(view.bounds.size.width / 953.0)
        
        // Scale seats.
        seats.values.forEach
        { eachSeatViewController in eachSeatViewController.scale(to: scale) }
    }
    
}


// MARK: - Table Overlay Events

extension TableOverlayViewController: SeatViewControllerDelegate
{
    
    
    func seatDidClick(seatViewController: SeatViewController)
    { delegate?.seatDidClick(seatViewController: seatViewController) }
}
    
    
    
