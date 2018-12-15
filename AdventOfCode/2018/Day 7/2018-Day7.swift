//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

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
    
    var ldCompletedLetters = [String]() 
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
    
    func remainingLetters(with completedWork: [TimeLog], and wipWork: [String]) -> [String] {
        let localFinishedLetters = completedWork.map{ $0.letter } + wipWork
        ldCompletedLetters = completedWork.map{ $0.letter }
        let completedSet = Set(localFinishedLetters)
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
                isReady = ldCompletedLetters.contains(child)
            }
        }
        
        return isReady
    }
    
    func didFinish(letter: String, with timeLogPassed: TimeLog) {
        ldCompletedLetters = ldCompletedLetters + [letter]
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

class Worker {
    
    let number: Int
    private var currentWork: TimeLog?
    
    init(number: Int) {
        self.number = number
    }
    
    func isAvailableToWork(_ currentTime: Int) -> Bool {
        guard let validWork = currentWork else { return true }
        
        return currentTime > validWork.endTime
    }
    
    func assign(letter: String, startTime: Int) {
        let alphabet =  Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map{ String($0) }
        let duration = alphabet.index(of: letter)! + 1 + 60

        let timeLog = TimeLog(globalStartTime: startTime, duration: duration, elf: number, letter: letter)
        
        currentWork = timeLog
    }
    
    func provideFinishedWork(for time: Int) -> TimeLog? {
        guard let validWork = currentWork else { return nil }
        guard validWork.endTime <= time else { return nil }
        // Clear out the current work since it is done
        currentWork = nil
        
        return validWork
    }
    
    
    
}

class Run {
    
    let lines: [String]
    let originalWorkCount: Int
    
    init(originalWorkCount: Int, lines: [String]) {
        self.originalWorkCount = originalWorkCount
        self.lines = lines
    }
    
    var letterDelegate = LetterDelegate()
    private var completedWork = [TimeLog]() {
        didSet {
            // since
            if completedWork.count == originalWorkCount {
                hasRemainingWork = false
            }
        }
    }
    
    var hasRemainingWork = true
    
    private var inProgessWork = [String]()
    
    var currentTime = 0
    
    var worker1: Worker = Worker(number: 1)
    var worker2: Worker = Worker(number: 2)
    var worker3: Worker = Worker(number: 3)
    var worker4: Worker = Worker(number: 4)
    var worker5: Worker = Worker(number: 5)
    
    func provideNextWorkPiece() -> String? {
        let remainingLetters = letterDelegate.remainingLetters(with: completedWork, and: inProgessWork)
        var readyItems = [String]()
        remainingLetters.forEach { letter in
            if letterDelegate.isLetterReady(letter){
                readyItems = readyItems + [letter]
            }
        }
        let sortedList = readyItems.sorted{ $0 < $1 }
        guard sortedList.count > 0 else { return nil }
        
        return sortedList.first
    }
    
    func assign(letter: String, to worker: Worker, at startTime: Int) {
        worker.assign(letter: letter, startTime: startTime)
        inProgessWork = inProgessWork + [letter]
    }
    
    func availableWorker(at time: Int) -> Worker? {
        let allWorkers = [worker1, worker2, worker3, worker4, worker5]

        return allWorkers.filter{ $0.isAvailableToWork(time) }.first
    }
    
    func requestCompletedWork(at time: Int) {
        let completedWork1 = worker1.provideFinishedWork(for: time)
        let completedWork2 = worker2.provideFinishedWork(for: time)
        let completedWork3 = worker3.provideFinishedWork(for: time)
        let completedWork4 = worker4.provideFinishedWork(for: time)
        let completedWork5 = worker5.provideFinishedWork(for: time)

        var completedWorkLocal = [TimeLog]()
        if let validCompletedWork1 = completedWork1 {
            completedWorkLocal = completedWorkLocal + [validCompletedWork1]
        }
        
        if let validCompletedWork2 = completedWork2 {
            completedWorkLocal = completedWorkLocal + [validCompletedWork2]
        }

        if let validCompletedWork2 = completedWork3 {
            completedWorkLocal = completedWorkLocal + [validCompletedWork2]
        }

        if let validCompletedWork2 = completedWork4 {
            completedWorkLocal = completedWorkLocal + [validCompletedWork2]
        }

        if let validCompletedWork2 = completedWork5 {
            completedWorkLocal = completedWorkLocal + [validCompletedWork2]
        }
        guard completedWorkLocal.count > 0 else { return }
        // if we have two items, we need to sorth them based on name
        completedWorkLocal = completedWorkLocal.sorted{ $0.letter < $1.letter }
        completedWork = completedWork + completedWorkLocal
    }
    
    func runner() {
        lines.forEach{ linePassed in
            if linePassed.count > 0 {
                letterDelegate.parse(line: linePassed)
            }
        }
        
        var time = -1
        while hasRemainingWork {
            time += 1
            requestCompletedWork(at: time)
            if hasRemainingWork {
                if let availableWorkerFound = availableWorker(at: time), let nextWorkPiece = provideNextWorkPiece(), nextWorkPiece.count > 0 {
                    availableWorkerFound.assign(letter: nextWorkPiece, startTime: time)
                    inProgessWork = inProgessWork + [nextWorkPiece]
                    
                }
                // We might have another worker waiting
                if let availableWorkerFound2 = availableWorker(at: time), let nextWorkPiece2 = provideNextWorkPiece(), nextWorkPiece2.count > 0 {
                    availableWorkerFound2.assign(letter: nextWorkPiece2, startTime: time)
                    inProgessWork = inProgessWork + [nextWorkPiece2]
                }
                
                // We might have another worker waiting
                if let availableWorkerFound2 = availableWorker(at: time), let nextWorkPiece2 = provideNextWorkPiece(), nextWorkPiece2.count > 0 {
                    availableWorkerFound2.assign(letter: nextWorkPiece2, startTime: time)
                    inProgessWork = inProgessWork + [nextWorkPiece2]
                }

                // We might have another worker waiting
                if let availableWorkerFound2 = availableWorker(at: time), let nextWorkPiece2 = provideNextWorkPiece(), nextWorkPiece2.count > 0 {
                    availableWorkerFound2.assign(letter: nextWorkPiece2, startTime: time)
                    inProgessWork = inProgessWork + [nextWorkPiece2]
                }

                // We might have another worker waiting
                if let availableWorkerFound2 = availableWorker(at: time), let nextWorkPiece2 = provideNextWorkPiece(), nextWorkPiece2.count > 0 {
                    availableWorkerFound2.assign(letter: nextWorkPiece2, startTime: time)
                    inProgessWork = inProgessWork + [nextWorkPiece2]
                }
                
                
                
            }
            // Whatever happens
        }
        print(completedWork.map{ $0.letter} )
        print(completedWork.last!.endTime)
        
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
            let runner = Run(originalWorkCount: 26, lines: lines)
            
            
            runner.runner()
            
            return "ok"
        }
        
        
    }
    
}
