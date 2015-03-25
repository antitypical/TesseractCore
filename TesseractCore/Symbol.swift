//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Symbol: Hashable, Printable {
	public static func named(name: String, _ type: Term) -> Symbol {
		return Named(name, type)
	}

	public static func index(index: Int, _ type: Term) -> Symbol {
		return Index(index, type)
	}


	case Named(String, Term)
	case Index(Int, Term)


	public var name: String {
		switch self {
		case let Named(name, _):
			return name
		case let Index(index, _):
			return index.description
		}
	}

	public var type: Term {
		switch self {
		case let Named(_, type):
			return type
		case let Index(_, type):
			return type
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	type.hashValue
	}


	// MARK: Printable

	public var description: String {
		let comma = ", "
		return "\(name) :: \(type)"
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	switch (left, right) {
	case let (.Named(x1, x2), .Named(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Index(x1, x2), .Index(y1, y2)):
		return x1 == y1 && x2 == y2
	default:
		return false
	}
}


// MARK: - Imports

import Manifold
