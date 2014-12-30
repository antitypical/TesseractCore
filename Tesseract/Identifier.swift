//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public init() {
		self = Base(UUID().stringValue)
	}


	// MARK: Cases

	case Parameter(Int)
	case Return(Int)
	case Key(Box<Identifier>, String)
	case Index(Box<Identifier>, Int)
	case Base(String)


	// MARK: Printable

	public var description: String {
		switch self {
		case let Parameter(x):
			return toString(x)
		case let Return(x):
			return toString(x)
		case let Key(base, x):
			return base.value.append(x)
		case let Index(base, x):
			return base.value.append(x)
		case let Base(x):
			return x
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return self.description.hashValue
	}


	// MARK: Private

	private func append<T>(child: T) -> String {
		return "\(self)/\(child)"
	}
}

public func == (left: Identifier, right: Identifier) -> Bool {
	return left.description == right.description
}


public struct UUID {
	public init() {
		var value: [UInt8] = Array(count: 16, repeatedValue: 0)
		uuid_generate(&value)
		self.init(value: value)
	}


	public var stringValue: String {
		var characters: [CChar] = Array(count: 37, repeatedValue: 0)
		uuid_unparse(value, &characters)
		return String.fromCString(characters)!
	}


	// MARK: Private

	private init(value: [UInt8]) {
		self.value = value
	}

	private let value: [UInt8]
}


// MARK: - Imports

import Box
import Darwin.uuid
