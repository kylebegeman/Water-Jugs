//
//  Step.swift
//  Water Jugs
//
//  Created by Kyle on 11/25/20.
//

import Foundation

/// Simple type safe declaration for the different types of operations.
enum Operation: String {
    
    case empty
    case fill
    case pour
    
    // Convenience property for output display.
    var display: String {
        return rawValue.capitalized
    }
}

/// Simply type to encapulate all of the related data about each step.
struct SimulationStep {
    
    /// Track the type of operation to be perform at this step
    var type: Operation
    
    /// Track which step we are currently on
    var step: Int
    
    /// Track the 'from' value of the step.
    var from: Int
    
    /// Track the 'to' value of the step.
    var to: Int
    
    /// Basic calculated output string for display to the user.
    var stepOutput: String {
        return "Step \(step): \(type.display)"
    }
}
