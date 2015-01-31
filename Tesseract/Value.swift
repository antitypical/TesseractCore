//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Printable {
	public init(constant: Any) {
		self = Constant(constant)
	}

	public init(function: Any -> Any) {
		self = Function(function)
	}

	case Constant(Any)
	case Function(Any -> Any)

	public func constant<T, U>(f: T -> U) -> U? {
		switch self {
		case let Constant(v):
			return f(v as T)
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
