//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public init(_ source: SourceIdentifier, _ destination: DestinationIdentifier) {
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


public struct Graph<T> {
	public init(nodes: [Identifier: T] = [:], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
	}


	// MARK: Primitive methods

	public var nodes: [Identifier: T] {
		willSet {
			let removed = Set(nodes.keys) - Set(newValue.keys)
			if removed.count == 0 { return }
			edges = edges.filter {
				!removed.contains($0.source.identifier) && !removed.contains($0.destination.identifier)
			}
		}
	}

	public var edges: Set<Edge> {
		didSet {
			let added = edges - oldValue
			if added.count == 0 { return }
			let keys = nodes.keys
			edges -= added.filter {
				!contains(keys, $0.source.identifier) && !contains(keys, $0.destination.identifier)
			}
		}
	}
}


// MARK: - Imports

import Set
