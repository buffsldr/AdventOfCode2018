//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate enum Direction {
    
    case clockwise
    case counterClockwise
    
}

enum Shift {
    
    case sevenCounterClockwise
    case sixCounterClockwise
    case twoClockwise
    
}


final fileprivate class CircularArray2 {
    
    var items: [Int]
    var currentIndex = 0 {
        didSet {
            let a = 123
        }
    }
    var playersScores = [Int: Int]()
    var canonizedIndex = 0
    
    func next() -> Int {
        currentIndex += 1
        
        return self[currentIndex]
    }
    
    init(items: [Int]) {
        self.items = items
        self.items.reserveCapacity(7205901)
    }
    
    subscript(index: Int) -> Int {
        get {
            guard items.count > 0 else { return 0 }
            let offSetIndex = index + currentIndex
            
            guard offSetIndex >= 0 else {
                let newIndex = items.count + offSetIndex
                
                return self[newIndex]
            }
            guard offSetIndex < items.count else {
                let quotient = offSetIndex / items.count
                let subtractionAmount = quotient * items.count
                
                return items[offSetIndex - subtractionAmount]
            }
            
            return items[offSetIndex]
        }
        
        set(newValue) {
            // perform a suitable setting action here
            let offSetIndex = index + currentIndex
            
            guard offSetIndex >= 0 else {
                let newIndex = items.count + offSetIndex
                self[newIndex] = newValue
                
                return
            }
            guard offSetIndex < items.count else {
                let quotient = offSetIndex / items.count
                let subtractionAmount = quotient * items.count
                items[offSetIndex - subtractionAmount] = newValue
                
                return
            }
            
            items[offSetIndex] = newValue
        }
    }
    
    func actualIndex(from fakeIndex: Int) -> Int {
        let offSetIndex = fakeIndex + currentIndex
        if offSetIndex == 0 { return 0 }
        guard offSetIndex >= 0 else {
            let actualIndexFound = (items.count + 1) + offSetIndex
            
            return actualIndex(from:actualIndexFound)
        }
        
        guard offSetIndex < items.count else {
            let quotient = offSetIndex / items.count
            let subtractionAmount = quotient * items.count
            
            return offSetIndex - subtractionAmount
        }
        
        return offSetIndex
    }
    
    func placeBall(number: Int, for player: Int) {
        guard number % 23 != 0 else {
            //Score it
            let value7Left = self[-7]
            let realIndexFor7 = actualIndex(from: -7)
            let score = value7Left + number
            
            items.remove(at: realIndexFor7)
            let currentPlayerScore = playersScores[player] ?? 0
            playersScores.updateValue(currentPlayerScore + score, forKey: player)
            let realIndex = actualIndex(from: -6)
            currentIndex = realIndex
            
            return
        }
        
        let valueOfCurrentBall = self[0]
        let realIndex = provideExistingSafeIndex(for: valueOfCurrentBall, shift: .twoClockwise) //items.index(of: valueOfCurrentBall)!
        items.insert(number, at: realIndex)
        currentIndex = realIndex
    }
    
    func provideExistingSafeIndex(for number: Int, shift: Shift) -> Int {
        guard items.count > 0 else { return 1 }
        let proposedCanonizedIndex: Int
        switch shift {
        case .sevenCounterClockwise:
            proposedCanonizedIndex = canonizedIndex - 7
        case .sixCounterClockwise:
            proposedCanonizedIndex = canonizedIndex - 6
        case .twoClockwise:
            proposedCanonizedIndex = canonizedIndex + 2
        }
        guard proposedCanonizedIndex < items.count && proposedCanonizedIndex >= 0 else {
            var realIndex = items.index(of: number)!
            let realIndexIsLastSpot = items.count - 1
            let realIndexIsNextToLastSpot = items.count - 2
            
            if realIndex == realIndexIsLastSpot {
                realIndex = 1
            } else if realIndex == realIndexIsNextToLastSpot {
                realIndex = 0
            } else {
                realIndex = realIndex + 2
            }
            
            return realIndex
        }
        
        return proposedCanonizedIndex
    }
    
}

 final class Day9: Day {
    
    required init() { }
    
    func part1() -> String {
        let c1 = CircularArray2(items: [0])
        c1.currentIndex = 0
        var ballCount = 0
        let playerCount = 10
        var currentPlayer = 1
        let marbles100 = 25
        
        while ballCount < marbles100 {
            ballCount += 1
            if currentPlayer == (playerCount + 1) { currentPlayer = 1 }
            c1.placeBall(number: ballCount, for: currentPlayer)
            currentPlayer = currentPlayer + 1
        }
        
        let maxScore = c1.playersScores.values.max()!

        return "\(maxScore)"
        
    }
    
    func part2() -> String {
        
        return "W"
    }
    
}


