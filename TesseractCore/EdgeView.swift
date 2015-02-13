//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct EdgeView<T>: Hashable {
	public let graph: Graph<T>
	internal let edge: Edge

	public var source: (NodeView<T>, Int) {
		return (graph[edge.source.identifier]!, edge.source.outputIndex)
	}

	public var destination: (NodeView<T>, Int) {
		return (graph[edge.destination.identifier]!, edge.destination.inputIndex)
	}


	// MARK: HashValue

	public var hashValue: Int {
		return edge.hashValue
	}
}


// MARK: Equatable

public func == <T> (left: EdgeView<T>, right: EdgeView<T>) -> Bool {
	return left.edge == right.edge
}
