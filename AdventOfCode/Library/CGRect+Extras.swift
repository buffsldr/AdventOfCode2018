//
//  CGRect+Extras.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/3/18.
//  Copyright © 2018 NorthPole. All rights reserved.
//

import Foundation

extension CGRect {
    
    func elemental() -> [CGRect] {
        guard width != 1 && height != 1 else { return [self] }
        var elements = [CGRect]()
        for wIndex in 0..<Int(width) {
            for hIndex in 0..<Int(height) {
                let originX = origin.x + CGFloat(wIndex)
                let originY = origin.y + CGFloat(hIndex)
                elements.append(CGRect(x: originX, y: originY, width: 1, height: 1))
            }
            
        }
        
        return elements
    }
    
}

extension CGRect: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(origin.x)
        hasher.combine(origin.y)
    }
    
}
