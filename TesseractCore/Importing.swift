//  Copyright (c) 2015 Rob Rix. All rights reserved.

private func unique<T: Hashable>(list: [T]) -> [T] {
	return Array(Set(list))
}

public func parseEdge(edge: String) -> (String, String)? {
	let characterParser = %("0"..."9") | %("a"..."z") | %("A"..."Z")
	let ignoreBeginningOfLine = ignore("\t") ++ ignore("\"")
	let edgeParser = ignoreBeginningOfLine ++ characterParser+ ++ ignore("\" -> \"") ++ characterParser+ ++ ignore("\";");
	if let (rawSource, rawDestination) = edgeParser(edge)?.0 {
		let source = String(rawSource.reduce([], combine: +))
		let destination = String(rawDestination.reduce([], combine: +))
		return (source, destination)
	}

	return nil
}

// GraphViz (.dot) file spec: http://graphviz.org/content/dot-language
public func importDOT(file: String) -> Graph<String> {
	// Skip the title.
	let lines = split(file, { $0 == "\n" })
	let rawLines = lines[1...(lines.count - 2)]
	let rawEdges = map(rawLines, { edge in parseEdge(edge) ?? ("", "")})
	let rawSources = map(rawEdges, { edge in edge.0 })
	let rawDestinations = map(rawEdges, { edge in edge.1 })
	let rawNodes = rawSources + rawDestinations
	let uniqueNodes = unique(rawNodes)
	let nodeIdentifiers = map(uniqueNodes, const(Identifier())
	var inputCount = map(uniqueNodes, const(0))
	var outputCount = inputCount
    
	let edges: [Edge] = map(rawEdges) { edge in
		let (sourceString, destinationString) = edge
		let sourceIndex = find(uniqueNodes, sourceString) ?? 0
		let destinationIndex = find(uniqueNodes, destinationString) ?? 0
		let sourceOutputNumber = outputCount[sourceIndex] + 1
		let destinationInputNumber = inputCount[sourceIndex] + 1
		let source = (nodeIdentifiers[sourceIndex], sourceOutputNumber)
		let destination = (nodeIdentifiers[destinationIndex], destinationInputNumber)
		return Edge(source, destination)
	}
    
	let nodes = uniqueNodes.reduce([], combine: { (accum: [Identifier: String], curr: String) in
		let identifierIndex = find(uniqueNodes, curr) ?? 0
		let identifier = nodeIdentifiers[identifierIndex]
		return accum + [identifier: curr]
    })
    
	return Graph(nodes: nodes, edges: Set(edges))
}

// MARK: - Imports

import Set
import Prelude
import Madness
