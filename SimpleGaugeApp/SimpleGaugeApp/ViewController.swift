//
//  ViewController.swift
//  SimpleGaugeApp
//
//  Created by Sean Calkins on 12/7/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var graphView: GraphView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var tap = UITapGestureRecognizer()
    
    var isGraphViewShowing = true
    var needleImageView = UIImageView()
    var speedometerCurrentValue: Float!
    var prevAngleFactor: Float!
    var angle: Float!
    var speedometer_Timer: Timer!
    var speedometerReading = UILabel()
    var maxVal: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(handleTap))
        self.containerView.addGestureRecognizer(tap)
        
        self.counterLabel.text = String(counterView.counter)
       
        self.drawBezierPath()
        
         //addMeterViewContents()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// @IBActions
extension ViewController {
    
    func handleTap() {
        print("view tapped")
        
        if (isGraphViewShowing) {
            
            //hide Graph
            
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        } else {
            
            //show Graph
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
            
            
        }
        
        isGraphViewShowing = !isGraphViewShowing
    }
    
    @IBAction func btnPushButton(button: PushButtonView) {
        
        if !isGraphViewShowing {
            
            if button.isAddButton {
                if counterView.counter < NoOfGlasses {
                    counterView.counter += 1
                }
            } else {
                if counterView.counter > 0 {
                    counterView.counter -= 1
                }
            }
            counterLabel.text = String(counterView.counter)
            
            
        }
        
    }
    
    
    func drawBezierPath() {
        
        let path = UIBezierPath(arcCenter: self.view.center, radius: 200, startAngle: 0, endAngle: 180, clockwise: true)
        path.lineWidth = 10
        path.stroke()
        path.fill()
        
    }
    
    
}

// Speedometer Functions
extension ViewController {
    
    func addMeterViewContents() {
        
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 460))
        backgroundImageView.image = UIImage(named: "main_bg.png")
        self.view.addSubview(backgroundImageView)
        
        let meterImageView = UIImageView(frame: CGRect(x: 10, y: 40, width: self.view.frame.width - 10, height: self.view.frame.width - 10))
        meterImageView.image = UIImage(named: "meter.png")
        self.view.addSubview(meterImageView)
        
        //  Needle //
        let imgNeedle = UIImageView(frame: CGRect(x: 143, y: 155, width: 22, height: 84))
        self.needleImageView = imgNeedle
       
        self.needleImageView.layer.anchorPoint = CGPoint(x: self.needleImageView.layer.anchorPoint.x, y: self.needleImageView.layer.anchorPoint.y*2);  // Shift the Needle center point to one of the end points of the needle image.
        self.needleImageView.backgroundColor = .clear
        self.needleImageView.image = UIImage(named: "arrow.png")
        self.view.addSubview(needleImageView)
       
        // Needle Dot //
        let meterImageViewDot = UIImageView(frame: CGRect(x: 131.5, y: 175, width: 45, height: 44))
       
        meterImageViewDot.image = UIImage(named: "center_wheel.png")
        self.view.addSubview(meterImageViewDot)
     
        // Speedometer Reading //
        let tempReading = UILabel(frame: CGRect(x: 125, y: 250, width: 60, height: 30))
        self.speedometerReading = tempReading;
       
        self.speedometerReading.textAlignment = .center
        self.speedometerReading.backgroundColor = .black
        self.speedometerReading.text = "0"
        
        self.speedometerReading.textColor = UIColor(red: 114/255, green: 146/255, blue: 38/255, alpha: 1)
        self.view.addSubview(self.speedometerReading)
        
        // Set Max Value //
        self.maxVal = "100"
      
        self.rotateIt()
       
        // Set previous angle //
        self.prevAngleFactor = -118.4
        // To keep track of previous deviated angle //
        
        // Set Speedometer Value //
        self.setSpeedometerCurrentValue()

        
        
        
        
    }
    
    func rotateIt() {
        
    }
    
    func rotateNeedle() {
        
    }
    
    func setSpeedometerCurrentValue() {
        
    }
    
    func calculateDeviationAngle() {
        
    }
    
}

