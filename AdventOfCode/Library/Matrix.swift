//
//  Matrix.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Array {
    
    var match : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0],Array(self[1..<count])) : nil
    }
    
    func advanced() -> Array {
        guard let validMatch = match else { return self }
        
        return validMatch.tail + [validMatch.head]
    }
}

class Matrix<T: Hashable>: Hashable, CustomStringConvertible {
    private static func hash(_ data: Array<Array<T>>) -> Int {
        let values = data.flatMap { $0 }.map { $0.hashValue & 1 }
        
        let size = data.count
        var final = (size & 0xFF) << 24
        values.reversed().enumerated().forEach {
            final |= ($0.element << $0.offset)
        }
        return final
    }
    
    static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        guard lhs.data.count == rhs.data.count else { return false }
        let rows = zip(lhs.data, rhs.data)
        let rowsEqual = rows.map { $0 == $1 }
        return rowsEqual.reduce(true) { $0 && $1 }
    }
    
    var data: Array<Array<T>>
    
    var rowCount: Int { return data.count }
    var colCount: Int { return data.first?.count ?? 0 }
    let hashValue: Int
    
    func row(_ r: Int) -> Array<T> {
        return data[r]
    }
    
    var description: String {
        return "" + data.map({
            "" + $0.map { String(describing: $0) }.joined(separator: " ") + ""
        }).joined(separator: "\n ") + ""
    }
    
    init(_ initial: [[T]]) {
        data = initial
        hashValue = Matrix.hash(data)
    }
    
    init(recombining: Matrix<Matrix<T>>) {
        data = []
        for r in 0 ..< recombining.rowCount {
            let first = recombining.get(r, col: 0)
            var rows = Array(repeating: Array<T>(), count: first.rowCount)
            
            for c in 0 ..< recombining.colCount {
                let subMatrix = recombining.get(r, col: c)
                
                for subR in 0 ..< subMatrix.rowCount {
                    rows[subR].append(contentsOf: subMatrix.row(subR))
                }
                
            }
            
            data.append(contentsOf: rows)
        }
        hashValue = Matrix.hash(data)
    }
    
    func count(where matches: (T) -> Bool) -> Int {
        return data.reduce(0) { (soFar, row) -> Int in
            return soFar + row.reduce(0) { $0 + (matches($1) ? 1 : 0) }
        }
    }
    
    func map(_ block: (_ row: Int, _ col: Int, _ value: T) -> T) -> Matrix<T> {
        var newData = Array<Array<T>>()
        
        for (rowIndex, row) in data.enumerated() {
            var newRow = Array<T>()
            for (colIndex, value) in row.enumerated() {
                let newValue = block(rowIndex, colIndex, value)
                newRow.append(newValue)
            }
            newData.append(newRow)
        }
        
        return Matrix(newData)
    }
    
    func get(_ row: Int, col: Int) -> T {
        return data[row][col]
    }
    
    func set(_ row: Int, col: Int, _ val: T) {
        data[row][col] = val
    }
    
    func rotate(_ clockwiseTurns: Int) -> Matrix<T> {
        let turns = clockwiseTurns % 4
        if turns == 0 { return Matrix(data) }
        
        var current = data
        for _ in 0 ..< turns {
            var thisTurn = Array<Array<T>>()
            for i in 0 ..< current[0].count {
                var newRow = Array<T>()
                for row in current.reversed() {
                    newRow.append(row[i])
                }
                thisTurn.append(newRow)
            }
            current = thisTurn
        }
        return Matrix(current)
    }
    
    func flip() -> Matrix<T> {
        var flipped = Array<Array<T>>()
        for row in data.reversed() {
            flipped.append(row)
        }
        return Matrix(flipped)
    }
    
    func subdivide() -> Matrix<Matrix<T>> {
        let size = data[0].count
        
        let jump = (size % 2 == 0) ? 2 : 3
        
        let jumpCount = size / jump
        
        var newData = Array<Array<Matrix<T>>>()
        
        for r in 0 ..< jumpCount {
            var newRow = Array<Matrix<T>>()
            
            for c in 0 ..< jumpCount {
                let row = (r * jump)
                let col = (c * jump)
                
                var rows = Array<Array<T>>()
                for ri in 0 ..< jump {
                    let thisRow = data[row + ri]
                    let slice = Array(thisRow[col ..< col + jump])
                    rows.append(slice)
                }
                newRow.append(Matrix(rows))
            }
            
            newData.append(newRow)
        }
        
        return Matrix<Matrix<T>>(newData)
    }
}
