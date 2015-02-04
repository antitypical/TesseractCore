//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type: Hashable, IntegerLiteralConvertible, Printable {
	public init(function name: String, _ from: Type, _ to: Type) {
		self = Function(name, Box(from), Box(to))
	}

	public init(function from: Type, _ to: Type) {
		self = Function(nil, Box(from), Box(to))
	}

	public init(integerLiteral value: IntegerLiteralType) {
		self = Parameter(value)
	}


	case Unit
	case Boolean
	case Parameter(Int)
	case Function(String?, Box<Type>, Box<Type>)


	public var arity: Int {
		return functionType.map { 1 + $1.arity } ?? 0
	}

	public var functionType: (Type, Type)? {
		switch self {
		case let Function(_, t1, t2):
			return (t1.value, t2.value)
		default:
			return nil
		}
	}


	private func parameters(n: Int) -> [(String, Type)] {
		switch self {
		case let Function(name, t1, t2):
			return [(name ?? n.description, t1.value)] + t2.value.parameters(name == nil ? 1 : 0)
		default:
			return []
		}
	}

	public var parameters: [(String, Type)] {
		return parameters(0)
	}


	// MARK: Hashable

	public var hashValue: Int {
		switch self {
		case let Parameter(index):
			return 380371373 ^ index
		case let Function(_, x, y):
			return 8471823991 ^ x.value.hashValue ^ y.value.hashValue
		case Boolean:
			return 6504993773
		case Unit:
			return 4024646491
		}
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Parameter(index):
			return index.description
		case let Function(name, parameterType, returnType):
			return "\(name): \(parameterType) → \(returnType)"
		case Boolean:
			return "Boolean"
		case Unit:
			return "Unit"
		}
	}
}


public func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case let (.Parameter(x), .Parameter(y)):
		return x == y
	case let (.Function(_, x1, x2), .Function(_, y1, y2)):
		return x1 == y1 && x2 == y2
	case (.Unit, .Unit), (.Boolean, .Boolean):
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
