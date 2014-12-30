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


	// MARK: Primitive methods

	public func contains(identifier: BaseIdentifier) -> Bool {
		return nodes.contains(.Base(identifier))
	}

	public func contains(identifier: SourceIdentifier) -> Bool {
		return identifier.base.map { self.contains($0) } ?? nodes.contains(.Source(identifier))
	}

	public func contains(identifier: DestinationIdentifier) -> Bool {
		return identifier.base.map { self.contains($0) } ?? nodes.contains(.Destination(identifier))
	}


	public var nodes: Set<Identifier>
	public var edges: Set<Edge>
}


// MARK: - Imports

import Set
