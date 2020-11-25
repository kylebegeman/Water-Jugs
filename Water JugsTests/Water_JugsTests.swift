//
//  Water_JugsTests.swift
//  Water JugsTests
//
//  Created by Kyle on 11/25/20.
//

import XCTest
@testable import Water_Jugs

class Water_JugsTests: XCTestCase {
    
    var steps = [SimulationStep]()

    /// Check if the 'PourSimulation' logic works as expected.
    func testValidPourSequence() throws {
        let x = 5; let y = 3; let z = 4
        
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (steps) in
            XCTAssertNotNil(steps)
            XCTAssert(steps!.count == 6)
        }
    }
    
    /// Check that we handle non-solution values appropriately.
    func testInvalidPourSequence() throws {
        let x = 7; let y = 3; let z = 10
        
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (steps) in
            XCTAssertNil(steps)
        }
    }
    
    /// Check that we can handle large values for each parameter.
    func testLargeValuePourSequence() throws {
        let x = 57; let y = 32; let z = 10
        
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (steps) in
            XCTAssertNotNil(steps)
            XCTAssert(steps!.count == 32)
        }
    }
    
    /// Check that the proper operation is attached to each step.
    func testValidPourOperation() throws {
        let x = 5; let y = 3; let z = 4
        
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (steps) in
            XCTAssertNotNil(steps)
            
            // We now know this is not nil; force unwrap for cleaner testing below.
            let allSteps = steps!
            
            XCTAssert(allSteps[0].type == .fill)
            XCTAssert(allSteps[1].type == .pour)
            XCTAssert(allSteps[2].type == .empty)
            XCTAssert(allSteps[3].type == .pour)
            XCTAssert(allSteps[4].type == .fill)
            XCTAssert(allSteps[5].type == .pour)
        }
    }
    
    /// Check that all numerical values for each step are correct.
    func testValidPourValues() throws {
        
        let x = 5; let y = 3; let z = 4
        
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (steps) in
            XCTAssertNotNil(steps)
            
            // We now know this is not nil; force unwrap for cleaner testing below.
            let allSteps = steps!
            
            XCTAssert(allSteps[0].from == 5 && allSteps[0].to == 0)
            XCTAssert(allSteps[1].from == 2 && allSteps[1].to == 3)
            XCTAssert(allSteps[2].from == 2 && allSteps[2].to == 0)
            XCTAssert(allSteps[3].from == 0 && allSteps[3].to == 2)
            XCTAssert(allSteps[4].from == 5 && allSteps[4].to == 2)
            XCTAssert(allSteps[5].from == 4 && allSteps[5].to == 3)
        }
    }

}
