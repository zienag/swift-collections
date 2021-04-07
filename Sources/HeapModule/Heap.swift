//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

/// Specialized tree-based data structure which is an almost
/// complete tree that satisfies the heap property: for any given node C,
/// if P is a parent node of C, then the key (the value) of P is
/// greater than or equal to the key of C. The node at the "top" of the heap
/// (with no parents) is called the root node.
///
/// https://en.wikipedia.org/wiki/Binary_heap
public struct Heap<Element: Comparable> {
  @usableFromInline
  internal var _guts: [Element]

  /// Find the greatest element (topmost)
  /// - Complexity: O(1)
  @inlinable
  public var peek: Element?  { _guts.first }

  /// Creates a heap containing the elements of a sequence.
  /// - Parameters:
  ///   - elements: The sequence of elements to turn into a heap.
  /// - Complexity: O(*n*) where *n* is the size of elements
  @inlinable public init<S: Sequence>(_ elements: S) where S.Element == Element {
    _guts = [Element](elements)
    heapify(&_guts)
  }

  /// Creates a new, empty heap.
  /// - Complexity: O(1)
  @inlinable public init() {
    _guts = []
  }

  /// Returns the maximum value from a heap after removing it if
  /// heap is not empty, nil otherwise.
  /// - Complexity: O(log(n)) where n is the length of the heap.
  @inlinable public mutating func pop() -> Element? {
    heapExtract(from: &_guts)
  }

  /// Adding a new value to the heap
  /// - Parameter element: new element to insert
  /// - Complexity: O(log(n)) where n is the length of the heap.
  @inlinable public mutating func push(_ element: Element) {
    heapInsert(into: &_guts, element: element)
  }


  /// Inserts item to the heap, then pops and returns the biggest item.
  /// The combined action runs more efficiently than push() followed by pop()
  /// - Parameter element: new element to insert
  /// - Complexity: O(log(n)) where n is the length of the heap.
  @inlinable public mutating func pushpop(_ element: Element) -> Element? {
    heapPushPop(in: &_guts, with: element)
  }

  /// Adds the elements of a sequence into heap.
  ///
  /// Runs more effective than inserting element one by one if size of this
  /// collection is big enough (approximately O(*n*/log(*n*)))
  ///
  /// - Parameters:
  ///   - xs: collection that will be extended and modified to fulfill heap
  ///   invariant
  ///   - newElements: contents of this collection will be appended to xs
  /// - Complexity: O(*n* + *m*), where *n* is the length of xs,
  /// *m* is the length of `elements`
  @inlinable public mutating func meld<S: Sequence>(
    _ elements: S
  ) where S.Element == Element {
    _guts.append(contentsOf: elements)
    heapify(&_guts)
  }
}
