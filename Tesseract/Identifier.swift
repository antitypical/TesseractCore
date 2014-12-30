//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public static func Parameter(source: SourceIdentifier) -> Identifier {
		return Source(Box(source))
	}

	public static func Return(sink: SinkIdentifier) -> Identifier {
		return Sink(Box(sink))
	}


	// MARK: Cases

	case Key(Box<Identifier>, String)
	case Source(Box<SourceIdentifier>)
	case Sink(Box<SinkIdentifier>)
	case Root


	// MARK: Printable

	public var description: String {
		switch self {
		case let Key(base, x):
			return base.value.append(x)
		case let Source(source):
			return toString(source)
		case let Sink(sink):
			return toString(sink)
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

public struct SourceIdentifier: IntegerLiteralConvertible, Printable {
	public init(base: Identifier, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: IntegerLiteralConvertible

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(base: .Root, index: value)
	}


	// MARK: Printable

	public var description: String {
		return base.append(index)
	}

	
	// MARK: Properties

	public let base: Identifier
	public let index: Int
}

public struct SinkIdentifier: IntegerLiteralConvertible, Printable {
	public init(base: Identifier, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: IntegerLiteralConvertible

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(base: .Root, index: value)
	}


	// MARK: Printable

	public var description: String {
		return base.append(index)
	}


	// MARK: Properties
	
	public let base: Identifier
	public let index: Int
}


public func == (left: Identifier, right: Identifier) -> Bool {
	return left.description == right.description
}


// MARK: - Imports

import Box
