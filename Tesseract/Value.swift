//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value {
	case Constant(Type, Any)
	case Function(Type, Type, Any -> Any)


	public var type: Type {
		switch self {
		case let Constant(type, _):
			return type
		case let Function(a, b, _):
			return Type(function: a, b)
		}
	}
}
