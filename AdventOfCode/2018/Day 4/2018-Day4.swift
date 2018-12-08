//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//
//9615 guess 1 too low (guard 641 * 15)
//37178 guess 1 too high (guard 641 * 58)
//26281 guess 1 too high (guard 641 * 41)



enum Activity {
    
    case beginsShift
    case fallsAsleep
    case wakesUp
    
}

struct GuardSleep {
    
    let guardNumber: Int
    let sleepDuration: TimeInterval
    
}

struct ActivityEntry {
    
    let date: Date
    let activity: Activity
    let rawInput: String
    init(rawInput: String) {
        self.rawInput = rawInput
        let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(CharacterSet(arrayLiteral: "]")).union(CharacterSet(arrayLiteral: "["))
        let rowArray = rawInput.components(separatedBy: breaks).filter{ $0.count > 0 }
        let dateString = rowArray[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        date = formatter.date(from: dateString)!
        let restOfArray = Array(rowArray.dropFirst()).reduce(""){ $0 + $1 }
        activity = ActivityEntry.categorize(string: restOfArray.trimmingCharacters(in: .whitespaces))
    }
    
    static func categorize(string: String) -> Activity {
        switch string.count {
        case 12:
            return .fallsAsleep
        case 8:
            return .wakesUp
        default:
            return .beginsShift
        }
    }
    
}

enum Action<A: Codable> {
    
    case beginsShift(A)
    case fallsAsleep
    case wakesUp
    
}

extension Year2018 {
    
    
    struct Sleep: Equatable {
        
        let sleepStart: Date
        var sleepEnd: Date?
        
        var sleepDuration: TimeInterval? {
            guard let sleepEnd = self.sleepEnd else { return nil }
            return sleepEnd.timeIntervalSince(sleepStart)
        }
        
    }
    
    struct Shift {
        
        let guardNumber: Int
        let shiftStart: Date
        let sleepCycles: [Sleep]
        let openSleepCycle: Sleep?
        
        init(guardNumber: Int, shiftStart: Date, sleepCycles: [Sleep], openSleepCycle: Sleep? = nil) {
            self.guardNumber = guardNumber
            self.shiftStart = shiftStart
            self.sleepCycles = sleepCycles
            self.openSleepCycle = openSleepCycle
        }
        
        var sleepDurationTotal: TimeInterval {
            return sleepCycles.reduce(0, { (rollingDuration, sleep) -> TimeInterval in
                return rollingDuration + sleep.sleepDuration!
            })
        }
        
    }
    
    func pullDate(from string: String) -> Date {
        let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(CharacterSet(arrayLiteral: "]")).union(CharacterSet(arrayLiteral: "["))
        let rowArray = string.components(separatedBy: breaks).filter{ $0.count > 0 }
        let dateString = rowArray[0]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return formatter.date(from: dateString)!
    }
    
    struct Scanner {
        
        enum State {
            case initial
            case working
            case sleeping
            case awokeFromNap
            
            var acceptableStateDestinations: [State] {
                switch self {
                case .initial:
                    return [.working]
                case .working:
                    return [.sleeping]
                case .sleeping:
                    return [.awokeFromNap]
                case .awokeFromNap:
                    return [.working]
                }
            }
        }
        
        func pullGuardNumberFrom(string: String) -> Int? {
            let words = string.components(separatedBy: .whitespaces).filter{ $0.contains("#")}
            guard let guardWord = words.first else { return nil }
            
            let breaks: CharacterSet = CharacterSet(arrayLiteral: "#")
            let rowArray = guardWord.components(separatedBy: breaks).filter{ $0.count > 0 }
            guard let lastItem = rowArray.last else { return nil }
            
            return Int(lastItem)
        }
        
        func process(rawInputs: [ActivityEntry], guard: Int?, shift: Shift?) -> [Shift] {
            let inputs = rawInputs.sorted{ $0.date < $1.date }
            guard let match = inputs.match else { return [] }
            guard let validGuardNumber = pullGuardNumberFrom(string: match.head.rawInput) else {
                switch match.head.activity {
                case .beginsShift:
                    fatalError()
                case .fallsAsleep:
                    let openSleep = Sleep(sleepStart: match.head.date, sleepEnd: nil)
                    let shift = Shift(guardNumber: shift!.guardNumber, shiftStart: shift!.shiftStart, sleepCycles: shift!.sleepCycles, openSleepCycle: openSleep)
                    
                    return process(rawInputs: match.tail, guard: shift.guardNumber, shift: shift)
                case .wakesUp:
                    // We close out the open sleep cycle
                    let openSleepCycle = shift!.openSleepCycle!
                    let sleepCycle = Sleep(sleepStart: openSleepCycle.sleepStart, sleepEnd: match.head.date)
                    let updatedSleepCycles = shift!.sleepCycles + [sleepCycle]
                    let updatedShift = Shift(guardNumber: shift!.guardNumber, shiftStart: shift!.shiftStart, sleepCycles: updatedSleepCycles)
                    
                    return process(rawInputs: match.tail, guard: shift!.guardNumber, shift: updatedShift)
                }
            }
            
            // We are starting a new shift...
            let guardNumber = pullGuardNumberFrom(string: match.head.rawInput)!
            let shiftLocal = Shift(guardNumber: guardNumber, shiftStart: match.head.date, sleepCycles: [])
    
            let remnantShift: [Shift]
            if let validShiftPassed = shift {
                remnantShift = [validShiftPassed]
            } else {
                remnantShift = []
            }
            return remnantShift + process(rawInputs: match.tail, guard: guardNumber, shift: shiftLocal)
        }
        
    }
    
    struct GuardSleepHistory: Equatable {
        
        let guardNumber: Int
        let sleepCycles: [Sleep]
        
        func mostSleptMinute() -> (minute: Int, quantity: Int) {
            var sleepingMinutes = [Int: Int]()
            for sleepCycle in sleepCycles {
                for index in 0..<60 {
                    let dateStart = sleepCycle.sleepStart
                    let dateEnd = sleepCycle.sleepEnd ?? dateStart
                    let calendar = Calendar.current
                    let startMinute = calendar.dateComponents([.minute], from: dateStart).minute ?? 0
                    let endMinute = calendar.dateComponents([.minute], from: dateEnd).minute ?? 0
                    let sleepRange = Range(uncheckedBounds: (lower: startMinute, upper: endMinute))
                    if sleepRange.contains(index) {
                        let existingTime = sleepingMinutes[index] ?? 0
                        sleepingMinutes.updateValue(existingTime + 1, forKey: index)
                    }
                }
            }
            let sleepMinutesAnswer = sleepingMinutes.values.max() ?? 0
            guard sleepingMinutes.count > 0 else { return (0,0) }
            let actualMinAnswer = sleepingMinutes.filter{ $0.value == sleepMinutesAnswer }.keys.first!
            
            
            return (actualMinAnswer, sleepMinutesAnswer)
        }
        
    }
    
    class Day4: Day {
        
        required init() { }
        let input = Day4.inputLines(trimming: true)
        //        [1518-04-08 00:18] falls asleep
        //        [1518-09-20 23:59] Guard #2011 begins shift
        //        [1518-07-30 00:27] wakes up
        func convert(string: String) -> [Date: [String]] {
            let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(CharacterSet(arrayLiteral: "]")).union(CharacterSet(arrayLiteral: "["))
            let rowArray = string.components(separatedBy: breaks).filter{ $0.count > 0 }
            let dateString = rowArray[0]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = formatter.date(from: dateString)
            let restOfArray = Array(rowArray.dropFirst())
            
            return [date!: restOfArray]
        }
        
        
        
        var allRaw: [Date: [String]] {
            return input.reduce([:], { (rollingDictionary, localString) -> [Date: [String]] in
                var mutableDictionary = rollingDictionary
                let localDict = convert(string: localString)
                mutableDictionary.updateValue(localDict.values.first!, forKey: localDict.keys.first!)
                
                return mutableDictionary
            })
        }
        
        func sortItems() -> [Shift] {
            let allLines = input.map{ convert(string: $0) }
            
            return []
        }
        
        
        func totalSleepFor(shifts: [Shift]) -> [Int: TimeInterval] {
            return shifts.reduce([:], { (rollingDictionary, shift) -> [Int: TimeInterval] in
                var mutableDictionary = rollingDictionary
                let totalSleep = shift.sleepCycles.reduce(0, { (rollingSleepTime, sleep) -> TimeInterval in
                    return rollingSleepTime + (sleep.sleepDuration ?? 0)
                })
                let existingSleepTime = mutableDictionary[shift.guardNumber] ?? 0
                let newSleepTime = existingSleepTime + totalSleep
                
                mutableDictionary.updateValue(newSleepTime, forKey: shift.guardNumber)
                
                return mutableDictionary
            })
            
        }
        
        
        func part1() -> String {
            let g1 = allRaw
            let g2 = sortItems()
            let activities = input.map{ ActivityEntry(rawInput: $0) }
            
            let scanner = Scanner()
            let ideas = scanner.process(rawInputs: activities, guard: nil, shift: nil)
            let guardNumbers = Set(ideas.map{ $0.guardNumber })
            var guardSleep = [GuardSleep]()
            for guardNumber in Array(guardNumbers) {
                let shiftsForGuard = ideas.filter{ $0.guardNumber == guardNumber }
                let totalSleepTime = shiftsForGuard.reduce(0) { (rollingSleep, shift) -> TimeInterval in
                    return shift.sleepDurationTotal + rollingSleep
                }
                let guardSleepLocal = GuardSleep(guardNumber: guardNumber, sleepDuration: totalSleepTime)
                guardSleep = guardSleep + [guardSleepLocal]
            }
            
            let tot = guardSleep.sorted() { $0.sleepDuration < $1.sleepDuration }
            let sleepiestGuard = tot.last!.guardNumber
            let allSleepForSleepy = ideas.filter{ $0.guardNumber == sleepiestGuard }
            let allSleepCyclesForSleepy = allSleepForSleepy.flatMap{ $0.sleepCycles }
            var sleepingMinutes = [Int: Int]()
            for index in 0..<60 {
                for allSleepCyclesForSleepyTime in allSleepCyclesForSleepy {
                    let dateStart = allSleepCyclesForSleepyTime.sleepStart
                    let dateEnd = allSleepCyclesForSleepyTime.sleepEnd ?? dateStart
                    let calendar = Calendar.current
                    let startMinute = calendar.dateComponents([.minute], from: dateStart).minute ?? 0
                    let endMinute = calendar.dateComponents([.minute], from: dateEnd).minute ?? 0
                    let sleepRange = Range(uncheckedBounds: (lower: startMinute, upper: endMinute))
                    if sleepRange.contains(index) {
                        let existingTime = sleepingMinutes[index] ?? 0
                        sleepingMinutes.updateValue(existingTime + 1, forKey: index)
                    }
                }
            }
            let sleepMinutesAnswer = sleepingMinutes.values.max() ?? 0
            let actualMinAnswer = sleepingMinutes.filter{ $0.value == sleepMinutesAnswer }.keys.first!
            let product = actualMinAnswer * sleepiestGuard
            
            return String(product)
        }
        
        
        
        
        
        func part2() -> String {
            let g1 = allRaw
            
            let g2 = sortItems()
            let activities = input.map{ ActivityEntry(rawInput: $0) }
            
            let scanner = Scanner()
            let ideas = scanner.process(rawInputs: activities, guard: nil, shift: nil)
            let guardNumbers = Set(ideas.map{ $0.guardNumber })
            var guardSleep = [GuardSleep]()
            var runningGH = [Int: GuardSleepHistory]()
            for guardNumber in Array(guardNumbers) {
                let shiftsForGuard = ideas.filter{ $0.guardNumber == guardNumber }
                let totalSleepTime = shiftsForGuard.reduce(0) { (rollingSleep, shift) -> TimeInterval in
                    return shift.sleepDurationTotal + rollingSleep
                }
                
                let sleepTimes = shiftsForGuard.flatMap{ $0.sleepCycles }
                let guardSleepHistoryLocal = GuardSleepHistory(guardNumber: guardNumber, sleepCycles: sleepTimes)
                runningGH.updateValue(guardSleepHistoryLocal, forKey: guardNumber)
            }
            

            let minuteAnswer = runningGH.values.sorted{ $0.mostSleptMinute().1 > $1.mostSleptMinute().1 }.first!.mostSleptMinute()
            let vMatch = runningGH.values.sorted{ $0.mostSleptMinute().1 > $1.mostSleptMinute().1 }.first!
            let guardAnswer = runningGH.filter{ $0.value == vMatch }.keys.first!
            let product = minuteAnswer.0 * guardAnswer

            return String(product)
        }
        
    }
    
}
