//  Copyright (c) 2015 Rob Rix. All rights reserved.

private let digit: Parser<String, String>.Function = %("0"..."9")
private let lowercase: Parser<String, String>.Function = %("a"..."z")
private let uppercase: Parser<String, String>.Function = %("A"..."Z")
private let ws: Parser<String, Ignore>.Function = ignore(%" " | %"\t" | %"\n")+
private let quot: Parser<String, Ignore>.Function = ignore("\"")
private let word: Parser<String, String>.Function = (lowercase | uppercase | digit)+ --> { "".join($0) }
private let string: Parser<String, String>.Function = quot ++ word ++ quot

private let title: Parser<String, String>.Function = ignore("digraph ") ++ word ++ ignore(" {")
private let sourceAndIdentifier: Parser<String, (String, String)>.Function = string ++ ignore(" -> ") ++ string
private let edge: Parser<String, (String, String, [String: String])>.Function = ws ++ sourceAndIdentifier ++ ws ++ attributes ++ ignore(";\n") --> { ($0.0, $0.1, $1) }

private let attribute: Parser<String, (String, String)>.Function = word ++ ignore("=") ++ word
private let comma: Parser<String, Ignore>.Function = ws ++ ignore(",") ++ ws
private let attributeList: Parser<String, [String: String]>.Function = attribute ++ (comma ++ attribute)* --> { Dictionary([ $0 ] + $1) }
private let attributes: Parser<String, [String: String]>.Function = (ignore("[") ++ attributeList ++ ignore("]")) | { _, index in ([:], index) }

private let graph: Parser<String, Graph<String>>.Function = edge+ --> { _, _, edges in
	let nodeData = lazy(Set(lazy(edges).flatMap { source, destination, _ in [source, destination] })).map { (Identifier(), $0) }
	let nodeIdentifiers = Dictionary(nodeData.map(swap))
	let nodes = Dictionary(nodeData)
	let ed = lazy(edges).map { source, destination, attributes in
		(nodeIdentifiers[source] &&& nodeIdentifiers[destination]).map { Edge(($0, attributes["headlabel"]?.toInt() ?? 0), ($1, attributes["sametail"]?.toInt() ?? 0)) }
	}
	let edges: Set<Edge> = reduce(ed, []) { edges, edge in
		edges.union(edge.map { [ $0 ] } ?? [])
	}
	return Graph(nodes: nodes, edges: edges)
}

// GraphViz (.dot) file spec: http://graphviz.org/content/dot-language
public func importDOT(string: String) -> (String, Graph<String>)? {
	return parse(title ++ graph ++ ignore("}"), string)
}

// MARK: - Imports

import Prelude
import Madness
