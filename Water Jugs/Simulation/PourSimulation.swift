//
//  Logic.swift
//  Water Jugs
//
//  Created by Kyle on 11/25/20.
//

import Foundation

final class PourSimulation {
    
    // Simple typealias for better readability.
    typealias Result = ([SimulationStep]?) -> Void
        
    /// Run through the pour operation to calculate steps for working through the problem.
    /// - Parameters:
    ///   - fromValue: value of the jug being poured 'from'
    ///   - toValue: value of the jug being poured 'to'
    ///   - goal: the amount to be tested against
    /// - Returns: the number of steps required to reach a solution.
    private static func pour(fromValue: Int, toValue: Int, goal: Int) -> [SimulationStep] {
       
        // Initialize the starting values.
        var from = fromValue
        var to = 0
        var step = 1
        
        // Initialize our step array and add the first step.
        var steps = [SimulationStep(type: .fill, step: step, from: from, to: to)]
        
        // Continue the loop until one of the jugs contains the goal value.
        while (from != goal && to != goal) {
            
            // Calculate the maximum amount that can be poured.
            let temp = min(from, toValue - to)
            
            // Pour 'temp' liters and increment the step count.
            to += temp
            from -= temp
            
            // Increpent the step and append a new SimulationStep
            step = step + 1
            steps.append(SimulationStep(type: .pour, step: step, from: from, to: to))
                        
            // Check if we reached our goal.
            if (from == goal || to == goal) {
                break
            }
            
            // When the first jug is empty, fill it and increment our step count.
            if (from == 0) {
                from = fromValue
                step = step + 1
                
                steps.append(SimulationStep(type: .fill, step: step, from: from, to: to))
            }
            
            // When the second jug is full, empty it and increment our step count.
            if (to == toValue) {
                to = 0
                step = step + 1
                
                steps.append(SimulationStep(type: .empty, step: step, from: from, to: to))
            }
        }
        
        return steps
    }
    
    /// Determines the minimum number of steps for a solution, or returns no solution.
    /// - Parameters:
    ///   - xValue: jug x value
    ///   - yValue: jug y value
    ///   - goal: goal value
    ///   - result: result containing total number of steps and the steps to be taken. -1 steps for no solution.
    static func minSteps(xValue: Int, yValue: Int, goal: Int, result: Result) {
        
        // Extract the passed in values into mutable containers.
        var x: Int = xValue
        var y: Int = yValue

        // Validate that we are using non-zero jugs, otherwise no solution.
        if (y == 0) && (x == 0) {
            result(nil)
            return
        }

        // Check that x is smaller than y.
        if (x > y) {
            // Swap values so that x is smaller than y.
            swap(&x, &y)
        }

        // If z is greater than y, we are unable to measure; no solution.
        if (goal > y){
            result(nil)
            return
        }
        
        // Validate that the gcd of y and x divide by z, otherwise no solution.
        if ((goal % gcd(a: y,b: x)) != 0){
            result(nil)
            return
        }
        
        let standard = pour(fromValue: x, toValue: y, goal: goal)
        let reversed = pour(fromValue: y, toValue: x, goal: goal)
        let minSteps = standard.count < reversed.count ? standard : reversed

        result(minSteps)
    }
    
}

// MARK: - Utilities

extension PourSimulation {
    
    /// Utility function to find the greatest common denominator (gcd) of 'a' and 'b'
    ///
    /// - Parameters:
    ///   - a: first value for comparison
    ///   - b: second value for comparison.
    /// - Returns: gcd as an 'Int' value
    private static func gcd(a: Int, b: Int) -> Int {
        if b == 0 {
            return a
        }
        
        return gcd(a: b, b: a%b)
    }
}
