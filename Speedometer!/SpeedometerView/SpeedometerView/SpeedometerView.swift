//
//  SpeedometerView.swift
//  SpeedometerView
//
//  Created by Sean Calkins on 12/8/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class SpeedometerView: UIView {

    @IBInspectable var outerRingBaseColor: UIColor = .red
    @IBInspectable var maxSpeed: Int = 100
    
    @IBInspectable var currentSpeed = 50 {
        didSet {
            
            self.rotateNeedleToCurrentSpeed()
            self.updateLabel()
            
        }
        
    }
    
    var speedLabel = UILabel()
    
    var needle = UIView()
    let π = CGFloat(M_PI)
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let labelWidth = width / 3
        let labelHeight = height / 3
        
        let arcWidth: CGFloat = 5

        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        let speedFontSize = (100)
        let speedFont = UIFont(name: "Arial", size: CGFloat(speedFontSize))
        
        let center = CGPoint(x: width/2, y: height/2)
        
        let outerRingPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.speedLabel = UILabel(frame: CGRect(x: width / 2  - labelWidth / 2, y: height - labelHeight - 8, width: labelWidth, height: labelHeight))
        self.speedLabel.textAlignment = .center
        self.speedLabel.text = "test label"
        self.speedLabel.backgroundColor = .green
        self.speedLabel.font = speedFont!
        self.speedLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(speedLabel)
        
        outerRingPath.lineWidth = arcWidth
        outerRingBaseColor.setStroke()
        outerRingPath.stroke()

        // big ticks
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        
        let arcLengthPerTick = angleDifference / CGFloat(maxSpeed)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        
        let tickWidth: CGFloat = 1.0
        let bigTickSize: CGFloat = radius/25
        let smallTickSize: CGFloat = radius/50
        
        let bigTickPath = UIBezierPath(rect: CGRect(x: -tickWidth/2, y: 0, width: tickWidth, height: bigTickSize))
         let smallTickPath = UIBezierPath(rect: CGRect(x: -tickWidth/2, y: 0, width: tickWidth, height: smallTickSize))
        
        context?.translateBy(x: rect.width/2, y: rect.height/2)
        
        for i in 0...maxSpeed {
            
            context?.saveGState()
            
            let angle = arcLengthPerTick * CGFloat(i) + startAngle - π/2
            context?.rotate(by: angle)
            
            if i % 10 == 0 {
            
                context?.saveGState()
                
                context?.rotate(by: π)

                let number = "\(i)"
                
                let numberRect = CGRect(x: -15, y: -radius/2 + arcWidth + radius/20, width: 30, height: 30)
                
                // TODO: - Change font size so that it doesn't get cut off
                
                // scale font size by rect size and max speed
                let fontSize = (radius / 15) / (CGFloat(maxSpeed) * 0.01)
              
                let font = UIFont(name: "Arial", size: CGFloat(fontSize))

                
                let textStyle = NSMutableParagraphStyle()
                
                textStyle.alignment = .center
                
                let numberAttributes = [
                    NSFontAttributeName: font!,
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: textStyle
                ]
                
                number.draw(in: numberRect,
                            withAttributes:numberAttributes)
                
                context?.restoreGState()
                
            }

            if i % 5 == 0 {
                
                context?.translateBy(x: 0, y: radius/2 - (arcWidth * 1.5 + bigTickSize))
                bigTickPath.fill()
                
            } else {
                
                context?.translateBy(x: 0, y: radius/2 - (arcWidth * 1.5 + smallTickSize))
                smallTickPath.fill()
                
            }
            
            context?.restoreGState()
            
        }
        
        context?.restoreGState()
        
        self.createNeedle()
        self.rotateNeedleToZeroPosition()
        self.rotateNeedleToCurrentSpeed()
        
    }
    
}

extension SpeedometerView {
    
    func createNeedle() {
        
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        let needleWidth: CGFloat = 3
        let needleLength: CGFloat = radius * 0.3
        
        let needle = UIView(frame: CGRect(x: width/2 - needleWidth/2, y: height/2, width: needleWidth, height: needleLength))
        self.needle = needle
        needle.backgroundColor = .red
        self.addSubview(needle)
        
        let centerCircle = UIView(frame: CGRect(x: width/2 - radius/25, y: height/2 - radius/25, width: radius/12.5, height: radius/12.5))
        centerCircle.backgroundColor = .black
        centerCircle.layer.cornerRadius = radius/25
        self.addSubview(centerCircle)
        
    }
    
    func rotateNeedleToZeroPosition() {
     
        self.needle.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        self.needle.frame = CGRect(x: self.needle.frame.minX, y: self.frame.height/2, width: self.needle.frame.width, height: self.needle.frame.height)
        
        let zeroPosition = π / 4
        
        let rotate = CGAffineTransform(rotationAngle: zeroPosition)
       
        self.needle.transform = rotate
        
    }
    
    func rotateNeedleToCurrentSpeed() {
        
        let zeroPosition = π / 4
        
        let maxSpeedPosition = 7 * π / 4
        
        let anglePerMPH = (maxSpeedPosition - zeroPosition) / 100
        
        let currentSpeedPosition = zeroPosition + CGFloat(currentSpeed) * anglePerMPH
        
        let rotate = CGAffineTransform(rotationAngle: currentSpeedPosition)
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            self.needle.transform = rotate
            
        }, completion: nil)
        
    }
    
    func updateLabel() {
        
        self.speedLabel.text = "\(self.currentSpeed)"
        
    }
    
}



