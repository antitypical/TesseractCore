//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public init(input: SourceIdentifier, output: DestinationIdentifier) {
		self.input = input
		self.output = output
	}

	public let input: SourceIdentifier
	public let output: DestinationIdentifier


	// MARK: Hashable

	public var hashValue: Int {
		return input.hashValue ^ output.hashValue
	}
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.input == right.input && left.output == right.output
}


public struct Graph {
	public init(nodes: Set<Identifier> = [], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
	}

	public let nodes: Set<Identifier>
	public let edges: Set<Edge>
}


// MARK: - Imports

import Set
