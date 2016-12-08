//
//  GraphView.swift
//  SimpleGaugeApp
//
//  Created by Sean Calkins on 12/7/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    var graphPoints: [Int] = [4, 2, 6, 4, 5, 8, 3]
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        
        
        path.addClip()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
     
        guard let context = UIGraphicsGetCurrentContext(), let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations) else {
            print("no context or gradient")
            return
        }
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        // calculate x point
        let margin: CGFloat = 20.0
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacer = (width - margin * 2 - 4) /
            CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate y point
        let topBorder: CGFloat = 60
        let bottomBorder: CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else { return }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) /
             CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                   y:columnYPoint(graphPoints[0])))
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        context.saveGState()
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        context.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            
            circle.fill()
            
            
            //Draw horizontal graph lines on the top of everything
            let linePath = UIBezierPath()
            
            //top line
            linePath.move(to: CGPoint(x:margin, y: topBorder))
            linePath.addLine(to: CGPoint(x: width - margin,
                                            y:topBorder))
            
            //center line
            linePath.move(to: CGPoint(x:margin,
                                         y: graphHeight/2 + topBorder))
            linePath.addLine(to: CGPoint(x:width - margin,
                                            y:graphHeight/2 + topBorder))
            
            //bottom line
            linePath.move(to: CGPoint(x:margin,
                                         y:height - bottomBorder))
            linePath.addLine(to: CGPoint(x:width - margin,
                                            y:height - bottomBorder))
            let color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
            
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
            
        }
        
    }
    
    
}
