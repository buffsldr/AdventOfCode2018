//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

struct Velocity {
    
    let changeXPerSecond: Int
    let changeYPerSecond: Int
    
}

struct TimeStep {
    
    let initialPosition: Position
    let velocity: Velocity
    
    var finalPosition: Position {
        let x = initialPosition.x + velocity.changeXPerSecond
        let y = initialPosition.y + velocity.changeYPerSecond
        
        return Position(x: x, y: y)
    }
    
    func position(at time: Int) -> Position {
        let x = initialPosition.x + (velocity.changeXPerSecond * time)
        let y = initialPosition.y + (velocity.changeYPerSecond * time)
        
        return Position(x: x, y: y)
    }
    
}

extension Year2018 {
    
    class Day10: Day {
        
        required init() { }
        
        
        let input = Day10.inputLines()
        
        func parse(line: String) -> TimeStep {
            let match1 = line.replacingOccurrences(of: "velocity=<", with: "v")
            let match2 = match1.replacingOccurrences(of: "position=<", with: "")
            let match25 = match2.replacingOccurrences(of: ">", with: "")
            let breaks2: CharacterSet = CharacterSet(arrayLiteral: ",")
            
            
            let breaks: CharacterSet = CharacterSet(arrayLiteral: "v")
            let rowArray = match25.components(separatedBy: breaks).filter{ $0.count > 0 }
            let positionPiece = rowArray.first!
            let velocityPiece = rowArray.last!
            let velocityPieces = velocityPiece.components(separatedBy: breaks2).filter{ $0.count > 0 }
            
            
            let vx = velocityPieces.first!.trimmingCharacters(in: .whitespaces)
            let vy = velocityPieces.last!.trimmingCharacters(in: .whitespaces)
            
            let velocity = Velocity(changeXPerSecond: Int(String(vx))!, changeYPerSecond: Int(String(vy))!)
            //let position = Position(x: Int(String(px))!, y: Int(String(py))!)
            
            let positionPieces = positionPiece.components(separatedBy: breaks2).filter{ $0.count > 0 }
            let px = positionPieces.first!.trimmingCharacters(in: .whitespaces)
            let py = positionPieces.last!.trimmingCharacters(in: .whitespaces)
            
            let position = Position(x: Int(String(px))!, y: Int(String(py))!)
            
            return TimeStep(initialPosition: position, velocity: velocity)
        }
        
        func draw(point: Position, into map: Matrix<String>) -> String {
            map.set(point.x, col: point.y, "#")
            
            
            return map.description
        }
        
        func part1() -> String {
            //            var timeGuess = 10000
            //
            //            var rangeXs = [Int: Int]()
            //            var rangeYs = [Int: Int]()
            //
            //            while timeGuess < 12000 {
            //                let timeStateInitial = input.map{ parse(line: $0) }
            //
            //                let timeState0 = timeStateInitial.map{ $0.position(at: timeGuess) }
            //
            //                let maxX = timeState0.map{ $0.x }.max() ?? 0
            //                let maxY = timeState0.map{ $0.y }.max() ?? 0
            //                let minX = timeState0.map{ $0.x }.min() ?? 0
            //                let minY = timeState0.map{ $0.y }.min() ?? 0
            //
            //                let rangeX = maxX - minX
            //                let rangeY = maxY - minY
            //
            //                rangeXs.updateValue(rangeX, forKey: timeGuess)
            //                rangeYs.updateValue(rangeY, forKey: timeGuess)
            //
            //                timeGuess += 5
            //            }
            //
            //            let minXFound = rangeXs.values.min() ?? 0
            //            let minXKey = rangeXs.keys.filter{ rangeXs[$0] == minXFound }.first ?? 0
            //            let minYFound = rangeYs.values.min() ?? 0
            //            let minYKey = rangeYs.keys.filter{ rangeYs[$0] == minYFound }.first ?? 0
            
            //            let sizeWidth = timeState0.map{ $0.finalPosition.x }.max() ?? 0
            //            let sizeHeight = timeState0.map{ $0.finalPosition.y }.max() ?? 0
            //            var xRow = [String]()
            //            xRow.reserveCapacity(sizeWidth)
            //            xRow = Array(repeating: ".", count: sizeWidth)
            //            var yRow = [[String]]()
            //            yRow.reserveCapacity(sizeWidth)
            //            yRow = Array(repeating: xRow, count: sizeHeight)
            //
            //            let initialValue = yRow
            //
            //            let map = Matrix(initialValue)
            //
            //            for timeState in timeState0 {
            //                map.set(timeState.initialPosition.x, col: timeState.initialPosition.y, "#")
            //            }
            //
            // 10100 mins
            let timeStateInitial = input.map{ parse(line: $0) }
            
            var timeUsed = 10100
//            while timeUsed < 10101 {
//                let positions = timeStateInitial.map{ $0.position(at: timeUsed) }
//                let timeState0 = positions.map{ TimeStep(initialPosition: $0, velocity: Velocity(changeXPerSecond: 0, changeYPerSecond: 0))}
//                timeUsed += 1
//            }
            
            let positions = timeStateInitial.map{ $0.position(at: 10101) }
            let timeState0 = positions.map{ TimeStep(initialPosition: $0, velocity: Velocity(changeXPerSecond: 0, changeYPerSecond: 0))}
            
            return draw(timeStates: timeState0)
        }
        
        func draw(timeStates: [TimeStep]) -> String {
            let minX = timeStates.map{ $0.initialPosition.x }.min() ?? 0
            let minY = timeStates.map{ $0.initialPosition.y }.min() ?? 0
            
            
            let allTimeStates = timeStates.map { timeStep -> TimeStep in
                return TimeStep(initialPosition: Position(x: timeStep.initialPosition.x - minX, y: timeStep.initialPosition.y - minY), velocity: timeStep.velocity)
            }
            
            let maxX = allTimeStates.map{ $0.initialPosition.x }.max() ?? 0
            let maxY = allTimeStates.map{ $0.initialPosition.y }.max() ?? 0
            
            let allTimeStatesSorted = allTimeStates.sorted{ $0.initialPosition.y < $1.initialPosition.y  }.sorted{ $0.initialPosition.x < $1.initialPosition.x  }
            
            
            var xRow = [String]()
            xRow.reserveCapacity(maxX * maxY)
            xRow = Array(repeating: " ", count: maxX * 1)
            var yRow = [[String]]()
            yRow.reserveCapacity(maxX * maxY)
            yRow = Array(repeating: xRow, count: maxX * 2)
            
            let initialValue = yRow
            
            let map = Matrix(initialValue)
            for timeStamp in allTimeStatesSorted {
                map.set(timeStamp.initialPosition.x, col: timeStamp.initialPosition.y, "#")
            }
            
            
            
            
            return map.description
        }
        
        func part2() -> String {
            let timeStateInitial = input.map{ parse(line: $0) }
            let positions = timeStateInitial.map{ $0.position(at: 10101) }
            let timeState0 = positions.map{ TimeStep(initialPosition: $0, velocity: Velocity(changeXPerSecond: 0, changeYPerSecond: 0))}
            
            return draw(timeStates: timeState0)
        }
        
    }
    
}
