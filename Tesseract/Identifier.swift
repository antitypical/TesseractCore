//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable {
	// MARK: Constructors

	public init() {
		self = Base(UUID())
	}


	// MARK: Cases

	case Parameter(Int)
	case Return(Int)
	case Base(UUID)


	// MARK: API

	public var stringValue: String {
		switch self {
		case let Parameter(x):
			return toString(x)
		case let Return(x):
			return toString(x)
		case let Base(x):
			return x.stringValue
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

import Darwin.uuid
