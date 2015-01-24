//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable, Printable {
	// MARK: Cases

	case Input(Int)
	case Output(Int)
	case Node(NodeIdentifier)


	// MARK: Printable

	public var description: String {
		switch self {
		case let Input(index):
			return index.description
		case let Output(index):
			return index.description
		case let Node(identifier):
			return identifier.description
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		switch self {
		case let Input(index):
			return index.hashValue
		case let Output(index):
			return index.hashValue
		case let Node(identifier):
			return identifier.hashValue
		}
	}
}


// MARK: - Equatable

public func == (left: Identifier, right: Identifier) -> Bool {
	switch (left, right) {
	case let (.Input(leftIndex), .Input(rightIndex)):
		return leftIndex == rightIndex
	case let (.Output(leftIndex), .Output(rightIndex)):
		return leftIndex == rightIndex
	case let (.Node(leftIdentifier), .Node(rightIdentifier)):
		return leftIdentifier == rightIdentifier
	default:
		return false
	}
}


// MARK: - Component identifiers

public enum SourceIdentifier: Hashable, Printable {
	case Input(Int)
	case Node(NodeIdentifier, Int)


	// MARK: Destructuring

	public var destructured: (NodeIdentifier?, Int) {
		switch self {
		case let Input(index):
			return (nil, index)
		case let Node(identifier, index):
			return (identifier, index)
		}
	}

	public var identifier: Identifier {
		switch self {
		case let Input(index):
			return .Input(index)
		case let Node(identifier, index):
			return .Node(identifier)
		}
	}


	// MARK: Printable

	public var description: String {
		return destructured |> { identifier, index in
			identifier.map { "\($0)/\(index)" } ?? "\(index)"
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return destructured |> { identifier, index in
			identifier.map { $0.hashValue ^ index.hashValue } ?? index.hashValue
		}
	}
}

public func == (left: SourceIdentifier, right: SourceIdentifier) -> Bool {
	let (leftIdentifier, leftIndex) = left.destructured
	let (rightIdentifier, rightIndex) = right.destructured
	return leftIdentifier == rightIdentifier && leftIndex == rightIndex
}


public enum DestinationIdentifier: Hashable, Printable {
	case Output(Int)
	case Node(NodeIdentifier, Int)


	// MARK: Destructuring

	public var destructured: (NodeIdentifier?, Int) {
		switch self {
		case let Output(index):
			return (nil, index)
		case let Node(identifier, index):
			return (identifier, index)
		}
	}

	public var identifier: Identifier {
		switch self {
		case let Output(index):
			return .Output(index)
		case let Node(identifier, index):
			return .Node(identifier)
		}
	}


	// MARK: Printable

	public var description: String {
		return destructured |> { identifier, index in
			identifier.map { "\($0)/\(index)" } ?? "\(index)"
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return destructured |> { identifier, index in
			identifier.map { $0.hashValue ^ index.hashValue } ?? index.hashValue
		}
	}
}

public func == (left: DestinationIdentifier, right: DestinationIdentifier) -> Bool {
	let (leftIdentifier, leftIndex) = left.destructured
	let (rightIdentifier, rightIndex) = right.destructured
	return leftIdentifier == rightIdentifier && leftIndex == rightIndex
}


public struct NodeIdentifier: Hashable, Printable {
	public init() {
		self.value = NodeIdentifier.cursor++
	}

	public var identifier: Identifier {
		return .Node(self)
	}

	public func input(index: Int) -> DestinationIdentifier {
		return .Node(self, index)
	}

	public func output(index: Int) -> SourceIdentifier {
		return .Node(self, index)
	}


	// MARK: Hashable

	public var hashValue: Int {
		return value.hashValue
	}


	// MARK: Printable

	public var description: String {
		return value.description
	}


	// MARK: Private

	private let value: Int

	private static var cursor = 0
}

public func == (left: NodeIdentifier, right: NodeIdentifier) -> Bool {
	return left.value == right.value
}


// MARK: - Imports

import Prelude
