//
//  PushButtonView.swift
//  SimpleGaugeApp
//
//  Created by Sean Calkins on 12/7/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class PushButtonView: UIButton {

    @IBInspectable var fillColor: UIColor = .green
    @IBInspectable var isAddButton: Bool = true
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        let plusPath = UIBezierPath()
        
        plusPath.lineWidth = plusHeight
        
        // horizontal line
        plusPath.move(to: CGPoint(x: bounds.width/2 - plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        plusPath.addLine(to: CGPoint(x: bounds.width/2 + plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        
        if isAddButton {
        
        // vertical line
        plusPath.move(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 - plusWidth/2 + 0.5))
        plusPath.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + plusWidth/2 + 0.5))
            
        }
        
        UIColor.white.setStroke()
        plusPath.stroke()
        
        
    }

}
