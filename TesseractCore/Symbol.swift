//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Symbol: Hashable, Printable {
	public init(_ name: String, _ type: Type) {
		self = Named(name, type)
	}

	public init(_ index: Int, _ type: Type) {
		self = Parameter(index, type)
	}


	case Named(String, Type)
	case Parameter(Int, Type)


	public var name: String {
		switch self {
		case let Named(name, _):
			return name
		case let Parameter(index, _):
			return index.description
		}
	}

	public var type: Type {
		switch self {
		case let Named(_, type):
			return type
		case let Parameter(_, type):
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
	return
		left.name == right.name
	&&	left.type == right.type
}
