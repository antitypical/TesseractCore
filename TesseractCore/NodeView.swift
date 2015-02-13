//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct NodeView<T> {
	public let graph: Graph<T>
	public let identifier: Identifier

	public var inEdges: SequenceOf<Edge> {
		return SequenceOf(lazy(graph.edges).filter { $0.destination.identifier == self.identifier })
	}

	public var inDegree: Int {
		return reduce(lazy(inEdges).map(const(1)), 0, +)
	}

	public var outEdges: SequenceOf<Edge> {
		return SequenceOf(lazy(graph.edges).filter { $0.source.identifier == self.identifier })
	}
}

public func == <T: Equatable> (left: NodeView<T>, right: NodeView<T>) -> Bool {
	return
		left.identifier == right.identifier
	&&	left.graph == right.graph
}


// MARK: - Imports

import Prelude
