//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    func mDistanceFrom(point: CGPoint) -> CGFloat {
        return (abs(x - point.x) + abs(y - point.y))
        
    }
    
}

enum DistanceCheck {
    
    case tied
    case range(Int, Position)
    
}

extension Year2018 {
    
    class Day6: Day {
        
        required init() { }
        
        let input = Day6.inputLines(trimming: true)
        
        var allPoints: [Position] {
            return input.map{ parse(line: $0) }
        }
        
        var maxX: Int {
            return allPoints.map{ Int($0.x) }.max() ?? 0
        }
        
        var maxY: Int {
            return allPoints.map{ Int($0.y) }.max() ?? 0
        }
        
        var allSquares: [Position] {
            var squares = [Position]()
            for x in 0..<maxX {
                for y in 0..<maxY {
                    squares.append(Position(x: x,y: y))
                }
            }
            
            return squares
        }
        
        var pointDictionary: [String: Position] {
            var pointDictionary = [String: Position]()
            for (index, point) in allPoints.enumerated() {
                pointDictionary.updateValue(point, forKey: "Point \(index)")
            }
            
            return pointDictionary
        }
        
        func parse(line: String) -> Position {
            var fakeLine = line
            let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(CharacterSet.whitespaces)
            let rowArray = fakeLine.components(separatedBy: breaks).filter{ $0.count > 0 }
            guard let first = rowArray.first, let firstG = Int(first),  let last = rowArray.last, let lastG = Int(last) else {
                return Position(x:0, y:0)
            }
            
            return Position(x: Int(firstG), y: Int(lastG))
        }
        
        func part1() -> String {
            //          print(allSquares)
            
            var scores = [Position: DistanceCheck]()
            for point in allPoints {
                var minDistanceToSquare = 99999
                for square in allSquares {
                    let distanceToSquare = point.calculateManhattanDistanceFrom(position: square)
                    if distanceToSquare == minDistanceToSquare {
                        let dCheck = DistanceCheck.tied
                    }
                }
            }
            
            
            return #function
        }
        
        func part2() -> String {
            return #function
        }
        
    }
    
}
