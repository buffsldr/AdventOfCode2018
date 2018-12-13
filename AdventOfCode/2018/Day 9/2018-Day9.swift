//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

// I got stuck on implementing a linked list properly and used Andrew Madsen's solution
// https://github.com/armadsen/AdventOfCode2018/blob/master/Day9/Day9.swift

class Marble {
    
    init(index: Int) {
        self.index = index
    }
    
    func marble(atOffset offset: Int) -> Marble {
        var result = self
        for _ in 0..<offset.magnitude {
            result = offset > 0 ? result.nextMarble! : result.previousMarble!
        }
        return result
    }
    
    func insert(between left: Marble, and right: Marble) {
        left.nextMarble = self
        previousMarble = left
        right.previousMarble = self
        nextMarble = right
    }
    
    func remove() {
        previousMarble?.nextMarble = nextMarble
        nextMarble?.previousMarble = previousMarble
    }
    
    let index: Int
    
    var previousMarble: Marble?
    var nextMarble: Marble?
}

func highScoreInGameWith(numberOfPlayers: Int, lastMarble: Int) -> Int {
    var current = Marble(index: 0)
    current.insert(between: current, and: current)
    
    var scores = Array<Int>(repeating: 0, count: numberOfPlayers)
    
    var i = 0
    while true {
        for player in 0..<numberOfPlayers {
            i += 1
            let newMarble = Marble(index: i)
            if newMarble.index % 23 == 0 {
                scores[player] += newMarble.index
                let marbleToRemove = current.marble(atOffset: -7)
                current = marbleToRemove.nextMarble!
                marbleToRemove.remove()
                scores[player] += marbleToRemove.index
            } else {
                newMarble.insert(between: current.marble(atOffset: 1), and: current.marble(atOffset: 2))
                current = newMarble
            }
            
            if newMarble.index == lastMarble {
                return scores.max()!
            }
        }
    }
    
}

 final class Day9: Day {
    
    required init() { }
    
    func part1() -> String {
        return String(highScoreInGameWith(numberOfPlayers: 411, lastMarble: 72059))
    }
    
    func part2() -> String {
        return String(highScoreInGameWith(numberOfPlayers: 411, lastMarble: 72059 * 100))
    }
    
}
