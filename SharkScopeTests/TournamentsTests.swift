//
//  SharkScopeTests.swift
//  SharkScopeTests
//
//  Created by Geri Borbás on 2020. 01. 19..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest

class TournamentsTests: XCTestCase
{


    func testInitFromCSVString()
    {
        let csvString =
            """
            Network, Player, Game ID, Stake, Date, Entrants, Rake, Game, Structure, Speed, Result, Position, Flags, Currency
            PokerStars,"Borbas.Geri",2785898614,3.16,2020-01-18 21:57,18,0.34,H,No Limit,Turbo,-3.16,7,,USD
            PokerStars,"Borbas.Geri",2785844664,3.19,2020-01-18 20:06,45,0.31,H,No Limit,Turbo,14.75,4,,USD
            PokerStars,"Borbas.Geri",2785786030,3.19,2020-01-18 17:53,45,0.31,H,No Limit,Turbo,-3.19,32,,USD
            """
        
        let tournaments = try? Tournaments(with: csvString)
        
        XCTAssertEqual(tournaments?.tournaments[0].GameID, "2785898614")
        XCTAssertEqual(tournaments?.tournaments[0].Stake, 3.16)
        XCTAssertEqual(tournaments?.tournaments[0].Rake, 0.34)
        XCTAssertEqual(tournaments?.tournaments[0].Entrants, 18)
        XCTAssertEqual(tournaments?.tournaments[0].Position, 7)
        XCTAssertEqual(tournaments?.tournaments[0].Result, -3.16)
    }

}
