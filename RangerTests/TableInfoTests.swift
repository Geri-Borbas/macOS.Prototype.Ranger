//
//  TableInfoTests.swift
//  RangerTests
//
//  Created by Geri Borbás on 2020. 01. 10..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest


class TableInfoTests: XCTestCase
{
    

    func testTourneyNumber()
    {
        XCTAssertEqual(
            TableInfo(
                name: "$3.50 NL Hold'em [18 Players, Turbo] - 400/800 ante 50 - Tournament 2770350462 Table 2 - Logged In as Borbas.Geri"
            ),
            TableInfo(
                tournamentNumber: "2770350462",
                tableNumber: 2,
                smallBlind: 400,
                bigBlind: 800,
                ante: 50
            )
        )
    }

    func testTourneyNameWithHyphen_1()
    {
        XCTAssertEqual(
            TableInfo(
                name: "$7.00 NL Hold'em [27 - 180 Players, Turbo] - 50/100 ante 12 - Tournament 2773752330 Table 11 - Logged In as Borbas.Geri"
            ),
            TableInfo(
                tournamentNumber: "2773752330",
                tableNumber: 11,
                smallBlind: 50,
                bigBlind: 100,
                ante: 12
            )
        )
    }


    func testTourneyNameWithHyphen_2()
    {
        XCTAssertEqual(
            TableInfo(
                name: "$11 NLHE [8-Max, Turbo], $1K Gtd - 50/100 ante 12 - Tournament 2773752330 Table 11 - Logged In as Borbas.Geri"
            ),
            TableInfo(
                tournamentNumber: "2773752330",
                tableNumber: 11,
                smallBlind: 50,
                bigBlind: 100,
                ante: 12
            )
        )
    }

    func testBlindsThousandSeparator()
    {
        XCTAssertEqual(
            TableInfo(
                name: "$3.50 NL Hold'em [45 Players, Turbo] - 600/1,200 ante 75 - Tournament 2779703376 Table 1 - Logged In as Borbas.Geri"
            ),
            TableInfo(
                tournamentNumber: "2779703376",
                tableNumber: 1,
                smallBlind: 600,
                bigBlind: 1200,
                ante: 75
            )
        )
    }

    func testAnteThousandSeparator()
    {
        XCTAssertEqual(
            TableInfo(
                name: "Hot $16.50 $8K Gtd - 4,000/8,000 ante 1,000 - Tournament 2773758656 Table 12 - Logged In as Borbas.Geri"
            ),
            TableInfo(
                tournamentNumber: "2773758656",
                tableNumber: 12,
                smallBlind: 4000,
                bigBlind: 8000,
                ante: 1000
            )
        )
    }
}
