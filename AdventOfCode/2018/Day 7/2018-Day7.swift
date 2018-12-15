//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

var globalTime = 0

struct TimeLog {
    
    let globalStartTime: Int
    let duration: Int
    let elf: Int
    let letter: String
    
    init(globalStartTime: Int, duration: Int, elf: Int, letter: String) {
        self.globalStartTime = globalStartTime
        self.duration = duration
        self.elf = elf
        self.letter = letter
    }
    
    var endTime: Int {
        return duration + globalStartTime
    }
    
}

class LetterDelegate {
    
    var completedLetters = [String]()
    private var letterRelationship = [String: [String]]()
    
    var timeLog = [TimeLog]() {
        didSet {
            if let oldValue = timeLog.last, let currentLast = timeLog.last {
                if oldValue.elf == currentLast.elf {
                    globalTimeBase = currentLast.endTime
                } else {
                    globalTimeBase = oldValue.endTime
                }
            }
        }
    }
    var globalTimeBase = 0
    
    func remainingLetters() -> [String] {
        let completedSet = Set(completedLetters)
        let letterRelationshipSet = Set(Array(letterRelationship.keys))
        let unDone = letterRelationshipSet.subtracting(completedSet)
        
        return Array(unDone)
    }
    
    func isLetterReady(_ letter: String) -> Bool {
        let children = letterRelationship[letter] ?? []
        guard children.count > 0 else { return true }
        var isReady = true
        for child in children {
            if isReady {
                isReady = completedLetters.contains(child)
            }
        }
        
        return isReady
    }
    
    func willExecute(letter: String, localTime: Int) -> TimeLog {
        let nextAvailabilityForElf1 = timeLog.filter{ $0.elf == 1 }.last?.endTime ?? 0  //(timeLog1.last?.globalStartTime ?? 0) +  (timeLog1.last?.duration ?? 0)
        let nextAvailabilityForElf2 = timeLog.filter{ $0.elf == 2 }.last?.endTime ?? 0  //(timeLog1.last?.globalStartTime ?? 0) +  (timeLog1.last?.duration ?? 0)
        let nextElf = nextAvailabilityForElf2 < nextAvailabilityForElf1 ? 2 : 1
        let alphabet =  Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map{ String($0) }
        let letterDuration = alphabet.index(of: letter)! + 1
        
        var nextStartTime = nextElf == 1 ? nextAvailabilityForElf1 : nextAvailabilityForElf2
        
        return TimeLog(globalStartTime: globalTimeBase, duration: letterDuration, elf: nextElf, letter: letter)
    }
    
    
    func didFinish(letter: String, with timeLogPassed: TimeLog) {
        completedLetters = completedLetters + [letter]
        switch timeLogPassed.elf {
        case 1:
            timeLog = timeLog + [timeLogPassed]
        case 2:
            timeLog = timeLog + [timeLogPassed]
        default:
            fatalError()
        }
    }
    
    func parse(line: String)  {
        let match1 = line.components(separatedBy: .newlines).map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let separationTerm = "must be finished before step"
        let match2 = match1.first!.components(separatedBy: separationTerm).map{ $0.trimmingCharacters(in: .whitespaces) }
        let childRuleName = match2.first!.replacingOccurrences(of: "Step", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let parentRuleName = match2.last!.replacingOccurrences(of: "can begin.", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let childRule = childRuleName
        if !letterRelationship.keys.contains(childRule) {
            // We need to add it
            letterRelationship.updateValue([], forKey: childRule)
        }
        let parentRule = parentRuleName
        
        let existingDependencies = letterRelationship[parentRule] ?? []
        let newDependencies: Set<String> = Set(existingDependencies).union(Set([childRule]))
        letterRelationship.updateValue(Array(newDependencies), forKey: parentRule)
    }
    
}

extension Year2018 {
    
    class Day7: Day {
        
        let lines = Day7.inputLines(trimming: true)
        var op1AvailableAt = 0
        var op2AvailableAt = 0
        var letterDelegate1 = LetterDelegate()
        
        required init() { }
        
        func part1() -> String {
            return "Fred"
            //            let letterDelegate = LetterDelegate()
            //
            //            lines.forEach{ linePassed in
            //                letterDelegate.parse(line: linePassed)
            //            }
            //            let remainingLettersHere = letterDelegate.remainingLetters()
            //            var count = remainingLettersHere.count
            //            while count > 0 {
            //                let remainingLetters = letterDelegate.remainingLetters()
            //                var readyItems = [String]()
            //                remainingLetters.forEach { letter in
            //                    if letterDelegate.isLetterReady(letter){
            //                        readyItems = readyItems + [letter]
            //                    }
            //                }
            //                let sortedList = readyItems.sorted{ $0 < $1 }
            //                if let firstItemFound = sortedList.first {
            //                    letterDelegate.didExecute(letter: firstItemFound)
            //                }
            //                count = letterDelegate.remainingLetters().count
            //            }
            //            let answer = letterDelegate.completedLetters.reduce("") { (rollingString, letter) -> String in
            //                return rollingString + letter
            //            }
            //
            //            return answer
        }
        
        func part2() -> String {
            let letterDelegate = LetterDelegate()
            var timeLogs = [TimeLog]()
            
            lines.forEach{ linePassed in
                letterDelegate.parse(line: linePassed)
            }
            let remainingLettersHere = letterDelegate.remainingLetters()
            var count = remainingLettersHere.count
            var isOptimized = false
            while count > 0 {
                let remainingLetters = letterDelegate.remainingLetters()
                var readyItems = [String]()
                remainingLetters.forEach { letter in
                    if letterDelegate.isLetterReady(letter){
                        readyItems = readyItems + [letter]
                    }
                }
                let sortedList = readyItems.sorted{ $0 < $1 }
                
                if let firstItemFound = sortedList.first {
                    let localLog = letterDelegate.willExecute(letter: firstItemFound, localTime: )
                    timeLogs = timeLogs + [localLog]
                    letterDelegate.didFinish(letter: firstItemFound, with: localLog)
                }
                
                
                count = letterDelegate.remainingLetters().count
            }
            let answer = letterDelegate.completedLetters.reduce("") { (rollingString, letter) -> String in
                return rollingString + letter
            }
            let a1 = timeLogs.sorted{ $0.endTime < $1.endTime }.map{ $0.letter }.reduce("") { (rollingString, letter) -> String in
                return rollingString + letter
            }
            return a1
        }
        
        
    }
    
}
