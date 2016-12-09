//
//  ViewController.swift
//  SpeedometerView
//
//  Created by Sean Calkins on 12/8/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var speedometerView: SpeedometerView!
    @IBOutlet var speedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minusTapped(_ sender: UIButton) {
        
        if self.speedometerView.currentSpeed > 0 {
        
            self.speedometerView.currentSpeed -= 1
            
        }
        
        self.changeSpeedLabel()
        
    }

    @IBAction func plusTapped(_ sender: UIButton) {
        
        if self.speedometerView.currentSpeed < self.speedometerView.maxSpeed {
        
        self.speedometerView.currentSpeed += 1
            
        }
        
        self.changeSpeedLabel()
        
    }
    
    func changeSpeedLabel() {
        
        self.speedLabel.text = "\(self.speedometerView.currentSpeed)"
        
    }
    
    

}

