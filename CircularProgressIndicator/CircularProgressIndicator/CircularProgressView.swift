//
//  CircularProgressView.swift
//  CircularProgressIndicator
//
//  Created by Sean Calkins on 12/9/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class CircularProgressView: UIView {
    
    var progressColor: UIColor = .red
  
    let π = CGFloat(M_PI)
    
    var lineWidth: Int = 5 {
        didSet {
            
            setNeedsDisplay()
            
        }
    }
    
    @IBInspectable var progress: Int = 37 {
        didSet{
        
            setNeedsDisplay()
        
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width/2, y: height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)/2
        
        let startAngle: CGFloat = 0
        let progressAngle = CGFloat(CGFloat(progress) / 100) * (2 * self.π)
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius - CGFloat(lineWidth), startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        
        progressColor.setStroke()
        progressPath.lineWidth = CGFloat(lineWidth)
        
        progressPath.stroke()
        
    }
    

  
}

