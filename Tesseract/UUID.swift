//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A universally unique identifier.
public struct UUID: Comparable, Hashable, Printable {
	/// Generates a new UUID.
	public init() {
		// 16 bytes
		var value: [UInt8] = Array(count: 16, repeatedValue: 0)
		uuid_generate(&value)
		self.init(value: value)
	}


	// MARK: Printable

	public var description: String {
		// 36 characters + null byte
		var characters: [CChar] = Array(count: 37, repeatedValue: 0)
		uuid_unparse(value, &characters)
		return String.fromCString(characters)!
	}


	// MARK: Hashable

	public var hashValue: Int {
		return self.description.hashValue
	}


	// MARK: Private

	/// Construct with a uuid_t.
	private init(value: [UInt8]) {
		self.value = value
	}

	/// The underlying uuid_t.
	///
	/// This isn’t typed as such because Swift incorrectly ingests the uuid_t type as a 16-tuple of Int8.
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
