//
//  RangerTests.swift
//  RangerTests
//
//  Created by Geri Borbás on 2020. 01. 01..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest


class ThingObject: NSObject
{
        
    
    @objc dynamic var number: Int
    
    init(number: Int)
    { self.number = number }
    
    override var description: String
    { "\(number)" }
    
    override func isEqual(_ object: Any?) -> Bool
    {
        guard let thing = object as? ThingObject
        else { return false }
        
        return self.number == thing.number
    }
}

struct ThingValue: Equatable
{
    var number: Int
}


class RangerTests: XCTestCase
{

    override func setUp()
    { }

    override func tearDown()
    { }
    
    func testLinearRegression()
    {
        // Field Beaten by % of Games https://www.sharkscope.com/#Player-Statistics//networks/PokerStars/players/Oliana88
        var x: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]

        var y: [Double] = [1.2, 1.2, 1.2, 1.2, 1.2, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.3, 1.3, 1.3, 1.2, 1.3, 1.2, 1.2, 1.3, 1.2, 1.2, 1.2, 1.2, 1.3, 1.3, 1.3, 1.3, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.3, 1.3, 1.3, 1.2, 1.2, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1, 1, 1, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.7, 0.7, 0.7, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.4, 0.4, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]

        func average(_ values: [Double]) -> Double
        { return values.reduce(0, +) / Double(values.count) }

        func multiply(_ x: [Double], _ y: [Double]) -> [Double]
        { return zip(x, y).map(*) }

        func linearRegression(_ x: [Double], _ y: [Double]) -> (slope: Double, offset: Double)
        {
            let sum1 = average(multiply(x, y)) - average(x) * average(y)
            let sum2 = average(multiply(x, x)) - pow(average(x), 2)
            let slope = sum1 / sum2
            let offset = average(y) - slope * average(x)
            return (slope: slope, offset: offset)
        }

        XCTAssertTrue(
            linearRegression(x, y) == (slope: -0.008937293729372906, intercept: 1.4473333333333314)
        )
    }
    
    func testObjectSortDescriptors()
    {
        let array: [ThingObject] = [
            ThingObject(number: 1),
            ThingObject(number: 6),
            ThingObject(number: 5),
            ThingObject(number: 3),
            ThingObject(number: 4),
            ThingObject(number: 2),
        ]
        
        let ascendingSortedArray: [ThingObject] = [
            ThingObject(number: 1),
            ThingObject(number: 2),
            ThingObject(number: 3),
            ThingObject(number: 4),
            ThingObject(number: 5),
            ThingObject(number: 6),
        ]
        
        let descendingSortedArray: [ThingObject] = [
            ThingObject(number: 6),
            ThingObject(number: 5),
            ThingObject(number: 4),
            ThingObject(number: 3),
            ThingObject(number: 2),
            ThingObject(number: 1),
        ]
        
        XCTAssertTrue(
            ((array as NSArray).sortedArray(using: [NSSortDescriptor(key: "number", ascending: true)]) as! [ThingObject]).elementsEqual(
                ascendingSortedArray,
                by: { $0 == $1} ),
            "Should work."
        )
        
        XCTAssertTrue(
            ((array as NSArray).sortedArray(using: [NSSortDescriptor(key: "number", ascending: false)]) as! [ThingObject]).elementsEqual(
                descendingSortedArray,
                by: { $0 == $1} ),
            "Should work."
        )
    }
    
    func testValueSortDescriptors()
    {
        let array: [ThingValue] = [
            ThingValue(number: 1),
            ThingValue(number: 6),
            ThingValue(number: 5),
            ThingValue(number: 3),
            ThingValue(number: 4),
            ThingValue(number: 2),
        ]
        
        let ascendingSortedArray: [ThingValue] = [
            ThingValue(number: 1),
            ThingValue(number: 2),
            ThingValue(number: 3),
            ThingValue(number: 4),
            ThingValue(number: 5),
            ThingValue(number: 6),
        ]
        
        let descendingSortedArray: [ThingValue] = [
            ThingValue(number: 6),
            ThingValue(number: 5),
            ThingValue(number: 4),
            ThingValue(number: 3),
            ThingValue(number: 2),
            ThingValue(number: 1),
        ]
        
        let testAscendingSortedArray = (array as NSArray).sortedArray(using: [
            NSSortDescriptor(keyPath: \ThingValue.number, ascending: true)
        ]) as! [ThingValue]
        
        let testDescendingSortedArray = (array as NSArray).sortedArray(using: [
            NSSortDescriptor(keyPath: \ThingValue.number, ascending: false)
        ]) as! [ThingValue]
        
        XCTAssertTrue(
            ascendingSortedArray.elementsEqual(testAscendingSortedArray),
            "Should work."
        )
        
        XCTAssertTrue(
            descendingSortedArray.elementsEqual(testDescendingSortedArray),
            "Should work."
        )
    }
}
