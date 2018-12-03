//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import AppKit

extension Year2018 {
    
    class Day3: Day {
        
        required init() { }
        
        let input = Day3.inputLines(trimming: true)
        
        var allRects: [CGRect] {
            return  input.map{ convert(string: $0) }
        }
        
        var allRectOrder: [CGRect: Int] {
            return input.reduce([:], { (rollingDictionary, localString) -> [CGRect: Int] in
                var mutableDictionary = rollingDictionary
                let localDict = convertAll(string: localString)
                mutableDictionary.updateValue(localDict.values.first!, forKey: localDict.keys.first!)
                
                return mutableDictionary
            })
        }
        
        func part1() -> String {
            let allElementalRectArray = allRects.reduce([]) { (rollingArray, localRect) -> [CGRect] in
                return rollingArray + localRect.elemental()
            }
            
            return String(Day3.countOverlaps(rects: allElementalRectArray))
        }
        
        func part2() -> String {
            let nonOverlappingRect = nonOverlapping(rects: allRects)!
            let solution = allRectOrder[nonOverlappingRect]!
            
            return String(solution)
        }

        static func countOverlaps(rects: [CGRect]) -> Int {
            var intersectors = [CGRect]()
            var rectSet = Set<CGRect>()
            rects.forEach { localRect in
                let originalCount = rectSet.count
                rectSet.insert(localRect)
                let finalCount = rectSet.count
                if originalCount == finalCount {
                    intersectors.append(localRect)
                }
            }
            return Set(intersectors).count
        }
        
        func convertAll(string: String) -> [CGRect: Int] {
            let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(.whitespaces).union(CharacterSet(arrayLiteral: ":")).union(CharacterSet(arrayLiteral: "x")).union(CharacterSet(arrayLiteral: "#"))
            let rowArray = string.components(separatedBy: breaks).filter{ $0.count > 0 }
            let originX: CGFloat = CGFloat(Int(rowArray[2])!)
            let originy: CGFloat = CGFloat(Int(rowArray[3])!)
            let width: CGFloat = CGFloat(Int(rowArray[4])!)
            let height: CGFloat = CGFloat(Int(rowArray[5])!)
            let rect = CGRect(x: originX, y: originy, width: width, height: height)
            let orderNumber: Int = Int(rowArray[0])!

            return [rect: orderNumber]
        }
        
        func convert(string: String) -> CGRect {
            let breaks: CharacterSet = CharacterSet(arrayLiteral: ",").union(.whitespaces).union(CharacterSet(arrayLiteral: ":")).union(CharacterSet(arrayLiteral: "x"))
            let rowArray = string.components(separatedBy: breaks).filter{ $0.count > 0 }
            let originX: CGFloat = CGFloat(Int(rowArray[2])!)
            let originy: CGFloat = CGFloat(Int(rowArray[3])!)
            let width: CGFloat = CGFloat(Int(rowArray[4])!)
            let height: CGFloat = CGFloat(Int(rowArray[5])!)
            let rect = CGRect(x: originX, y: originy, width: width, height: height)
            
            return rect
        }
        
        func nonOverlapping(rects: [CGRect]) -> CGRect? {
            var isSolid = false
            var originalRects = rects
            var answer: CGRect?
            while !isSolid {
                let match = originalRects.match!
                var localIsSolid = true
                for localRect in match.tail {
                    if localRect.intersects(match.head) {
                        localIsSolid = false
                    }
                }
                isSolid = localIsSolid
                if !isSolid {
                    originalRects = originalRects.advanced()
                } else {
                    answer = match.head
                }
            }
            
            return answer
        }
    }
    
}
