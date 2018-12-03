//
//  CircularArray.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/1/18.
//  Copyright © 2018 NorthPole. All rights reserved.
//

import Foundation

class CircularArray {
    
    let items: [Int]
    var currentIndex = 0
    
    func next() -> Int {
        currentIndex += 1
        
        return self[currentIndex]
    }
    
    init(items: [Int]) {
        self.items = items
    }
    
    subscript(index: Int) -> Int {
        get {
            guard index < items.count else {
                let quotient = index / items.count
                let subtractionAmount = quotient * items.count
                
                return items[index - subtractionAmount]
            }
            
            return items[index]
        }
        set(newValue) {
            // perform a suitable setting action here
        }
    }
    
}
