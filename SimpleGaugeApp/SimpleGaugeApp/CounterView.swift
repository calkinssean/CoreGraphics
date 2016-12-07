//
//  CounterView.swift
//  SimpleGaugeApp
//
//  Created by Sean Calkins on 12/7/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

let NoOfGlasses = 80
let π: CGFloat = CGFloat(M_PI)

@IBDesignable class CounterView: UIView {

    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <=  NoOfGlasses {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = .blue
    @IBInspectable var counterColor: UIColor = .orange
    
    override func draw(_ rect: CGRect) {
        
        
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let arcWidth: CGFloat = 76
        
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        if counter == 0 {
            return
        }
        
        // outline
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        
        let arcLengthPerGlass = angleDifference / CGFloat(NoOfGlasses)
        
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        // outer arc
        let outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
    
        
        // inner arc
        outlinePath.addArc(withCenter: center,
                                    radius: bounds.width/2 - arcWidth + 2.5,
                                    startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)

        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5
        outlinePath.stroke()
        
        
    }
  
    
}
