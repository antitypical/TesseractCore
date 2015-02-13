//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map(serializeEdge <| graph))
	return "digraph tesseract {\n\(edges)\n}"
}


private func serializeEdge<T>(graph: Graph<T>, edge: Edge) -> String {
	return "\t\"\(graph.nodes[edge.source.identifier]!)\" -> \"\(graph.nodes[edge.destination.identifier]!)\";"
}


// MARK: - Imports

import Prelude
