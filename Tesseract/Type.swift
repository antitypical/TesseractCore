//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type: Hashable, Printable {
	public init(function from: Type, _ to: Type) {
		self = Function(Box(from), Box(to))
	}


	case Parameter(Int)
	case Function(Box<Type>, Box<Type>)
	case Unit


	// MARK: Hashable

	public var hashValue: Int {
		switch self {
		case let Parameter(index):
			return 380371373 ^ index
		case let Function(x, y):
			return 8471823991 ^ x.value.hashValue ^ y.value.hashValue
		case Unit:
			return 4024646491
		}
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Parameter(index):
			return index.description
		case let Function(parameterType, returnType):
			return "\(parameterType) → \(returnType)"
		case Unit:
			return "Unit"
		}
	}
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


infix operator --> {
	associativity right
}

public func --> (left: Type, right: Type) -> Type {
	return Type(function: left, right)
}


// MARK: - Imports

import Box
