//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Identifier: Comparable, Hashable, IntegerLiteralConvertible, Printable {
	public init(_ graph: Graph<Node>) {
		self.init(graph.nodes.isEmpty ? 0 : maxElement(graph.nodes.keys).value + 1)
	}

	public init(_ value: Int) {
		self.value = value
	}


	// MARK: Endpoint constructors

	public func input(index: Int) -> Edge.Destination {
		return (identifier: self, inputIndex: index)
	}

	public func output(index: Int) -> Edge.Source {
		return (identifier: self, outputIndex: index)
	}


	// MARK: Hashable

	public var hashValue: Int {
		return value.hashValue
	}


	// MARK: IntegerLiteralConvertible

	public init(integerLiteral: Int) {
		self.init(integerLiteral)
	}


	// MARK: Printable

	public var description: String {
		return value.description
	}


	// MARK: Private

	private let value: Int
}

public func == (left: Identifier, right: Identifier) -> Bool {
	return left.value == right.value
}

public func < (left: Identifier, right: Identifier) -> Bool {
	return left.value < right.value
}


// MARK: - Imports

import Prelude
