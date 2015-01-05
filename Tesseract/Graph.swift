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


	// MARK: Private

	private func intersects(nodes: Set<Identifier>) -> Bool {
		return nodes.contains(containingIdentifier(source)) || nodes.contains(containingIdentifier(destination))
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

	public var nodes: Set<Identifier> {
		willSet {
			let removed = nodes - newValue
			if removed.count == 0 { return }
			edges = edges.filter { !$0.intersects(removed) }
		}
	}

	public var edges: Set<Edge> {
		didSet {
			let added = edges - oldValue
			if added.count == 0 { return }
			edges -= added.filter { !$0.intersects(self.nodes) }
		}
	}
}


// MARK: - Imports

import Set
