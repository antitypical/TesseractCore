//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Identifier: Hashable {
	// MARK: Cases

	case Parameter(Int)
	case Return(Int)
	case Node(String)


	// MARK: API

	public var stringValue: String {
		switch self {
		case let Parameter(x):
			return toString(x)
		case let Return(x):
			return toString(x)
		case Node:
			return ""
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


public struct Edge {
	public init(input: Identifier, output: Identifier) {
		self.input = input
		self.output = output
	}

	public let input: Identifier
	public let output: Identifier
}

public struct Graph {
	public init(title: String, nodes: [Identifier] = [], edges: [Edge] = []) {
		self.title = title
		self.nodes = nodes
		self.edges = edges
	}

	public let title: String

	public let nodes: [Identifier]
	public let edges: [Edge]
}
