//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct NodeView<T> {
	public let graph: Graph<T>
	public let identifier: Identifier
}

public func == <T: Equatable> (left: NodeView<T>, right: NodeView<T>) -> Bool {
	return
		left.identifier == right.identifier
	&&	left.graph == right.graph
}
