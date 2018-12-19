//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

//: [Previous](@previous)

import Foundation

enum Category: Int {
    
    case addr = 0
    /// addi (add immediate) stores into register C the result of adding register A and value B.
    case addi = 1
    ///mulr (multiply register) stores into register C the result of multiplying register A and register B.
    case mulr
    /// muli (multiply immediate) stores into register C the result of multiplying register A and value B.
    case muli
    /// banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    case banr
    ///bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    case bani
    ///borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    case borr
    case bori
    
    case setr
    case seti
    
    case gtir
    case gtri
    case gtrr
    
    case eqir
    case eqri
    case eqrr
    
    static func createFrom(fakeValue: Int) -> Category {
        switch fakeValue {
        case 0:
            return Category.borr
        case 1:
            return Category.addr
        case 2:
            return Category.eqrr
        case 3:
            return Category.addi
        case 4:
            return Category.eqri
        case 5:
            return Category.eqir
        case 6:
            return Category.gtri
        case 7:
            return Category.mulr
        case 8:
            return Category.setr
        case 9:
            return Category.gtir
        case 10:
            return Category.muli
        case 11:
            return Category.banr
        case 12:
            return Category.seti
        case 13:
            return Category.gtrr
        case 14:
            return Category.bani
        case 15:
            return Category.bori
        default:
            fatalError()
        }
    }
    
    
}

extension Category: CaseIterable { }

class RegisterHouse: Equatable {
    
    static func == (lhs: RegisterHouse, rhs: RegisterHouse) -> Bool {
        return lhs.register0 == rhs.register0 &&
            lhs.register1 == rhs.register1 &&
            lhs.register2 == rhs.register2 &&
            lhs.register3 == rhs.register3
    }
    
    
    var register0 = 0
    var register1 = 0
    var register2 = 0
    var register3 = 0
    
    init(register0: Int = 0, register1: Int = 0, register2: Int = 0, register3: Int = 0) {
        self.register0 = register0
        self.register1 = register1
        self.register2 = register2
        self.register3 = register3
        
    }
    
    func valueFrom(register: Int) -> Int {
        switch register {
        case 0:
            return register0
        case 1:
            return register1
        case 2:
            return register2
        case 3:
            return register3
        default:
            fatalError()
        }
    }
    
    func writeInto(register: Int, value: Int) {
        switch register {
        case 0:
            register0 = value
        case 1:
            register1 = value
        case 2:
            register2 = value
        case 3:
            register3 = value
        default:
            fatalError()
        }
    }
    
    func process(instruction: Instruction) {
        guard let category = instruction.opCode else { return }
        let value: Int
        switch category {
        case .addr:
            value = valueFrom(register: instruction.valueA) + valueFrom(register: instruction.valueB)
        case .addi:
            value = valueFrom(register: instruction.valueA) + instruction.valueB
        case .mulr:
            value = valueFrom(register: instruction.valueA) * valueFrom(register: instruction.valueB)
        case .muli:
            value = valueFrom(register: instruction.valueA) * instruction.valueB
        case .banr:
            value = valueFrom(register: instruction.valueA) & valueFrom(register: instruction.valueB)
        case .bani:
            value = valueFrom(register: instruction.valueA) & instruction.valueB
        case .borr:
            value = valueFrom(register: instruction.valueA) | valueFrom(register: instruction.valueB)
        case .bori:
            value = valueFrom(register: instruction.valueA) | instruction.valueB
        case .setr:
            value = valueFrom(register: instruction.valueA)
        case .seti:
            value = instruction.valueA
        case .gtir:
            value = instruction.valueA > valueFrom(register: instruction.valueB) ? 1 : 0
        case .gtri:
            value = valueFrom(register: instruction.valueA) > instruction.valueB ? 1 : 0
        case .gtrr:
            value = valueFrom(register: instruction.valueA) > valueFrom(register: instruction.valueB) ? 1 : 0
        case .eqir:
            value = instruction.valueA == valueFrom(register: instruction.valueB) ? 1 : 0
        case .eqri:
            value = valueFrom(register: instruction.valueA)  == instruction.valueB ? 1 : 0
        case .eqrr:
            value = valueFrom(register: instruction.valueA)  == valueFrom(register: instruction.valueB) ? 1 : 0
        }
        writeInto(register: instruction.valueC, value: value)
    }
    
}

struct Instruction {
    
    /// The opcode specifies the behavior of the instruction and how the inputs are interpreted.
    let opCode: Category?
    let valueA: Int
    let valueB: Int
    /// The output, C, is always treated as a register.
    let valueC: Int
    
    func modifiedInstructionUsing(category: Category) -> Instruction {
        return Instruction(opCode: category, valueA: valueA, valueB: valueB, valueC: valueC)
    }
    
}

class OpCode {
    
    let Id: Int
    var register0: Int
    var register1: Int
    var register2: Int
    
    init(Id: Int, a register0: Int, b register1: Int, c register2: Int) {
        self.Id = Id
        self.register0 = register0
        self.register1 = register1
        self.register2 = register2
    }
    
    
}

extension Year2018 {
    
    struct Solution {
        
        let number: Int
        let category: Category
        
    }
    
    struct DataInput {
        
        let before: RegisterHouse
        let instruction: Instruction
        let after: RegisterHouse
        
    }
    
    class Day16: Day {
        
        required init() { }
        
        let input = Day16.inputLines()
        
        func process(input: [String]) -> [[String]] {
            
            guard let validInput = input.first, !validInput.contains("EndOfLine") else {
                return [[]]
                
            }
            let newInput = Array(input[0..<3])
            
            return [newInput] + process(input: Array(input[3...]))
        }
        
        func processInputs() -> [Instruction] {
            let indexEnd = input.index(of: "EndOfLine")!
            let theRest = input[indexEnd...].dropFirst()

            let theInstructions = Array(theRest).map{ processFakeInstructionFrom(string: $0) }
            
            return theInstructions
        }
        
        
        let sample1 = [
            "Before: [0, 3, 3, 0]",
            "5 0 2 1",
            "After:  [0, 0, 3, 0]"
        ]
        
        func categoriesCreating(finalHouse: RegisterHouse, from originalHouse: RegisterHouse, using instructionPassed: Instruction) -> Bool {
            originalHouse.process(instruction: instructionPassed)
            
            return finalHouse == originalHouse
        }
        
        func processHouseWithData(string: String) -> RegisterHouse {
            let beforeLineWIthDataArray = string.components(separatedBy: ":")
            //print(f1inputs)
            let data = beforeLineWIthDataArray.last!.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }.map{ Int($0) ?? 0 }
            
            return RegisterHouse(register0: data[0], register1:  data[1], register2:  data[2], register3:  data[3])
        }
        
        func processInstructionFrom(string: String) -> Instruction {
            let localLine = string.components(separatedBy: .whitespaces)
            //            print(localLine)
            let fakeOpCode = Category(rawValue: Int(localLine[0])!)!
            return Instruction(opCode: fakeOpCode, valueA: Int(localLine[1])!, valueB: Int(localLine[2])!, valueC: Int(localLine[3])!)
        }
        
        func processFakeInstructionFrom(string: String) -> Instruction {
            let localLine = string.components(separatedBy: .whitespaces)
            //            print(localLine)
            let realCode = Category.createFrom(fakeValue: Int(localLine[0])!)
            
            return Instruction(opCode: realCode, valueA: Int(localLine[1])!, valueB: Int(localLine[2])!, valueC: Int(localLine[3])!)
        }
        
        func process3Block(array: [String]) -> DataInput? {
            let realArray = array.filter{ $0.count > 0 }
            guard realArray.count == 3 else { return nil }
            let before = processHouseWithData(string: realArray[0])
            let instruction = processInstructionFrom(string: realArray[1])
            let after = processHouseWithData(string: realArray[2])
            
            return DataInput(before: before, instruction: instruction, after: after)
        }
        
        func part1() -> String {
            var possibleOwners = [Int: Set<Category>]()
            let realInput = input.filter{ $0.count > 0 }
            let allBlocks = process(input: realInput).filter { $0.count == 3 }
            let dataInputs = allBlocks.map{ process3Block(array: $0) }
            var count = 0
            for dataInput in dataInputs {
                var possibleMatches = [Category]()
                for category in Category.allCases {
                    let o1 = dataInput!.before.register0
                    let o2 = dataInput!.before.register1
                    let o3 = dataInput!.before.register2
                    let o4 = dataInput!.before.register3
                    
                    let originalHouse = RegisterHouse(register0: o1, register1: o2, register2: o3, register3: o4)
                    let localInstruction = dataInput!.instruction.modifiedInstructionUsing(category: category)
                    let finalHouse = dataInput!.after
                    if o3 == dataInput!.after.register2 && dataInput?.instruction.opCode == .setr {
                        
                        let a = 123
                    }
                    if categoriesCreating(finalHouse: finalHouse, from: originalHouse, using: localInstruction) {
                        possibleMatches = possibleMatches + [localInstruction.opCode!]
                    }
                }
                if possibleMatches.count >= 3 {
                    count += 1
                }
                
                
                
                var existingMatches = possibleOwners[dataInput!.instruction.opCode!.rawValue] ?? []
                if existingMatches.count == 0 {
                    existingMatches = Set(Category.allCases)
                }
                let newPatches = Set(possibleMatches)
                var finalMatches = existingMatches
                if newPatches.count > 0 {
                    finalMatches = existingMatches.intersection(newPatches)
                }
                
                possibleOwners.updateValue(finalMatches, forKey: dataInput!.instruction.opCode!.rawValue)
            }
            
            return String(count)
        }
        
        func part2() -> String {
            let realInput = input.filter{ $0.count > 0 }
            let allBlocks = process(input: realInput).filter { $0.count == 3 }
            let dataInputs = allBlocks.map{ process3Block(array: $0) }.compactMap{ $0 }//.filter{ $0.instruction.opCode!.rawValue == 1 }
            
            let solutions = evaluate(possibleOwners: [:], matches: Set(Category.allCases), dataInputs: dataInputs)
            
            let trimmedInput = input
            
            let inputsInstruction = processInputs()
            
            var myHouse = RegisterHouse()
            for instruction in inputsInstruction {
                myHouse.process(instruction: instruction)
            }
            
            return "Cat"
        }
        
        func evaluate(possibleOwners: [Int: Set<Category>], matches: Set<Category>, dataInputs: [DataInput]) -> [Solution] {
            guard let match = dataInputs.match else {
                return []
                
            }
            let dataInput = match.head
            
            var possibleMatches = [Category]()
            let fakeInstructionNumber = match.head.instruction.opCode
            //            print(fakeInstructionNumber!.rawValue)
            for category in Array(matches) {
                let o1 = dataInput.before.register0
                let o2 = dataInput.before.register1
                let o3 = dataInput.before.register2
                let o4 = dataInput.before.register3
                let originalHouse = RegisterHouse(register0: o1, register1: o2, register2: o3, register3: o4)
                let localInstruction = dataInput.instruction.modifiedInstructionUsing(category: category)
                let finalHouse = dataInput.after
                if categoriesCreating(finalHouse: finalHouse, from: originalHouse, using: localInstruction) {
                    possibleMatches = possibleMatches + [localInstruction.opCode!]
                }
            }
            let existingMatches: Set<Category>
            if let validFakeInstructionNumber = fakeInstructionNumber, let validMatches = possibleOwners[validFakeInstructionNumber.rawValue], validMatches.count > 0 {
                existingMatches = validMatches
            } else {
                existingMatches = matches
            }
            let newMatches = Set(possibleMatches)
            let intersection = newMatches.intersection(existingMatches)
            if intersection.count == 1 { //We found the solution
                let solution = Solution(number: fakeInstructionNumber!.rawValue, category: intersection.first!)
                let unMatchedCategories = matches.subtracting(intersection)
                var possibleOwnersNew = possibleOwners.reduce([:]) { (rollingDictionary, keyValue) -> [Int: Set<Category>] in
                    var mutableDictionary = rollingDictionary
                    if keyValue.0 != fakeInstructionNumber!.rawValue {
                        mutableDictionary.updateValue(keyValue.value, forKey: keyValue.key)
                    }
                    
                    return mutableDictionary
                }
                
                return [solution] + evaluate(possibleOwners: possibleOwnersNew, matches: unMatchedCategories, dataInputs: match.tail)
            }
            
            if intersection.count == 0 {
                
                
            }
            
            var newPossibleOwners = possibleOwners
            newPossibleOwners.updateValue(intersection, forKey: fakeInstructionNumber!.rawValue)
            
            
            return evaluate(possibleOwners: newPossibleOwners, matches: matches, dataInputs: match.tail)
        }
        
    }
    
}

//
//▿ 16 elements
//    ▿ 0 : Solution
//- number : 10
//- category : AdventOfCode.Category.muli
//▿ 1 : Solution
//- number : 7
//- category : AdventOfCode.Category.mulr
//▿ 2 : Solution
//- number : 3
//- category : AdventOfCode.Category.addi
//▿ 3 : Solution
//- number : 0
//- category : AdventOfCode.Category.borr
//▿ 4 : Solution
//- number : 1
//- category : AdventOfCode.Category.addr
//▿ 5 : Solution
//- number : 15
//- category : AdventOfCode.Category.bori
//▿ 6 : Solution
//- number : 9
//- category : AdventOfCode.Category.gtir
//▿ 7 : Solution
//- number : 12
//- category : AdventOfCode.Category.seti
//▿ 8 : Solution
//- number : 11
//- category : AdventOfCode.Category.banr
//▿ 9 : Solution
//- number : 8
//- category : AdventOfCode.Category.setr
//▿ 10 : Solution
//- number : 14
//- category : AdventOfCode.Category.bani
//▿ 11 : Solution
//- number : 4
//- category : AdventOfCode.Category.eqri
//▿ 12 : Solution
//- number : 2
//- category : AdventOfCode.Category.eqrr
//▿ 13 : Solution
//- number : 6
//- category : AdventOfCode.Category.gtri
//▿ 14 : Solution
//- number : 13
//- category : AdventOfCode.Category.gtrr
//▿ 15 : Solution
//- number : 5
//- category : AdventOfCode.Category.eqir
