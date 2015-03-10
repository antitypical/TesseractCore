//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol DifferentialType {
	typealias Differentiable

	static func differentiate(#before: Differentiable, after: Differentiable) -> Self
}


// MARK: - Graph

public struct GraphDifferential<T>: DifferentialType {
	public let nodes: DictionaryDifferential<Identifier, T>
	public let edges: SetDifferential<Edge>

	// MARK: DifferentialType

	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> GraphDifferential {
		return GraphDifferential(nodes: .differentiate(before: before.nodes, after: after.nodes), edges: .differentiate(before: before.edges, after: after.edges))
	}
}
