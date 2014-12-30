//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public init(source: SourceIdentifier, destination: DestinationIdentifier) {
		self.source = source
		self.destination = destination
	}

	public let source: SourceIdentifier
	public let destination: DestinationIdentifier


	// MARK: Hashable

	public var hashValue: Int {
		return source.hashValue ^ destination.hashValue
	}
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
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


	public var nodes: Set<Identifier> {
		didSet {
			edges = edges.filter {
				self.contains($0.source) && self.contains($0.destination)
			}
		}
	}

	public var edges: Set<Edge>
}


// MARK: - Imports

import Set
