//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct NodeView<T>: Equatable {
	public let graph: Graph<T>
	public let identifier: Identifier
	public let value: T

	public var inEdges: [Int: Set<EdgeView<T>>] {
		return lazy(graph.edges)
			.filter { $0.destination.identifier == self.identifier }
			.map { ($0.destination.inputIndex, EdgeView(graph: self.graph, edge: $0)) }
			|>	(flip(reduce) <| (+) <| [:])
	}

	public var inDegree: Int {
		return inEdges.count
	}

	public var outEdges: SequenceOf<EdgeView<T>> {
		return SequenceOf(lazy(graph.edges).filter { $0.source.identifier == self.identifier }.map { EdgeView(graph: self.graph, edge: $0) })
	}

	public var outDegree: Int {
		return reduce(lazy(outEdges).map(const(1)), 0, +)
	}
}

public func == <T> (left: NodeView<T>, right: NodeView<T>) -> Bool {
	return left.identifier == right.identifier
}


// MARK: - Imports

import Prelude
