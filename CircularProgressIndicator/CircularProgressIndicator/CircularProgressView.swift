//
//  CircularProgressView.swift
//  CircularProgressIndicator
//
//  Created by Sean Calkins on 12/9/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class CircularProgressView: UIView {

    @IBInspectable var unfinishedProgressColor: UIColor = .red
    @IBInspectable var finishedProgressColor: UIColor = .blue
    @IBInspectable var lineWidth: Int = 5
    
    @IBInspectable var progress: Int = 37 {
        didSet{
            
            setNeedsLayout()
            
        }
    }
    
    let π = CGFloat(M_PI)
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width/2, y: height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)/2
        
        let startAngle: CGFloat = 0
        let endAngle = (2 * π)
        
        let unfinishedProgressPath = UIBezierPath(arcCenter: center, radius: radius - CGFloat(lineWidth), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        
        unfinishedProgressColor.setStroke()
        unfinishedProgressPath.lineWidth = CGFloat(lineWidth)

        unfinishedProgressPath.stroke()
     
                let progressAngle = CGFloat(CGFloat(progress) / 100) * (2 * π)
        
        let finishedProgressPath = UIBezierPath(arcCenter: center, radius: radius - CGFloat(lineWidth), startAngle: startAngle, endAngle: progressAngle + startAngle, clockwise: true)
        
        finishedProgressColor.setStroke()
        finishedProgressPath.lineWidth = CGFloat(lineWidth)
     
        UIView.animate(withDuration: 1, animations: {
            
            finishedProgressPath.stroke()
            
        })
        
        
       
        
        
        
    }
    

}
