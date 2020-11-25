//
//  MainViewController.swift
//  Water Jugs
//
//  Created by Kyle on 11/25/20.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var xValueStepper: UIStepper!
    @IBOutlet var yValueStepper: UIStepper!
    @IBOutlet var zValueStepper: UIStepper!
    
    @IBOutlet var xValueLabel:UILabel!
    @IBOutlet var yValueLabel:UILabel!
    @IBOutlet var zValueLabel:UILabel!

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var runSimulationButton: UIButton!
    
    @IBOutlet var totalCapacityLeftLabel: UILabel!
    @IBOutlet var totalCapacityRightLabel: UILabel!
    @IBOutlet var jugImageX: UIImageView!
    @IBOutlet var jugImageY: UIImageView!
    
    @IBOutlet var currentVolumeLeftLabel: UILabel!
    @IBOutlet var currentVolumeRightLabel: UILabel!
    @IBOutlet var currentGoalLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    
    /// Convenience properties that convert each stepper value into an Int for running the simulation.
    private var x: Int { return Int(xValueStepper.value) }
    private var y: Int { return Int(yValueStepper.value) }
    private var z: Int { return Int(zValueStepper.value) }
    
    private var solutionSteps = [SimulationStep]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    // MARK: UIStepper Value change
    
    @IBAction func xValueDidChange(_ sender: UIStepper) {
        // Use the main thread and allow for holding down stepper button.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0)) {
            self.updateValueX()
        }
    }
    
    @IBAction func yValueDidChange(_ sender: UIStepper) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0)) {
            self.updateValueY()
        }
    }
    
    @IBAction func zValueDidChange(_ sender: UIStepper) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0)) {
            self.updateValueZ()
        }
    }
    
    @IBAction func runSimulation(_ sender: UIButton) {
        validateSolution()
    }
}

// MARK: - Setup

extension MainViewController {
    
    /// Private method for setting up any required views
    private func configureViews() {
        runSimulationButton.layer.cornerRadius = 4.0
        runSimulationButton.clipsToBounds = true
        
        statusLabel.text = "Run for Solution"
    }
}

// MARK: - Update Labels

extension MainViewController {
    
    // For each method below, simply extract the stepper value and asign it to the corresponding label.
    private func updateValueX() {
        xValueLabel.text = String(x)
        totalCapacityLeftLabel.text = "\(String(x)) Gallons"
        statusLabel.text = "Run for Solution"
    }
    
    private func updateValueY() {
        yValueLabel.text = String(y)
        totalCapacityRightLabel.text = "\(String(y)) Gallons"
        statusLabel.text = "Run for Solution"
    }
    
    private func updateValueZ() {
        zValueLabel.text = String(z)
        currentGoalLabel.text = "Goal: \(String(z)) Gallons"
        statusLabel.text = "Run for Solution"
    }
}

// MARK: Simulation

// NOTE: With more time and in the right settings, it would be better to craft the simulation as its own view controller
// and to manage it with view controller containment. For now, this view controller will manage the basic logic. Avoiding advanced
// animations to keep this view controller as lean as possible.

extension MainViewController {
    
    private func validateSolution() {
        
        /// Run the simulation and parse the results.
        PourSimulation.minSteps(xValue: x, yValue: y, goal: z) { (simulationSteps) in
            
            /// Check for no solution and update the UI accordingly.
            guard let steps = simulationSteps else {
                
                // Update proper UI in response to no solution.
                statusLabel.text = "No Solution"
                return
            }
            
            // Adjust the status text and start the simulation.
            statusLabel.text = "Solution Found!"
            startSimulation(for: steps, x: x, y: y)
        }
        
    }
    
    private func startSimulation(for steps: [SimulationStep], x: Int, y: Int) {
        
        // Track the current index as we loop through each step.
        var index = 0
        
        // Repeat every 3 seconds until we have displayed all steps.
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            
            // Process the current step.
            self.processStep(steps[index], x, y)
            
            // Increment the index.
            index = index + 1
            
            // If we have reached the end of the steps, invalidate the timer.
            if index == steps.count {
                timer.invalidate()
            }
        })
    }
    
    private func processStep(_ step: SimulationStep, _ xCapacity: Int, _ yCapacity: Int) {
        
        // Run all UI updates on the main thread.
        DispatchQueue.main.async {
            
            // Update the labels to indicate the current steps.
            self.currentVolumeLeftLabel.text = "\(step.from) Gallons"
            self.currentVolumeRightLabel.text = "\(step.to) Gallons"
            
            // Handle the 'from' jug image.
            if step.from == 0 {
                self.jugImageX.image = #imageLiteral(resourceName: "empty_jug")
            } else if step.from < xCapacity {
                self.jugImageX.image = #imageLiteral(resourceName: "partial_jug")
            } else {
                self.jugImageX.image = #imageLiteral(resourceName: "full_jug")
            }
            
            // Handle the 'to' jug image.
            if step.to == 0 {
                self.jugImageY.image = #imageLiteral(resourceName: "empty_jug")
            } else if step.to < yCapacity {
                self.jugImageY.image = #imageLiteral(resourceName: "partial_jug")
            } else {
                self.jugImageY.image = #imageLiteral(resourceName: "full_jug")
            }
            
            // Output the step string constructed internally.
            self.currentStepLabel.text = step.stepOutput
        }
    }
}
