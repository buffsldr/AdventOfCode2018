//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Int {
    
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
    
    func hundredsPlace() -> Int {
        guard self > 99 else { return 0 }
        
        return self.digits[self.digits.count - 3]
    }
    
}

let gridSerialNumber = 5177

extension Matrix where T == FuelCell {
    
    func square(topLeft position: Position) -> Matrix<FuelCell>? {
        guard position.x < (self.rowCount - 2) && position.y < (self.colCount - 2) else { return nil }
        var initial = [[FuelCell]]()
        for x in position.x..<(position.x + 3) {
            var row = [FuelCell]()
            for y in position.y..<(position.y + 3) {
                let fuelCell = FuelCell(position: Position(x: x, y: y))
                row.append(fuelCell)
            }
            initial.append(row)
        }
        
        return Matrix(initial)
    }
    
    func square(topLeft position: Position, size: Int) -> Matrix<FuelCell>? {
        guard position.x < (self.rowCount - (size - 1)) && position.y < (self.colCount - (size - 1)) else { return nil }
        var initial = [[FuelCell]]()
        for x in position.x..<(position.x + size) {
            var row = [FuelCell]()
            for y in position.y..<(position.y + size) {
                let fuelCell = FuelCell(position: Position(x: x, y: y))
                row.append(fuelCell)
            }
            initial.append(row)
        }
        
        return Matrix(initial)
    }
    
    func fuelScore() -> Int {
        return self.data.flatMap{ $0 }.reduce(0){ $0 + $1.powerLevel }
    }
    
}

var memoizedFuelCellScores = [FuelCell: Int]()

struct FuelCell: Hashable {
    
    let position: Position
    
    init(position: Position) {
        self.position = position
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position.x)
        hasher.combine(position.y)
    }
    
    var rackID: Int {
        //Find the fuel cell's rack ID, which is its X coordinate plus 10.
        return position.x + 10
    }
    
    var powerLevel: Int {
        guard let validPowerLevel = memoizedFuelCellScores[self] else {
            //Begin with a power level of the rack ID times the Y coordinate.
            var powerLevel =  rackID * position.y
            //Increase the power level by the value of the grid serial number (your puzzle input).
            powerLevel += gridSerialNumber
            //Set the power level to itself multiplied by the rack ID.
            powerLevel = powerLevel * rackID
            //Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
            powerLevel = powerLevel.hundredsPlace()
            //Subtract 5 from the power level.
            powerLevel -= 5
            memoizedFuelCellScores.updateValue(powerLevel, forKey: self)
            
            return powerLevel
        }
        
        return validPowerLevel
    }
    
}

extension Year2018 {
    
    
    
    class Day11: Day {
        
        required init() { }
        
        func part1() -> String {
            var initial = [[FuelCell]]()
            for x in 1...300 {
                var row = [FuelCell]()
                for y in 1...300 {
                    let fuelCell = FuelCell(position: Position(x: x, y: y))
                    row.append(fuelCell)
                }
                initial.append(row)
            }
            
            let matrix = Matrix(initial)
            
            var allSquares = [Matrix<FuelCell>]()
            
            for x in 1...300 {
                for y in 1...300 {
                    let fuelCellMatrix = matrix.square(topLeft: Position(x: x, y: y)) ?? Matrix([[FuelCell]]())
                    allSquares.append(fuelCellMatrix)
                }
            }
            
            let allScores = allSquares.map{ $0.fuelScore() }
            let maxScore = allScores.max() ?? 0
            let indexOfMax = allScores.index(of: maxScore) ?? 0
            let firstItem = allSquares[indexOfMax].get(0, col: 0)
            
            return String("\(firstItem.position.x)" + "," + "\(firstItem.position.y)")
        }
        
        func part2() -> String {
            var allScoreRunner = [Int]()
            for index in 8..<11 {
                var initial = [[FuelCell]]()
                for x in 1...300 {
                    var row = [FuelCell]()
                    for y in 1...300 {
                        let fuelCell = FuelCell(position: Position(x: x, y: y))
                        row.append(fuelCell)
                    }
                    initial.append(row)
                }
                
                let matrix = Matrix(initial)
                
                var allSquares = [Matrix<FuelCell>]()
                
                for x in 1...300 {
                    for y in 1...300 {
                        let fuelCellMatrix = matrix.square(topLeft: Position(x: x, y: y), size: index) ?? Matrix([[FuelCell]]())
                        allSquares.append(fuelCellMatrix)
                    }
                }
                
                let allScores = allSquares.map{ $0.fuelScore() }
                let maxScore = allScores.max() ?? 0
                // max score is 80
                allScoreRunner.append(maxScore)
            }
            
            return #function
        }
        
    }
    
}
