import Foundation

//
//  LinkedList.swift
//  AdventOfCode
//
//  Created by Mark Vader on 12/11/18.
//  Copyright © 2018 NorthPole. All rights reserved.
//

import Foundation

public class Node<T> {
    typealias NodeType = Node<T>
    
    /// The value contained in this node
    public let value: T
    var next: NodeType? = nil
    var previous: NodeType? = nil
    
    public init(value: T) {
        self.value = value
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        get {
            return "Node(\(value))"
        }
    }
}

public final class LinkedList<T> {
    public typealias NodeType = Node<T>
    
    private var start: NodeType?
    private var end: NodeType?
    
    /// The number of elements in the list at any given time
    public private(set) var count: Int = 0
    
    /// Wether or not the list is empty. Returns `true` when
    /// count is 0 and `false` otherwise
    public var isEmpty: Bool {
        get {
            return count == 0
        }
    }
    
    /// Create a new LinkedList
    ///
    /// - returns: An empty LinkedList
    public init() {
        
    }
    
    /// Create a new LinkedList with a sequence
    ///
    /// - parameter: A sequence
    /// - returns: A LinkedList containing the elements of the provided sequence
    public init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
        for element in elements {
            append(value: element)
        }
    }
}

extension LinkedList {
    
    public func insert(value: T, at location: Int) {
        guard location < (count) else {
            append(value: value)
            return
        }
        let newNode = Node(value: value)
        let previousNodeAtLocation = node(at: location)
        previousNodeAtLocation.previous = newNode
        newNode.next = previousNodeAtLocation
        if location == 0 {
            let previousStart = start
            start = newNode
            start?.next = previousStart
            previousStart?.previous = newNode
        } else {
            let priorNode = node(at: location - 1)
            priorNode.next = newNode
            newNode.previous = priorNode
        }
    }
    
}

extension LinkedList {
    
    /// Add an element to the end of the list.
    ///
    /// - complexity: O(1)
    /// - parameter value: The value to add
    public func append(value: T) {
        let previousEnd = end
        end = NodeType(value: value)
        
        end?.previous = previousEnd
        previousEnd?.next = end
        
        if count == 0 {
            start = end
        }
        
        count += 1
        
        assert(
            (end != nil && start != nil && count >= 1) || (end == nil && start == nil && count == 0),
            "Internal invariant not upheld at the end of remove"
        )
    }
}

extension LinkedList {
    
    /// Utility method to iterate over all nodes in the list invoking a block
    /// for each element and stopping if the block returns a non nil `NodeType`
    ///
    /// - complexity: O(n)
    /// - parameter block: A block to invoke for each element. Return the current node
    ///                    from this block to stop iteration
    ///
    /// - throws: Rethrows any values thrown by the block
    ///
    /// - returns: The node returned by the block if the block ever returns a node otherwise `nil`
    private func iterate(block: (NodeType, Int) throws -> NodeType?) rethrows -> NodeType? {
        var node = start
        var index = 0
        
        while node != nil {
            let result = try block(node!, index)
            if result != nil {
                return result
            }
            index += 1
            node = node?.next
        }
        
        return nil
    }
}

extension LinkedList {
    
    /// Return the node at a given index
    ///
    /// - complexity: O(n)
    /// - parameter index: The index in the list
    ///
    /// - returns: The node at the provided index.
    public func node(at index: Int) -> NodeType {
        precondition(index >= 0 && index < count, "Index \(index) out of bounds")
        
        let result = iterate {
            if $1 == index {
                return $0
            }
            
            return nil
        }
        
        return result!
    }
    
    /// Return the value at a given index
    ///
    /// - complexity: O(n)
    /// - parameter index: The index in the list
    ///
    /// - returns: The value at the provided index.
    public func value(at index: Int) -> T {
        let node = self.node(at: index)
        return node.value
    }
}

extension LinkedList {
    
    /// Remove a give node from the list
    ///
    /// - complexity: O(1)
    /// - parameter node: The node to remove
    public func remove(node: NodeType) {
        let nextNode = node.next
        let previousNode = node.previous
        
        if node === start && node === end {
            start = nil
            end = nil
        } else if node === start {
            start = node.next
        } else if node === end {
            end = node.previous
        }
        
        previousNode?.next = nextNode
        nextNode?.previous = previousNode
        
        node.next = nil
        node.previous = nil
        
        count -= 1
        assert(
            (end != nil && start != nil && count >= 1) || (end == nil && start == nil && count == 0),
            "Internal invariant not upheld at the end of remove"
        )
    }
    
    /// Remove a give node from the list at a given index
    ///
    /// - complexity: O(n)
    /// - parameter atIndex: The index of the value to remove
    public func remove(at index: Int) {
        precondition(index >= 0 && index < count, "Index \(index) out of bounds")
        
        // Find the node
        let result = iterate {
            if $1 == index {
                return $0
            }
            return nil
        }
        
        // Remove the node
        remove(node: result!)
    }
}

public struct LinkedListIterator<T>: IteratorProtocol {
    public typealias Element = Node<T>
    
    /// The current node in the iteration
    private var currentNode: Element?
    
    fileprivate init(startNode: Element?) {
        currentNode = startNode
    }
    
    public mutating func next() -> LinkedListIterator.Element? {
        let node = currentNode
        currentNode = currentNode?.next
        
        return node
    }
}

extension LinkedList: Sequence {
    public typealias Iterator = LinkedListIterator<T>
    
    public func makeIterator() -> LinkedList.Iterator {
        return LinkedListIterator(startNode: start)
    }
}
