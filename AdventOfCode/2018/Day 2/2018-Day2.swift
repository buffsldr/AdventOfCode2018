//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {
    
    class Day2: Day {
        
        required init() { }
        
        let input = Day2.inputCharacters()
        
        func part1() -> String {
            let twoCount = input.reduce(0) { (rollingCount, characters) -> Int in
                return countTwos(characters: characters) + rollingCount
            }
            
            let threeCount = input.reduce(0) { (rollingCount, characters) -> Int in
                return countThrees(characters: characters) + rollingCount
            }
            let parseCount1 = twoCount * threeCount
            
            return String(parseCount1)
        }
        
        func countTwos(characters: [Character]) -> Int {
            let dict = parse(characters: characters)
            
            return matches(dictionary: dict, count: 2)
        }
        
        func countThrees(characters: [Character]) -> Int {
            let dict = parse(characters: characters)
            
            return matches(dictionary: dict, count: 3)
        }
        
        func part2() -> String {
            
            
            return String(findPositionNumber())
        }
        
        func findPositionNumber() -> String {
            var mutableStart = input
            var didFindMatch = false
            var position = ""
            while !didFindMatch {
                var originalSet = Set<String>()
                let tails = mutableStart.map{ $0.match?.tail ?? [] }
                for characters in tails {
                    let originalCount = originalSet.count
                    originalSet.insert(String(characters))
                    let finalCount = originalSet.count
                    if originalCount == finalCount {
                        didFindMatch = true
                        position = String(characters)
                    }
                }
                mutableStart = mutableStart.map{ $0.advanced() }
            }
            
            
            
            return position
        }
        
        func parse(characters: [Character]) -> [Character: Int] {
            var matches = [Character: Int]()
            for character in characters {
                let existingValue = matches[character] ?? 0
                let updatedValue = existingValue + 1
                matches.updateValue(updatedValue, forKey: character)
            }
            
            return matches
        }
        
        func matches(dictionary: [Character: Int], count: Int) -> Int {
            let values = dictionary.values
            
            return values.filter{ $0 == count }.count > 0 ? 1: 0
        }
        
    }
    
}
