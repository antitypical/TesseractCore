//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Constructors

	public static func Parameter(index: Int) -> Identifier {
		return Source(SourceIdentifier(base: nil, index: index))
	}

	public static func Return(index: Int) -> Identifier {
		return Destination(DestinationIdentifier(base: nil, index: index))
	}

	public static func Node() -> Identifier {
		return Base(BaseIdentifier())
	}


	// MARK: Cases

	case Source(SourceIdentifier)
	case Destination(DestinationIdentifier)
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
		switch self {
		case .Source, .Destination, .Root:
			return self.description.hashValue
		case let .Base(identifier):
			return identifier.hashValue
		}
	}
}


// MARK: - Equatable

public func == (left: Identifier, right: Identifier) -> Bool {
	switch (left, right) {
	case let (.Source(x), .Source(y)):
		return x == y
	case let (.Destination(x), .Destination(y)):
		return x == y
	case let (.Base(x), .Base(y)):
		return x == y
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


public struct SourceIdentifier: Hashable, Printable {
	public init(base: BaseIdentifier?, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: Hashable

	public var hashValue: Int {
		return (base?.hashValue ?? 0) ^ "sources".hashValue ^ index.hashValue
	}


	// MARK: Printable

	public var description: String {
		return "\(base?.description ?? String())/sources/\(index)"
	}

	
	// MARK: Properties

	public let base: BaseIdentifier?
	public let index: Int
}

public func == (left: SourceIdentifier, right: SourceIdentifier) -> Bool {
	return left.base == right.base && left.index == right.index
}


public struct DestinationIdentifier: Hashable, Printable {
	public init(base: BaseIdentifier?, index: Int) {
		self.base = base
		self.index = index
	}


	// MARK: Hashable

	public var hashValue: Int {
		return (base?.hashValue ?? 0) ^ "destinations".hashValue ^ index.hashValue
	}


	// MARK: Printable

	public var description: String {
		return "\(base?.description ?? String())/destinations/\(index)"
	}


	// MARK: Properties
	
	public let base: BaseIdentifier?
	public let index: Int
}

public func == (left: DestinationIdentifier, right: DestinationIdentifier) -> Bool {
	return left.base == right.base && left.index == right.index
}
