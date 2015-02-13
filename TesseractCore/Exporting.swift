//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(name: String, graph: Graph<T>) -> String {
	// NB: this would be lazy(graph).map(…) but for a compiler crash in Swift 1.2b1
	let nodes = join("\n", map(graph) { join("\n", serialize($0).map { "\t\($0);" }) })
	return "digraph \(name) {\n\(nodes)\n}"
}

private func serialize(identifier: Identifier) -> String {
	return "\"\(identifier)\""
}

private func serialize<T>(node: NodeView<T>) -> [String] {
	let attributes = ["label": "\(node.value)"]
	let edges = join([], lazy(node.outEdges).map { join([], map($1, serialize)) })
	return ["\(serialize(node.identifier))\(serialize(attributes))"] + edges
}

private func serialize<T>(edge: EdgeView<T>) -> [String] {
	return ["\(serialize(edge.edge.source.identifier)) -> \(serialize(edge.edge.destination.identifier))\(serialize(attributes(edge.edge)))"]
}

private typealias Attributes = [String: String]

private func serialize(attributes: Attributes) -> String {
	let serialized = join(",", lazy(attributes).map { "\($0)=\($1)" })
	return attributes.count > 0 ? " [\(serialized)]" : ""
}

private func attributes(edge: Edge) -> Attributes {
	return [
		"taillabel": toString(edge.source.outputIndex),
		"sametail": toString(edge.source.outputIndex),
		"headlabel": toString(edge.destination.inputIndex),
		"samehead": toString(edge.destination.inputIndex),
	]
}


// MARK: - Imports

import Prelude
