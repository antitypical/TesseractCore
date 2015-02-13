//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map(serializeEdge <| graph))
	return "digraph tesseract {\n\(edges)\n}"
}


private func serializeEdge<T>(graph: Graph<T>, edge: Edge) -> String {
	let node = serializeNode <| graph
	return "\t\(node(edge.source.identifier)) -> \(node(edge.destination.identifier));"
}

private func serializeNode<T>(graph: Graph<T>, identifier: Identifier) -> String {
	return "\"\(graph.nodes[identifier]!)\""
}


// MARK: - Imports

import Prelude
