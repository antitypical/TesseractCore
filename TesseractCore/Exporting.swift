//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map(serializeEdge <| graph))
	return "digraph tesseract {\n\(edges)\n}"
}


private func serializeEdge<T>(graph: Graph<T>, edge: Edge) -> String {
	let node = serializeNode <| graph
	return "\t\(node(edge.source.identifier)) -> \(node(edge.destination.identifier))\(serializeAttributes(attributes(edge)));"
}

private typealias Attributes = [String: String]

private func serializeAttributes(attributes: Attributes) -> String {
	let serialized = join(",", lazy(attributes).map { "\($0)=\($1)" })
	return attributes.count > 0 ? " [\(serialized)]" : ""
}

private func attributes(edge: Edge) -> Attributes {
	return [
		"taillabel": toString(edge.source.outputIndex),
		"sametail": toString(edge.source.outputIndex),
		"headlabel": toString(edge.destination.inputIndex),
		"samehead": toString(edge.destination.inputIndex),
		"labeldistance": "2",
	]
}

private func serializeNode<T>(graph: Graph<T>, identifier: Identifier) -> String {
	return "\"\(graph.nodes[identifier]!)\""
}


// MARK: - Imports

import Prelude
