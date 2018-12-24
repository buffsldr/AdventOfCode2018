//
//  DotView.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/24/18.
//  Copyright © 2018 NorthPole. All rights reserved.
//

import Foundation
import AppKit

class DotView: NSView {
    
    func drawPieChart() {
        // 1
        let rect = frame
        let circle = NSBezierPath(ovalIn: rect)
        NSColor.green.setFill()
        NSColor.blue.setStroke()
        circle.stroke()
        circle.fill()
        
        // 2
        let path = NSBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let usedPercent = 0.7
        let endAngle = CGFloat(360 * usedPercent)
        let radius = rect.size.width / 2.0
        path.move(to: center)
        path.line(to: CGPoint(x: rect.maxX, y: center.y))
        path.appendArc(withCenter: center, radius: radius,
                       startAngle: 0, endAngle: endAngle)
        path.close()
        
        // 3
        NSColor.red.setStroke()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPieChart()
        
    }
}
