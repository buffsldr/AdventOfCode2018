//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {
    
    class Day1: Day {
        
        let input = Day1.inputIntegers()
        
        required init() { }
        
        func part1() -> String {
            let total = input.reduce(0){ $0 + $1 } //reduce { $0 + $1 }
            
            return String(total)
        }
        
        func part2() -> String {
            let itemCircle = CircularArray(items: input)
            var localSet = Set<Int>()
            var finalAnswer = -124124
            var rollingCount = input.first!
            while finalAnswer == -124124 {
                rollingCount += itemCircle.next()
                if localSet.contains(rollingCount) {
                    finalAnswer = rollingCount
                } else {
                    localSet.insert(rollingCount)
                }
            }
            
            return String(finalAnswer)
        }
    }
    
}
