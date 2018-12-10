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

extension Year2018 {

    class Day6: Day {
        
        required init() { }
        
        let input = Day6.inputLines(trimming: true)
        
        var allPoints: [CGPoint] {
            return input.map{ parse(line: $0) }
        }
        
        func parse(line: String) -> CGPoint {
            var fakeLine = line
            let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(CharacterSet.whitespaces)
            let rowArray = fakeLine.components(separatedBy: breaks).filter{ $0.count > 0 }
            guard let first = rowArray.first, let firstG = Int(first),  let last = rowArray.last, let lastG = Int(last) else {
                return .zero
            }
            
            return CGPoint(x: CGFloat(firstG), y: CGFloat(lastG))
        }
        
        func part1() -> String {
            let maxX = allPoints.map{ $0.x }.max() ?? 0
            let maxY = allPoints.map{ $0.y }.max() ?? 0
            var gridPoints = [CGPoint]()
            var dataStructure = [CGPoint: [CGPoint: CGFloat]]()
            for xIndex in 0..<Int(maxX) {
                for yIndex in 0..<Int(maxY) {
                    var runningFinalPointDictionary = [CGPoint: CGFloat]()
                    let gridPoint = CGPoint(x: xIndex, y: yIndex)
                    gridPoints = allPoints + [gridPoint]
                    for point in allPoints {
                        let distanceToPoint = point.mDistanceFrom(point: gridPoint)
                        runningFinalPointDictionary.updateValue(distanceToPoint, forKey: point)
                    }
                    dataStructure.updateValue(runningFinalPointDictionary, forKey: gridPoint)
                }
            }
            
            var closestPointLookup = [CGPoint: CGPoint]()
         
            dataStructure.keys.forEach { lookupKey in
                let closestPoint = dataStructure[lookupKey]!.values.sorted().first!
                let closesPoint = dataStructure[lookupKey]!.filter{ $0.value == closestPoint }.keys.first!
                closestPointLookup.updateValue(closesPoint, forKey: lookupKey)
            }
            
            
            
            return #function
        }
        
        func part2() -> String {
            return #function
        }
        
    }

}
