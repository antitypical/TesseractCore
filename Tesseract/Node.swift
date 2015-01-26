//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node {
	case Parameter(String)
	case Return(String)
	case Abstraction(Symbol)

	public var inputs: [String] {
		switch self {
		case Parameter:
			return []
		case let Return(name):
			return [ name ]
		case let Abstraction(symbol):
			return symbol.parameters
		}
	}

	public var outputs: [String] {
		switch self {
		case let Parameter(name):
			return [ name ]
		case Return:
			return []
		case let Abstraction(symbol):
			return symbol.returns
		}
	}
}
