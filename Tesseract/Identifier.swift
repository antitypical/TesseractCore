//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public static func Parameter(index: Int) -> Identifier {
		return Index(Box(Key(Box(Root), "parameter")), index)
	}

	public static func Return(index: Int) -> Identifier {
		return Index(Box(Key(Box(Root), "return")), index)
	}


	// MARK: Cases

	case Key(Box<Identifier>, String)
	case Index(Box<Identifier>, Int)
	case Source(Box<SourceIdentifier>)
	case Sink(Box<SinkIdentifier>)
	case Root


	// MARK: Printable

	public var description: String {
		switch self {
		case let Key(base, x):
			return base.value.append(x)
		case let Index(base, x):
			return base.value.append(x)
		case let Source(source):
			return source.value.base.append(source.value.index)
		case let Sink(sink):
			return sink.value.base.append(sink.value.index)
		case Root:
			return "/"
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return self.description.hashValue
	}


	// MARK: Private

	private func append<T>(child: T) -> String {
		switch self {
		case Root:
			return toString(child)
		default:
			return "\(self)/\(child)"
		}
	}
}

public struct SourceIdentifier: IntegerLiteralConvertible {
	public init(base: Identifier, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: IntegerLiteralConvertible

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(base: .Root, index: value)
	}


	// MARK: Properties

	public let base: Identifier
	public let index: Int
}

public struct SinkIdentifier: IntegerLiteralConvertible {
	public init(base: Identifier, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: IntegerLiteralConvertible

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(base: .Root, index: value)
	}


	// MARK: Properties
	
	public let base: Identifier
	public let index: Int
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
