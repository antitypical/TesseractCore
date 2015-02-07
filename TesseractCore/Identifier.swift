//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Identifier: Comparable, Hashable, Printable {
	public init() {
		self.value = Identifier.cursor++
	}

    internal init(value: Int) {
        self.value = value
        Identifier.cursor = value
    }
    
	// MARK: Endpoint constructors

	public func input(index: Int) -> Edge.Destination {
		return (identifier: self, inputIndex: index)
	}

	public func output(index: Int) -> Edge.Source {
		return (identifier: self, outputIndex: index)
	}


	// MARK: Hashable

	public var hashValue: Int {
		return value.hashValue
	}


	// MARK: Printable

	public var description: String {
		return value.description
	}


	// MARK: Private

	private let value: Int

	private static var cursor = 0
}

public func == (left: Identifier, right: Identifier) -> Bool {
	return left.value == right.value
}

public func < (left: Identifier, right: Identifier) -> Bool {
	return left.value < right.value
}


// MARK: - Imports

import Prelude
