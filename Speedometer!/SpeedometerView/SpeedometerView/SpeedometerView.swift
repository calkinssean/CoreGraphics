//
//  SpeedometerView.swift
//  SpeedometerView
//
//  Created by Sean Calkins on 12/8/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class SpeedometerView: UIView {

    @IBInspectable var speedoColor: UIColor = .black
    @IBInspectable var maxSpeed: Int = 100
    @IBInspectable var currentSpeed = 50 {
        didSet {
            
            self.rotateNeedleToCurrentSpeed()
            self.updateLabel()
            
        }
        
    }
   
    var speedLabel = UILabel()
    var timer = Timer()
    
    var animating = false
   
    let π = CGFloat(Double.pi)
    
    let needleLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.addSublayer(needleLayer)
        layer.addSublayer(circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let path = createNeedlePath()
        
        needleLayer.path = path.cgPath
        needleLayer.fillColor = UIColor.red.cgColor
       
        needleLayer.bounds = bounds
        needleLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let circlePath = createInnerCirclePath()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = speedoColor.cgColor
        
      //  rotateNeedleToZeroPosition()
        
    }
    
    func createInnerCirclePath() -> UIBezierPath {
        
        let circleSize = max(self.bounds.width, self.bounds.height) / 15
        let width = self.bounds.width
        let height = self.bounds.height
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: width / 2 - circleSize / 2, y: height / 2 - circleSize / 2, width: circleSize, height: circleSize))
        
        return circlePath
        
    }
    
    func createNeedlePath() -> UIBezierPath {
        
        let needleWidth = frame.width * 0.024
        let needleHeight = frame.height * 0.3
        
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        let needlePath = UIBezierPath()
        
        needlePath.move(to: CGPoint(x: centerX, y: centerY - needleHeight))
        needlePath.addLine(to: CGPoint(x: centerX - needleWidth / 2 , y: centerY))
        needlePath.addLine(to: CGPoint(x: centerX + needleWidth / 2, y: centerY))
        needlePath.addLine(to: CGPoint(x: centerX, y: centerY - needleHeight))

        return needlePath
    }

    
    override func draw(_ rect: CGRect) {
        
     //   self.needle.removeFromSuperview()
        self.speedLabel.removeFromSuperview()
        
        let width = rect.width
        let height = rect.height
        
        let labelWidth = width / 2.5
        let labelHeight = height / 3
        
        let arcWidth: CGFloat = 5

        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        let speedFontSize = (width / 5)
        let speedFont = UIFont(name: "Arial", size: CGFloat(speedFontSize))
        
        let center = CGPoint(x: width/2, y: height/2)
        
        let outerRingPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.speedLabel = UILabel(frame: CGRect(x: width / 2  - labelWidth / 2, y: height - labelHeight - 8, width: labelWidth, height: labelHeight))
        self.speedLabel.textAlignment = .center
        self.speedLabel.text = "\(self.currentSpeed)"
        self.speedLabel.font = speedFont!
        
        self.addSubview(speedLabel)
        
        outerRingPath.lineWidth = arcWidth
        speedoColor.setStroke()
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
        
    }
    
}

extension SpeedometerView {
    
    func rotateNeedleToZeroPosition() {
        
        let zeroPosition = 5 * π / 4
        
        let transform = CGAffineTransform(rotationAngle: zeroPosition)
       
        UIView.animate(withDuration: 0.1, animations: {
            self.needleLayer.setAffineTransform(transform)
        })
        
    }
    
    func rotateNeedleToCurrentSpeed() {
        
        let zeroPosition = 5 * π / 4
        
        let allowedRotationRadians = 3 * π / 2
        
        let anglePerMPH = allowedRotationRadians / CGFloat(maxSpeed)
        
        let currentSpeedPosition = zeroPosition + CGFloat(currentSpeed) * anglePerMPH
        
        let rotate = CGAffineTransform(rotationAngle: currentSpeedPosition)
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            self.needleLayer.setAffineTransform(rotate)
            
        }, completion: nil)
        
    }
    
    func updateLabel() {
        
        self.speedLabel.text = "\(self.currentSpeed)"
        
    }
    
    
    func changeSpeed(to newSpeed: Int) {
        
        if !self.animating {
            
            self.animating = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: {
                _ in
                
                if newSpeed == self.currentSpeed {
                    self.timer.invalidate()
                    self.animating = false
                }
                
                if newSpeed > self.currentSpeed {
                    
                    self.currentSpeed += 1
                    
                }
                
                if newSpeed < self.currentSpeed {
                    
                    self.currentSpeed -= 1
                    
                }
                
            })
            
        }
        
    }
  
}



