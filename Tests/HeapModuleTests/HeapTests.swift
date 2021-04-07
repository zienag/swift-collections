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

import XCTest

import CollectionsTestSupport
@_spi(Testing) import HeapModule

class HeapTests: CollectionTestCase {
  func test_HeapProperty() {
    var heap = Heap([1, 2, 3, 0, -3, 2, 1])
    expectTrue(heap.isValidMaxHeap)

    heap.push(-4)
    heap.push(4)
    expectTrue(heap.isValidMaxHeap)

    let first = heap.pop()
    let second = heap.pop()
    expectEqual(first, 4)
    expectEqual(second, 3)
    expectTrue(heap.isValidMaxHeap)
  }

  func test_PopsMaximumElement() {
    var heap = Heap([0, -1, 1, -2, 2, -3, 3])

    expectEqual(heap.popAll(), [3, 2, 1, 0, -1, -2, -3])
  }

  func test_HeapPush() {
    var heap = Heap([0])

    heap.push(1)
    heap.push(-1)
    heap.push(2)
    heap.push(-2)

    expectEqual(heap.popAll(), [2, 1, 0, -1, -2])
  }

  func test_PushPop() {
    var heap = Heap([0])

    expectEqual(heap.pushpop(2), 2)
    expectEqual(heap.pushpop(-2), 0)
  }

  func test_Peek() {
    var heap = Heap([1, 2, 3])

    expectEqual(heap.peek, 3)
    _ = heap.pop()
    expectEqual(heap.peek, 2)
    _ = heap.pop()
    expectEqual(heap.peek, 1)
    _ = heap.pop()
    expectEqual(heap.peek, nil)
  }

  func test_EmptyHeap() {
    var heap = Heap<Int>()

    expectEqual(heap.pop(), nil)
    expectEqual(heap.pushpop(0), 0)
    expectEqual(heap.pop(), nil)
    heap.push(1)
    expectEqual(heap.pop(), 1)
    expectEqual(heap.pop(), nil)
  }

  func test_CustomComparable() {
    enum Priority: Comparable {
      case low
      case medium
      case high
    }

    var heap = Heap<Priority>([.medium, .high, .low])
    expectEqual(heap.pop(), .high)
    expectEqual(heap.pop(), .medium)
    expectEqual(heap.pop(), .low)
    expectEqual(heap.pop(), nil)
  }

  func test_Meld() {
    var heap = Heap([0, 1, 2])
    heap.meld([-2, -1, 3, 4])

    expectTrue(heap.isValidMaxHeap)
    expectEqual(heap.popAll(), [4, 3, 2, 1, 0, -1, -2])
  }
}

extension Heap {
  fileprivate var isValidMaxHeap: Bool {
    let internalStorage = _storage
    return internalStorage.enumerated().allSatisfy { i, el in
      let right = i * 2 + 1
      let left = right + 1
      return (right >= internalStorage.count || internalStorage[right] <= el)
        && (left >= internalStorage.count || internalStorage[right] <= el)
    }
  }

  fileprivate mutating func popAll() -> [Element] {
    var result = [Element]()
    while let element = pop() {
      result.append(element)
    }
    return result
  }
}
