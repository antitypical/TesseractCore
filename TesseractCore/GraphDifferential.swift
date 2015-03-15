//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferential<T: Equatable> {
	public let nodes: UnorderedDifferential<(Identifier, T)>
	public let edges: UnorderedDifferential<Edge>


	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> GraphDifferential {
		return GraphDifferential(nodes: DictionaryDifferential.differentiate(before: before.nodes, after: after.nodes), edges: SetDifferential.differentiate(before: before.edges, after: after.edges))
	}
}
