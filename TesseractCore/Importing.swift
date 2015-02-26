//  Copyright (c) 2015 Rob Rix. All rights reserved.

private func log<C: CollectionType, T>(parser: (Parser<C, T>.Function), function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) -> Parser<C, T>.Function {
	return log(nil, parser, function: function, file: file, line: line, column: column)
}

private func log<C: CollectionType, T>(message: String?, parser: (Parser<C, T>.Function), function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__) -> Parser<C, T>.Function {
	return { collection, index in
		let trace = "\(file):\(line):\(column):\(function):" + (message.map { " \($0)" } ?? "")
		if let (tree, rest) = parser(collection, index) {
			println("\(trace) matched in \(index)..<\(rest): \(tree)")
			return (tree, rest)
		}
		println("\(trace) unmatched at \(index)")
		return nil
	}
}

private let digit: Parser<String, String>.Function = %("0"..."9")
private let lowercase: Parser<String, String>.Function = %("a"..."z")
private let uppercase: Parser<String, String>.Function = %("A"..."Z")
private let ws: Parser<String, Ignore>.Function = ignore(%" " | %"\t" | %"\n")*
private let quot: Parser<String, Ignore>.Function = ignore("\"")
private let word: Parser<String, String>.Function = (lowercase | uppercase | digit)+ --> { "".join($0) }
private let string: Parser<String, String>.Function = quot ++ word ++ quot

private let title: Parser<String, String>.Function = ignore("digraph ") ++ word ++ ignore(" {")
private let sourceAndIdentifier: Parser<String, (String, String)>.Function = string ++ ignore(" -> ") ++ string
private let terminator = ignore(";") ++ ws
private let edge: Parser<String, ((String, Int), (String, Int))>.Function = ws ++ sourceAndIdentifier ++ ws ++ attributes ++ terminator --> { (($0.0, $1["sametail"]?.toInt() ?? 0), ($0.1, $1["headlabel"]?.toInt() ?? 0)) }

private let attribute: Parser<String, (String, String)>.Function = word ++ ignore("=") ++ word
private let comma: Parser<String, Ignore>.Function = ws ++ ignore(",") ++ ws
private let attributeList: Parser<String, [String: String]>.Function = attribute ++ (comma ++ attribute)* --> { Dictionary([ $0 ] + $1) }
private let attributes: Parser<String, [String: String]>.Function = (ignore("[") ++ attributeList ++ ignore("]")) | { _, index in ([:], index) }

private let graph: Parser<String, Graph<String>>.Function = edge+ --> { _, _, edgeParses in
	let nodeData = map(Set(lazy(edgeParses).flatMap { source, destination in [source.0, destination.0] })) { (Identifier(), $0) }
	let nodeIdentifiers = Dictionary(nodeData.map(swap))
	let nodes = Dictionary(nodeData)
	let edges: Set<Edge> = reduce(lazy(edgeParses).map { source, destination in
		(nodeIdentifiers[source.0] &&& nodeIdentifiers[destination.0]).map {
			[ Edge(($0, source.1), ($1, destination.1)) ]
		} ?? []
	}, [], { $0.union($1) })
	return Graph(nodes: nodes, edges: edges)
}

/// Returns a graph and its name from a string in the DOT language.
///
/// GraphViz (.dot) file spec: http://graphviz.org/content/dot-language
public func importDOT(string: String) -> (String, Graph<String>)? {
	return parse(title ++ graph ++ ignore("}"), string)
}


// MARK: - Imports

import Prelude
import Madness
