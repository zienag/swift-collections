/// Utilities to work with a collection of elements as a heap.

/// Arrange elements in a given collection to fulfill heap invariant.
/// - Parameters:
///   - xs: collection of elements
/// - Complexity: O(n) where n is the length of the collection.
@usableFromInline
internal func heapify<T: Comparable>(
  _ xs: inout [T]
) {
  let count = xs.distance(from: xs.startIndex, to: xs.endIndex)
  for i in (0..<count / 2).reversed() {
    siftDown(&xs, at: i)
  }
}

/// Returns the node of maximum value.
/// - Precondition: Input `xs` must be a valid max heap
/// - Parameters:
///   - xs: collection of elements with heap invariant
/// - Returns: The max element of the heap if the heap is
///   not empty; otherwise, `nil`.
/// - Complexity: O(log(n)) where n is the length of the collection.
@usableFromInline
internal func heapExtract<T: Comparable>(
  from xs: inout [T]
) -> T? {
  guard xs.count > 0 else { return nil }
  xs.swapAt(xs.startIndex, xs.index(before: xs.endIndex))
  let found = xs.popLast()
  siftDown(&xs, at: xs.startIndex)
  return found
}

/// Insert new element into the heap.
/// - Precondition: Input `xs` must be a valid max heap
/// - Parameters:
///   - xs: collection of elements with heap invariant
///   - element: element to insert
/// - Complexity: O(log(n)) where n is the length of the collection.
@usableFromInline
internal func heapInsert<T: Comparable>(
  into xs: inout [T],
  element: T
) {
  xs.append(element)
  siftUp(&xs, at: xs.index(before: xs.endIndex))
}

/// Pushes new element into the heap and pops greatest.
/// Equivalent to insert then extract, but runs more efficiently.
/// - Precondition: Input `xs` must be a valid max heap
/// - Parameters:
///   - xs: collection of elements with heap invariant
///   - element: element to insert
/// - Complexity: O(log(n)) where n is the length of the collection.
@usableFromInline
internal func heapPushPop<T: Comparable>(
  in xs: inout [T],
  with element: T
) -> T {
  guard let first = xs.first, first > element else {
    return element
  }
  xs[xs.startIndex] = element
  siftDown(&xs, at: xs.startIndex)
  return first
}

@inline(__always)
private func siftDown<T:Comparable>(
  _ xs: inout [T],
  at index: Int
) {
  var i = index
  while case let (left, right) = heapChildren(of: i),
    left < xs.endIndex,
    case let maxChild =
      (right >= xs.endIndex || xs[left] > xs[right]) ? left : right,
    xs[maxChild] > xs[i] {
    xs.swapAt(maxChild, i)
    i = maxChild
  }
}

@inline(__always)
private func siftUp<T: Comparable>(
  _ xs: inout [T],
  at index: Int
) {
  let element = xs[index]
  var current = index
  while case let parent = heapParent(of: current),
    parent >= xs.startIndex,
    element > xs[parent] {
    xs.swapAt(current, parent)
    current = parent
  }
}

@inline(__always)
private func heapChildren(of node: Int) -> (left: Int, right: Int) {
  let left = 2 * node + 1
  return (left, right: left + 1)
}

@inline(__always)
private func heapParent(of node: Int) -> Int {
  (node - 1) / 2
}
