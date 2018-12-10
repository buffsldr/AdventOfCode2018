//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

enum Direction {
    
    case clockwise
    case counterClockwise
    
}

extension Array where Element == Int {

    func shift(withDistance distance: Int = 1) -> Array<Int> {
        guard count > 0 else { return [] }
        
        guard abs(distance) == 1 else {
            switch distance {
            case let x where x > 0:
                return shift(withDistance: 1).shift(withDistance: (x - 1))
            case let x where x < 0:
                return shift(withDistance: -1).shift(withDistance: (x + 1))
            case let x where x == 0:
                return self
            default:
                return self
            }
        }
        
        let index = distance >= 0 ? startIndex.advanced(by: distance) : endIndex.advanced(by: distance)
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
    
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        guard abs(distance) == 1 else {
            switch distance {
            case let x where x > 1:
                self = shift(withDistance: 1).shift(withDistance: (x - 1))
            case let x where x < 1:
                self = shift(withDistance: -1).shift(withDistance: (x + 1))
            case let x where x == 0:
                break
            default:
                break
            }
            return
        }
        self = shift(withDistance: distance)
    }
    
    func provideItem(direction: Direction, count: Int) -> Element {
        let directionValue: Int
        switch direction {
        case .clockwise:
            directionValue = 1
        case .counterClockwise:
            directionValue = -1
        }
        var fakey = [Int]()
        fakey.reserveCapacity(72059)
        fakey = self
        fakey.shiftInPlace(withDistance: count * directionValue)
        
        return fakey.first!
    }
    
}

let ballQuantity = 72059



extension Year2018 {
    
    
     fileprivate struct Circle {
        
        var marbles: [Int]
        var currentMarble: Int
        var currentMarblePosition: Int
        var fakey = [Int]()

        
        init(marbles: [Int], currentMarble: Int, currentMarblePosition: Int) {
            self.marbles = marbles
            self.currentMarble = currentMarble
            self.currentMarblePosition = currentMarblePosition
            fakey.reserveCapacity(72059)
        }
        
        enum NewPosition {
            
            case start
            case middle(Int)
            case end
            
        }
        
         mutating func insert() -> Circle {
            var updatedMarbles = marbles
            let newPosition: Int
            switch (marbles.count - currentMarblePosition - 1) {
            case 0:
                // Last
                newPosition = 1
                updatedMarbles.insert(currentMarble + 1, at: newPosition)
                
            case 1:
                updatedMarbles = updatedMarbles + [currentMarble + 1]
                newPosition = updatedMarbles.count - 1
            default:
                newPosition = currentMarblePosition + 2
                updatedMarbles.insert(currentMarble + 1, at: newPosition)
            }
            marbles = updatedMarbles
            currentMarble = currentMarble + 1
            currentMarblePosition = newPosition
            
            return self
        }
        
          mutating func insertAt(newPosition: NewPosition) -> Circle {
            var updatedMarbles = marbles
            let absoluteNewMarblePosition: Int
            
            switch newPosition {
            case .start:
                updatedMarbles.insert(currentMarble + 1, at: 0)
                absoluteNewMarblePosition = 0
            case .middle(let position):
                updatedMarbles.insert(currentMarble + 1, at: position)
                absoluteNewMarblePosition = position
            case .end:
                updatedMarbles = updatedMarbles + [currentMarble + 1]
                absoluteNewMarblePosition = updatedMarbles.count - 1
            }
            marbles = updatedMarbles
            currentMarble = currentMarble + 1
            currentMarblePosition = absoluteNewMarblePosition
            
            return self
            
            
//            return Circle(marbles: updatedMarbles, currentMarble: currentMarble + 1, currentMarblePosition: absoluteNewMarblePosition)
        }
        
          mutating func attemptToAdd(marble: Int) -> (Int, Circle) {
            var score = 0
            guard marble % 23 != 0 && marble > 0 else {
                // Do Jordan thing
                score = marble
                var tempRotation = marbles
                
                while tempRotation.first! != currentMarble {
                    tempRotation.shiftInPlace()
                }
                
                let marbleAtSixCCW = tempRotation.provideItem(direction: .counterClockwise, count: 6)
                let marbleAtSevenCCW = tempRotation.provideItem(direction: .counterClockwise, count: 7)
                
                
                let newMarbles = marbles.filter{ $0 != marbleAtSevenCCW }
                score = score + marbleAtSevenCCW
                let indexForMarbleAtSixCCW = Int(newMarbles.index(of: marbleAtSixCCW)!)
                
                return (score, Circle(marbles: newMarbles, currentMarble: currentMarble + 1, currentMarblePosition: indexForMarbleAtSixCCW))
            }
            
            return (0, insert())
        }
        
    }
    
    final class Day9: Day {
        
        required init() { }
        
        func part1() -> String {
            return ""
            let playerCount = 411
            var ball = 0
            var scores = [Int: Int]()
            var circle = Circle(marbles: [0], currentMarble: 0, currentMarblePosition: 0)
            var currentPlayer = 1
            while ball < ballQuantity {
                ball = ball + 1
                if currentPlayer == (playerCount + 1) { currentPlayer = 1 }
                let dup = circle.attemptToAdd(marble: ball)
                if dup.0 > 0 {
                    let currentPlayerScore = scores[currentPlayer] ?? 0
                    scores.updateValue(dup.0 + currentPlayerScore, forKey: currentPlayer)
                }
                circle = dup.1
                currentPlayer = currentPlayer + 1
            }
            let winningScore = scores.values.sorted{ $0 > $1 }.first!
            let winner = scores.filter{ $0.value == winningScore }.keys.first!
            
            return "Winner is \(winner) with a score of \(winningScore)"
        }
        
        func part2() -> String {
            let ballQuantity = 72059
            let playerCount = 411
            var ball = 0
            var scores = [Int: Int]()
            var circle = Circle(marbles: [0], currentMarble: 0, currentMarblePosition: 0)
            var currentPlayer = 1
            while ball < ballQuantity {
                ball = ball + 1
                if currentPlayer == (playerCount + 1) { currentPlayer = 1 }
                let dup = circle.attemptToAdd(marble: ball)
                if dup.0 > 0 {
                    let currentPlayerScore = scores[currentPlayer] ?? 0
                    scores.updateValue(dup.0 + currentPlayerScore, forKey: currentPlayer)
                }
                circle = dup.1
                currentPlayer = currentPlayer + 1
            }
            let winningScore = scores.values.sorted{ $0 > $1 }.first!
            let winner = scores.filter{ $0.value == winningScore }.keys.first!
            
            return "Winner is \(winner) with a score of \(winningScore)"
        }
        
    }
    
}
