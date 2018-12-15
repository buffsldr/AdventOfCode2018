//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//



enum Square {
    
    case vertical
    case horizontal
    case curvedQ3Q1
    case curvedQ2Q4
    case intersection
    
    static func createFrom(character: Character) -> Square? {
        switch character {
        case "|":
            return .vertical
        case "-":
            return .horizontal
        case "/":
            return .curvedQ3Q1
        case "\\":
            return .curvedQ2Q4
        case "+":
            return .intersection
        case "^":
            return .vertical
        case "v":
            return .vertical
        case ">":
            return .horizontal
        case "<":
            return .horizontal
        default:
            if character != " " {
                fatalError()
            }
            return nil
        }
    }
    
}

//var track = [Position: Square]()

enum Turn: Int {
    
    case left
    case straight
    case right
    
    func nextTurn() -> Turn {
        switch self {
        case .left:
            return .straight
        case .straight:
            return .right
        case .right:
            return .left
        }
    }
    
}

class Cart: NSObject {
    
    //    static func == (lhs: Cart, rhs: Cart) -> Bool {
    //        return lhs.position == rhs.position && lhs.heading == rhs.heading && lhs.lastTurn == rhs.lastTurn
    //    }
    
    var _position: Position
    
    var position: Position {
        set {
            _position = newValue
        }
        get {
            return _position
        }
    }
    var heading: Heading
    var lastTurn: Turn?
    var isSafeToDrive = true
    
    
    
    //    public func hash(into hasher: inout Hasher) {
    //        hasher.combine(position)
    //        hasher.combine(heading)
    //        hasher.combine(lastTurn)
    //    }
    //
    init(position: Position, heading: Heading) {
        self._position = position
        self.heading = heading
    }
    
    //    func move(from: Square) {
    //        let predictedPosition: Position
    //        switch from {
    //        case .vertical:
    //            predictedPosition = position.move(heading)
    //        case .horizontal:
    //            predictedPosition = position.move(heading)
    //        case .curvedQ3Q1:
    //            break
    //        case .curvedQ2Q4:
    //            break
    //        case .intersection:
    //            break
    //        }
    //    }
    
}

extension Year2018 {
    
    class Day13: Day {
        
        let input = Day13.inputLines(trimming: false)
        
        required init() { }
        
        func buildTrack() -> [Position: Square] {
            var track = [Position: Square]()
            for (indexY, y) in input.enumerated() {
                for (indexX, x) in Array(y).enumerated() {
                    if let validSquare = Square.createFrom(character: x) {
                        let position = Position(x: indexX, y: indexY)
                        track.updateValue(validSquare, forKey: position)
                    }
                }
            }
            
            return track
        }
        
        func carts() -> [Cart] {
            var carts = [Cart]()
            for (indexY, y) in input.enumerated() {
                for (indexX, x) in Array(y).enumerated() {
                    if let validHeading = Heading.heading(for: x) {
                        let position = Position(x: indexX, y: indexY)
                        carts.append(Cart(position: position, heading: validHeading))
                    }
                    
                }
            }
            
            return carts
        }
        
        
        func part1() -> String {
            var ticks = 0
            var cartsFound = carts()
            let track = buildTrack()
            var pendingSpots = [Position]()
            var crashFree = true
            var shouldRoll = true
            while shouldRoll {
                cartsFound = cartsFound.sorted{ $0.position.x < $1.position.x }.sorted{ $0.position.y < $1.position.y }
                if cartsFound.count == 1 {
                    shouldRoll = false
                    let a = 123
                }
                for cart in cartsFound {
                    if cartsFound.count == 1 {
                        let a = 123
                    }
                    let localP = cart.position
                    let trackSquareOn = track[cart.position]!
                    let upcomingPosition = cart.position.move(cart.heading)
                    let predictedSquare = track[upcomingPosition]!
                    switch predictedSquare {
                    case .vertical, .horizontal:
                        cart.position = cart.position.move(cart.heading)
                    case .curvedQ3Q1: // /
                        if cart.heading == .west {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnLeft()
                        } else if cart.heading == .east {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnLeft()
                        } else if cart.heading == .north {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnRight()
                        } else {
                            // South
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnRight()
                        }
                    case .curvedQ2Q4: // \
                        if cart.heading == .west {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnRight()
                        } else if cart.heading == .east {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnRight()
                        } else if cart.heading == .north {
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnLeft()
                        } else {
                            cart.position = upcomingPosition
                            // South
                            cart.heading = cart.heading.turnLeft()
                        }
                    case .intersection:
                        let nextTurn = cart.lastTurn?.nextTurn() ?? .left
                        cart.lastTurn = nextTurn
                        switch nextTurn {
                        case .left:
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnLeft()
                        case .straight:
                            cart.position = upcomingPosition
                        case .right:
                            cart.position = upcomingPosition
                            cart.heading = cart.heading.turnRight()
                        }
                    }
                    if track[upcomingPosition] == .horizontal  {
                        if cart.heading == .north || cart.heading == .south {
                            fatalError()
                        }
                    }
                    if track[upcomingPosition] == .vertical  {
                        if cart.heading == .east || cart.heading == .west {
                            fatalError()
                        }
                    }
                    
                    let allValues = cartsFound.map{ $0.position }
                    let c1 = allValues.count
                    let allValuesSet = Set(allValues)
                    let c2 = allValuesSet.count
                    if c1 != c2 {
                        cartsFound = cartsFound.filter{ $0.position != cart.position }
                    }
                    ticks += 1
                }
                if cartsFound.count == 1 {
                    let a = 123
                }
            }
            let answer = cartsFound.first!
            return #function
        }
        
        func part2() -> String {
            return #function
        }
        
    }
    
}
