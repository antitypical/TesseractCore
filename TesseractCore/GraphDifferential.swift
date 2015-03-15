//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferential<T: Equatable>: DifferentiatorType {
	public let nodes: DictionaryDifferential<Identifier, T>
	public let edges: SetDifferential<Edge>


	// MARK: DifferentialType

	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> GraphDifferential {
		return GraphDifferential(nodes: .differentiate(before: before.nodes, after: after.nodes), edges: .differentiate(before: before.edges, after: after.edges))
	}
}
