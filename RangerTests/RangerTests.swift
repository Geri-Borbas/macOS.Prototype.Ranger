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
