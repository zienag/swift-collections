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

// This file contains exported but non-public entry points to support clear box
// testing.

extension Heap {
  @_spi(Testing)
  public var _storage: [Element] { _guts }
}
