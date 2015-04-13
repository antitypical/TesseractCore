//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct NodeView<T>: Equatable {
	public let graph: Graph<T>
	public let identifier: Identifier
	public let value: T
}

public func == <T> (left: NodeView<T>, right: NodeView<T>) -> Bool {
	return left.identifier == right.identifier
}


// MARK: - Imports

import Prelude
