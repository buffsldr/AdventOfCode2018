//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

// Linked List from https://hugotunius.se/2016/07/17/implementing-a-linked-list-in-swift.html

enum Shift {
    
    case sevenCounterClockwise
    case sixCounterClockwise
    case twoClockwise
    
}

class Balls {
    
    private var items: LinkedList<Int>
    
    init() {
        items = LinkedList()
        items.append(value: 0)
    }
    
   private func identifyProposedIndexAfterShifting(_ shift: Shift, currentIndex: Int) -> Int {
        let proposedIndex: Int
        switch shift {
        case .sevenCounterClockwise:
            proposedIndex = currentIndex - 7
        case .sixCounterClockwise:
            proposedIndex = currentIndex - 6
        case .twoClockwise:
            proposedIndex = currentIndex + 2
        }
        
        return proposedIndex
    }
    
    func translateProposedInsertionIndexToSafeIndex(_ proposedIndex: Int) -> Int {
        let itemsCountLocal = items.count
        switch (proposedIndex >= 0, proposedIndex <= itemsCountLocal) {
        case (true, true):
            // Safe
            return proposedIndex
        case (true, false):
            let realIndexIsLastSpot = itemsCountLocal - 1
            let realIndexIsNextToLastSpot = itemsCountLocal - 2
            if proposedIndex == realIndexIsLastSpot {
                return 1
            } else if proposedIndex == realIndexIsNextToLastSpot {
                return 0
            } else {
                // This fellow is positive. but a little too big so he needs to go around the horn
                return translateProposedInsertionIndexToSafeIndex(proposedIndex - itemsCountLocal)
            }
            
        case (false, _):
            // All negative items
            return translateProposedInsertionIndexToSafeIndex(itemsCountLocal + proposedIndex)
        }
    }
    
     func customInsert(item: Int, using shift: Shift, currentIndex: Int) -> Int {
        let proposedIndex = identifyProposedIndexAfterShifting(shift, currentIndex: currentIndex)
        let safeIndex = translateProposedInsertionIndexToSafeIndex(proposedIndex)
        
        items.insert(value: item, at: safeIndex)
        
        return safeIndex
    }
    
     func customDeletion(at currentIndex: Int) -> Int {
        let safeIndex = translateProposedDeletionIndexToSafeIndex(currentIndex)
        
        items.remove(at: safeIndex)
        
        return safeIndex
    }
    
   private func translateProposedDeletionIndexToSafeIndex(_ proposedIndex: Int) -> Int {
        let itemsCountLocal = items.count
        switch (proposedIndex >= 0, proposedIndex < itemsCountLocal) {
        case (true, true):
            // Safe
            return proposedIndex
        case (true, false):
            // This fellow is positive. but a little too big so he needs to go around the horn
            return translateProposedInsertionIndexToSafeIndex(proposedIndex - (itemsCountLocal))
        case (false, _):
            // All negative items
            return translateProposedInsertionIndexToSafeIndex(itemsCountLocal + proposedIndex)
        }
    }
    
   private func translateProposedReadingIndexToSafeIndex(_ proposedIndex: Int) -> Int {
        let itemsCountLocal = items.count
        switch (proposedIndex >= 0, proposedIndex < itemsCountLocal) {
        case (true, true):
            return proposedIndex
        case (true, false):
            // This fellow is positive. but a little too big so he needs to go around the horn
            return translateProposedReadingIndexToSafeIndex(proposedIndex - itemsCountLocal)
        case (false, _):
            // All negative items
            return translateProposedInsertionIndexToSafeIndex(itemsCountLocal + proposedIndex)
        }
    }
    
    func readValueAt(index: Int) -> Int {
        let safeIndex = translateProposedReadingIndexToSafeIndex(index)
        
        return items.value(at: safeIndex)
    }
    
}



class BallRunner {
    
    var currentIndex = 0
    var balls = Balls()
    var playersScores = [Int: Int]()
    
     func place(newBallNumber: Int, for player: Int) {
        guard newBallNumber % 23 != 0 else {
            let value7Left = balls.readValueAt(index: currentIndex - 7)
            currentIndex = balls.customDeletion(at: currentIndex - 7)
            let currentPlayerScore = playersScores[player] ?? 0
            playersScores.updateValue(currentPlayerScore + value7Left + newBallNumber, forKey: player)
            
            return
        }
        
        currentIndex = balls.customInsert(item: newBallNumber, using: .twoClockwise, currentIndex: currentIndex)
    }
    
}

 final class Day9: Day {
    
    required init() { }
    
    func part1() -> String {
        var ballCount = 0
        let playerCount = 411
        var currentPlayer = 1
        let marbles100 = 72059
        let br = BallRunner()
        
        while ballCount < marbles100 {
            ballCount += 1
            if currentPlayer == (playerCount + 1) { currentPlayer = 1 }
            br.place(newBallNumber: ballCount, for: currentPlayer)
            currentPlayer = currentPlayer + 1
        }
        
        let maxScore = br.playersScores.values.max()!

        return "\(maxScore)"
        
    }
    
    func part2() -> String {
        
        return "W"
    }
    
}
