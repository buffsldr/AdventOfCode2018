//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
//
//class Pot {
//
//    var hasPlant: Bool
//    let index: Int
//
//    init(index: Int, hasPlant: Bool) {
//        self.hasPlant = hasPlant
//        self.index = index
//    }
//
//    var previousPot: Pot?
//    var nextPot: Pot?
//
//    func pot(atOffset offset: Int) -> Pot {
//        var result = self
//        for _ in 0..<offset.magnitude {
//            result = offset > 0 ? result.nextPot! : result.previousPot!
//        }
//        return result
//    }
//
//    func insert(between left: Pot?, and right: Pot?) {
//        let leftPot = left ?? Pot(index: index - 1, hasPlant: false)
//        let rightPot = right ?? Pot(index: index + 1, hasPlant: false)
//
//        leftPot.nextPot = self
//        previousPot = leftPot
//        rightPot.previousPot = self
//        nextPot = rightPot
//    }
//
//    var pattern: String {
//        let left = leftEnvironment.map{ $0.hasPlant ? "#" : "." }
//        let right = rightEnvironment.map{ $0.hasPlant ? "#" : "." }
//        let total = left + [(hasPlant ? "#" : ".")] + right
//
//        return total.reduce("", { (rollingString, localString) -> String in
//            return rollingString + localString
//        })
//    }
//
//    var leftEnvironment: [Pot] {
//        let potL1 = previousPot ?? Pot(index: index - 1, hasPlant: false)
//        let potL2 = potL1.previousPot ?? Pot(index: potL1.index - 1, hasPlant: false)
//
//        return [potL2, potL1]
//    }
//
//    var rightEnvironment: [Pot] {
//        let potR1 = nextPot ?? Pot(index: index + 1, hasPlant: false)
//        let potR2 = potR1.nextPot ?? Pot(index: potR1.index + 1, hasPlant: false)
//
//        return [potR1, potR2]
//    }
//
//}

let test = false

let initialString = ".#####.##.#.##...#.#.###..#.#..#..#.....#..####.#.##.#######..#...##.#..#.#######...#.#.#..##..#.#.#"

let inputString = """
#..#. => .
##... => #
#.... => .
#...# => #
...#. => .
.#..# => #
#.#.# => .
..... => .
##.## => #
##.#. => #
###.. => #
#.##. => .
#.#.. => #
##..# => #
..#.# => #
..#.. => .
.##.. => .
...## => #
....# => .
#.### => #
#..## => #
..### => #
####. => #
.#.#. => #
.#### => .
###.# => #
##### => #
.#.## => .
.##.# => .
.###. => .
..##. => .
.#... => #
"""

let testInputString = """
...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
"""

let initialInput = (test ? "#..#.#..##......###...###" : initialString)
let padding = 5

extension Year2018 {
    
    class Day12: Day {
        //: [Previous](@previous)
        
        func desc(of pots: [Bool]) -> String {
            return pots.map { $0 ? "#" : "." }.joined()
        }
        
        
        //print(rules.map { "\(desc(of: $0.0)) => \($0.1 ? "#" : ".")" }.joined(separator: "\n"))
        
        //print("\(0):  \(desc(of: pots))")
        
        func sum(of pots: [Bool]) -> Int {
            return pots.enumerated().reduce(0) {
                $0 + ($1.element ? $1.offset - padding : 0)
            }
        }
 
        required init() {
            
        }
        
        func part1() -> String {
            let input = (test ? testInputString : inputString).components(separatedBy: "\n")
            
            var pots = initialInput.map { $0 == "#" }
            
            pots.insert(contentsOf: Array<Bool>(repeating: false, count: padding), at: 0)
            pots.append(contentsOf: Array<Bool>(repeating: false, count: padding))
            var rules = [[Bool] : Bool]()
            for line in input {
                let comps = line.components(separatedBy: " ")
                let rule = comps[0].map { $0 == "#" }
                let result = comps[2]
                rules[rule] = result == "#"
            }
            
            var valAt1K = 0
            for i in 1...2000 {
                var newPots = pots
                for index in 2..<pots.count {
                    var pattern: [Bool]
                    if index+2 >= pots.count {
                        pattern = Array(pots[(index-2)..<pots.count])
                        let padding = Array<Bool>(repeating: false, count: 5-pattern.count)
                        pattern.append(contentsOf: padding)
                        if !pattern.contains(true) { continue }
                        newPots.append(contentsOf: padding)
                    } else {
                        pattern = Array(pots[(index-2)...(index+2)])
                    }
                    
                    if let result = rules[pattern] {
                        newPots[index] = result
                    } else {
                        newPots[index] = false
                    }
                }
                //    print("\(i):  \(desc(of: newPots))")
                
                if i == 20 {
                    print("part 1: \(sum(of: newPots))")
                }
                
                if i == 1000 {
                    valAt1K = sum(of: newPots)
                }
                
                if i == 2000 {
                    let changePer1K = sum(of: newPots) - valAt1K
                    let part2Result = sum(of: newPots) + ((50000000000 - 2000) / 1000) * changePer1K
                    print("part 2: \(part2Result)")
                }
                
                pots = newPots
            }
            
            return #function
        }
        
        
        //
        func part2() -> String {
            return #function
        }
        
    }
    
}
