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

	public func destructure<T, U, V, W>(constant: T -> W, _ function: (U -> V) -> W) -> W? {
		switch self {
		case let Constant(v as T):
			return constant(v as T)
		case let Function(f):
			return function(f as U -> Any as U -> V)
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
