//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public static func Parameter(index: Int) -> Identifier {
		return Source(Box(SourceIdentifier(base: nil, index: index)))
	}

	public static func Return(index: Int) -> Identifier {
		return Destination(Box(DestinationIdentifier(base: nil, index: index)))
	}


	// MARK: Cases

	case Source(Box<SourceIdentifier>)
	case Destination(Box<DestinationIdentifier>)
	case Base(BaseIdentifier)
	case Root


	// MARK: Printable

	public var description: String {
		switch self {
		case let Source(source):
			return source.description
		case let Destination(sink):
			return sink.description
		case let Base(base):
			return base.description
		case Root:
			return "/"
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return self.description.hashValue
	}
}


// MARK: - Equatable

public func == (left: Identifier, right: Identifier) -> Bool {
	switch (left, right) {
	case let (.Source(x), .Source(y)):
		return x.value.base?.uuid == y.value.base?.uuid && x.value.index == y.value.index
	case let (.Destination(x), .Destination(y)):
		return x.value.base?.uuid == y.value.base?.uuid && x.value.index == y.value.index
	case let (.Base(x), .Base(y)):
		return x.uuid == y.uuid
	case let (.Root, .Root):
		return true
	default:
		return false
	}
}


// MARK: - Component identifiers

public struct BaseIdentifier: Hashable, Printable {
	public init() {
		self.uuid = UUID()
	}


	// MARK: Hashable

	public var hashValue: Int {
		return uuid.hashValue
	}


	// MARK: Printable

	public var description: String {
		return uuid.description
	}


	// MARK: Private

	private let uuid: UUID
}

public func == (left: BaseIdentifier, right: BaseIdentifier) -> Bool {
	return left.uuid == right.uuid
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

public struct DestinationIdentifier: Printable {
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


// MARK: - Imports

import Box
