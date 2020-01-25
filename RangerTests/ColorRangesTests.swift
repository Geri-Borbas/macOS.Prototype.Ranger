//
//  TableInfoTests.swift
//  RangerTests
//
//  Created by Geri Borbás on 2020. 01. 10..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest


class ColorRangesTests: XCTestCase
{
    

    func testDecoding()
    {
        // Decode optional.
        let colorRangesOrNil = ColorRanges(named: "Finishes.ColorRanges")
        
        XCTAssertNotNil(colorRangesOrNil)
        
        // Decode non-optional.
        let colorRanges = ColorRanges.finishes
        
        XCTAssertEqual(colorRanges.colorRanges[0].min, nil)
        XCTAssertEqual(colorRanges.colorRanges[0].max, -0.009)
        XCTAssertEqual(colorRanges.colorRanges[1].min, -0.009)
        XCTAssertEqual(colorRanges.colorRanges[1].max, -0.007)
        XCTAssertEqual(colorRanges.colorRanges[6].min, 0.007)
        XCTAssertEqual(colorRanges.colorRanges[6].max, 0.009)
        XCTAssertEqual(colorRanges.colorRanges[7].min, 0.009)
        XCTAssertEqual(colorRanges.colorRanges[7].max, nil)
    }
    
    func testColorName()
    {
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -1.0), "violet")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.01), "violet")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0091), "violet")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.009), "red")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0089), "red")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0071), "red")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.007), "orange")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0069), "orange")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0051), "orange")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.005), "yellow")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0049), "yellow")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0021), "yellow")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.002), "lime")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0019), "lime")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: -0.0001), "lime")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.000), "green")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.0001), "green")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.0069), "green")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.007), "cyan")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.0071), "cyan")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.0089), "cyan")
        
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.009), "blue")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 0.01), "blue")
        XCTAssertEqual(ColorRanges.finishes.colorName(for: 1.0), "blue")
    }
}
