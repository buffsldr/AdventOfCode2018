//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}

extension Year2018 {
    
    struct PlantRow: Hashable {
        
        let l2: Bool
        let l1: Bool
        let c: Bool
        let r1: Bool
        let r2: Bool
        
        init(state: String) {
            self.l2 = Array(state)[0] == "#"
            self.l1 = Array(state)[1] == "#"
            self.c = Array(state)[2] == "#"
            self.r1 = Array(state)[3] == "#"
            self.r2 = Array(state)[4] == "#"
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(l2)
            hasher.combine(l1)
            hasher.combine(c)
            hasher.combine(r1)
            hasher.combine(r2)
        }
    }
    
    class Day12: Day {
        var initialState =  "...#..#.#..##......###...###..........." //".#####.##.#.##...#.#.###..#.#..#..#.....#..####.#.##.#######..#...##.#..#.#######...#.#.#..##..#.#.#"
        required init() { }
        
        let input = Day12.inputLines()
        
        var matches: [PlantRow: Bool] {
            var rollingD = [PlantRow: Bool]()
            let words = input.forEach{ string  in
                let rawString = string.components(separatedBy: "=>").filter{ $0.count > 0 }
                let plantPart = rawString.first!
                let isGood = plantPart.last! == "#"
                
                rollingD.updateValue(isGood, forKey: PlantRow(state: plantPart))
            }
            
            return rollingD
            
        }
        
        var allPlantRows: [PlantRow] {
            var rollingPots = [PlantRow]()
            
            return initialState.split(by: 5).map{ PlantRow(state: $0) }
        }
        
        func calculateAllPlantRowsFrom(s1: String) -> [PlantRow] {
            let s = s1.count == 39 ? String(s1.dropFirst(1)) : s1
            guard s.count > 4 else { return [] }
            guard let match = Array(s).match else { return [] }
            let ss1: String = (s as NSString).substring(to: 5) // "Stack"
            
            return [PlantRow(state: String(ss1))] + calculateAllPlantRowsFrom(s1: String(match.tail))
        }
        
        func part1() -> String {
            let s1 = PlantRow(state: "..#..")
            var g1 = calculateAllPlantRowsFrom(s1: initialState)
            
            for index in 0..<20 {
                g1 = churn(plants: g1)
            }
            
            return #function
        }
        
        func churn(plants: [PlantRow]) -> [PlantRow] {
            let keys = Array(matches.keys)
            let validKeys = keys.filter { key -> Bool in
                return matches[key]!
            }
            
            return []
            
        }
        //
        func part2() -> String {
            return #function
        }
        
    }
    
}
