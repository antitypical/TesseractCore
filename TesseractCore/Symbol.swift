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


	/// Case analysis.
	public func analysis<Result>(@noescape #ifNamed: (String, Term) -> Result, @noescape ifIndex: (Int, Term) -> Result) -> Result {
		switch self {
		case let Named(name, type):
			return ifNamed(name, type)
		case let Index(index, type):
			return ifIndex(index, type)
		}
	}


	public var name: String {
		return analysis(
			ifNamed: { $0.0 },
			ifIndex: { toString($0.0) })
	}

	public var type: Term {
		return analysis(
			ifNamed: { $1 },
			ifIndex: { $1 })
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


// MARK: - Imports

import Manifold
