//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value {
	case Constant(Any)
	case Function(Any -> Any)

	public func destructure<T, U, V, W>(constant: T -> W, _ function: (U -> V) -> W) -> W {
		switch self {
		case let Constant(v):
			return constant(v as T)
		case let Function(f):
			return function(f as U -> Any as U -> V)
		}
	}
}
