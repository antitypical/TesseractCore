//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type: Equatable {
	public init(function from: Type, _ to: Type) {
		self = Function(Box(from), Box(to))
	}


	case Parameter(Int)
	case Function(Box<Type>, Box<Type>)
	case Unit
}


public func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case let (.Parameter(x), .Parameter(y)):
		return x == y
	case let (.Function(x1, x2), .Function(y1, y2)):
		return x1 == y1 && x2 == y2
	case (.Unit, .Unit):
		return true

	default:
		return false
	}
}


// MARK: - Imports

import Box
