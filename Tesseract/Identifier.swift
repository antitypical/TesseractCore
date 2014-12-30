//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public static func Parameter(index: Int) -> Identifier {
		return Source(Box(SourceIdentifier(base: nil, index: index)))
	}

	public static func Return(index: Int) -> Identifier {
		return Sink(Box(SinkIdentifier(base: nil, index: index)))
	}


	// MARK: Cases

	case Source(Box<SourceIdentifier>)
	case Sink(Box<SinkIdentifier>)
	case Root


	// MARK: Printable

	public var description: String {
		switch self {
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
}

public struct BaseIdentifier: Printable {
	public init() {
		self.uuid = UUID()
	}


	// MARK: Printable

	public var description: String {
		return uuid.description
	}


	// MARK: Private

	private let uuid: UUID
}

public struct SourceIdentifier: Printable {
	public init(base: BaseIdentifier?, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: Printable

	public var description: String {
		return "\(base?.description ?? String())/sources/\(index)"
	}

	
	// MARK: Properties

	public let base: BaseIdentifier?
	public let index: Int
}

public struct SinkIdentifier: Printable {
	public init(base: BaseIdentifier?, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: Printable

	public var description: String {
		return "\(base?.description ?? String())/sources/\(index)"
	}


	// MARK: Properties
	
	public let base: BaseIdentifier?
	public let index: Int
}


public func == (left: Identifier, right: Identifier) -> Bool {
	return left.description == right.description
}


// MARK: - Imports

import Box
