//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable {
	// MARK: Cases

	case Parameter(Int)
	case Return(Int)
	case Node(String)


	// MARK: API

	public var stringValue: String {
		switch self {
		case let Parameter(x):
			return toString(x)
		case let Return(x):
			return toString(x)
		case let Node(x):
			return x
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return self.stringValue.hashValue
	}
}

public func == (left: Identifier, right: Identifier) -> Bool {
	return left.stringValue == right.stringValue
}
