//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Printable {
	public init(constant: Any) {
		self = Constant(Box(constant))
	}

	public init(function: Any -> Any) {
		self = Function(Box(function))
	}

	case Constant(Box<Any>)
	case Function(Box<Any -> Any>)

	public func constant<T, U>(f: T -> U) -> U? {
		switch self {
		case let Constant(v):
			return f(v.value as T)
		default:
			return nil
		}
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Constant(c):
			return ".Constant(\(toString(c))"
		case let Function(f):
			return ".Function(f)"
		}
	}
}


// MARK: - Imports

import Box
