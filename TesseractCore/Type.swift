//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type: Hashable, IntegerLiteralConvertible, Printable {
	public init(function from: Type, _ to: Type) {
		self = Function(Box(from), Box(to))
	}

	public init(integerLiteral value: IntegerLiteralType) {
		self = Parameter(value)
	}


	case Unit
	case Boolean
	case Parameter(Int)
	case Function(Box<Type>, Box<Type>)


	public var arity: Int {
		return functionType.map { 1 + $1.arity } ?? 0
	}

	public var functionType: (Type, Type)? {
		switch self {
		case let Function(t1, t2):
			return (t1.value, t2.value)
		default:
			return nil
		}
	}


	public var parameters: [Type] {
		switch self {
		case let Function(t1, t2):
			return [t1.value] + t2.value.parameters
		default:
			return []
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		switch self {
		case let Parameter(index):
			return 380371373 ^ index
		case let Function(x, y):
			return 8471823991 ^ x.value.hashValue ^ y.value.hashValue
		case Boolean:
			return 6504993773
		case Unit:
			return 4024646491
		}
	}


	// MARK: Printable

	private static var alphabet = Array("abcdefghijklmnopqrstuvwxyz")

	public var description: String {
		switch self {
		case let Parameter(index):
			let laps = (index / Type.alphabet.count) + 1
			return String(count: laps, repeatedValue: Type.alphabet[index % Type.alphabet.count])
		case let Function(parameterType, returnType):
			return "\(parameterType) → \(returnType)"
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
	case let (.Function(x1, x2), .Function(y1, y2)):
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
