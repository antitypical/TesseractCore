//  Copyright (c) 2015 Rob Rix. All rights reserved.

private func log<C: CollectionType, T>(parser: (Parser<C, T>.Function), function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) -> Parser<C, T>.Function {
	return log(nil, parser, function: function, file: file, line: line, column: column)
}

private func log<C: CollectionType, T>(message: String?, parser: (Parser<C, T>.Function), function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) -> Parser<C, T>.Function {
	return { collection, index in
		let trace = "\(file):\(line):\(column):\(function):" + (message.map { " \($0)" } ?? "")
		if let (tree, rest) = parser(collection, index) {
			println("\(trace) matched in \(index)..<\(rest)")
			return (tree, rest)
		}
		println("\(trace) unmatched at \(index)")
		return nil
	}
}

private let digit: Parser<String, String>.Function = %("0"..."9")
private let lowercase: Parser<String, String>.Function = %("a"..."z")
private let uppercase: Parser<String, String>.Function = %("A"..."Z")
private let ws: Parser<String, Ignore>.Function = ignore(%" " | %"\t" | %"\n")+
private let quot: Parser<String, Ignore>.Function = ignore("\"")
private let word: Parser<String, String>.Function = (lowercase | uppercase | digit)+ --> { "".join($0) }
private let string: Parser<String, String>.Function = quot ++ word ++ quot

private let title: Parser<String, String>.Function = ignore("digraph ") ++ word ++ ignore(" {")
private let sourceAndIdentifier: Parser<String, (String, String)>.Function = string ++ ignore(" -> ") ++ string
private let terminator = ignore(";") ++ ws
private let edge: Parser<String, (String, String, [String: String])>.Function = ws ++ sourceAndIdentifier ++ ws ++ attributes ++ terminator --> { ($0.0, $0.1, $1) }

private let attribute: Parser<String, (String, String)>.Function = word ++ ignore("=") ++ word
private let comma: Parser<String, Ignore>.Function = ws ++ ignore(",") ++ ws
private let attributeList: Parser<String, [String: String]>.Function = attribute ++ (comma ++ attribute)* --> { Dictionary([ $0 ] + $1) }
private let attributes: Parser<String, [String: String]>.Function = (ignore("[") ++ attributeList ++ ignore("]")) | { _, index in ([:], index) }

private let graph: Parser<String, Graph<String>>.Function = edge+ --> { _, _, edges in
	let nodeData = lazy(Set(lazy(edges).flatMap { source, destination, _ in [source, destination] })).map { (Identifier(), $0) }
	let nodeIdentifiers = Dictionary(nodeData.map(swap))
	let nodes = Dictionary(nodeData)
	let ed = lazy(edges).map { source, destination, attributes in
		(nodeIdentifiers[source] &&& nodeIdentifiers[destination]).map { Edge(($0, attributes["sametail"]?.toInt() ?? 0), ($1, attributes["headlabel"]?.toInt() ?? 0)) }
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
