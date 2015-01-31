//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Printable {
	public init(constant: Any) {
		self = Constant(Box(constant))
	}

	public init<T, U>(function: T -> U) {
		self = Function(Box(function))
	}

	case Constant(Box<Any>)
	case Function(Box<Any>)

	public func constant<T>() -> T? {
		switch self {
		case let Constant(v):
			return v.value as? T
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
