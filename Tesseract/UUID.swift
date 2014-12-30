//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct UUID: Comparable {
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


// MARK: - Comparable

public func < (left: UUID, right: UUID) -> Bool {
	return uuid_compare(left.value, right.value) < 0
}


// MARK: - Equatable

public func == (left: UUID, right: UUID) -> Bool {
	return uuid_compare(left.value, right.value) == 0
}


// MARK: - Imports

import Darwin.uuid
