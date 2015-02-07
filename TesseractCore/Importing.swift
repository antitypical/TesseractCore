//  Copyright (c) 2015 Rob Rix. All rights reserved.

private func nub<T: Equatable>(list: [T]) -> [T] {
    var unique: [T] = []
    for item in list {
        if !contains(unique, item) {
            unique.append(item)
        }
    }
    return unique
}

public func parseEdge(edge: String) -> (String, String)? {
    let characterParser = %("0"..."9") | %("a"..."z") | %("A"..."Z")
    let ignoreBeginningOfLine = ignore("\t") ++ ignore("\"")
    let edgeParser = ignoreBeginningOfLine ++ (characterParser+) ++ ignore("\" -> \"") ++ characterParser+ ++ ignore("\";");
    
    if let (rawSource, rawDestination) = edgeParser(edge)?.0 {
        let source = String(rawSource.reduce([], +))
        let destination = String(rawDestination.reduce([], +))
        return (source, destination)
    }
    
    return nil
}

public func importGraphViz(file: String) -> Graph<String>? {
    let lines = split(file) { $0 == "\n" }
    let rawLines = lines[1...(lines.count - 2)]
    let rawEdges: [(String, String)] = map(rawLines, { edge in parseEdge(edge) ?? ("","") })
    let rawSources = map(rawEdges, { edge in edge.0 })
    let rawDestinations = map(rawEdges, { edge in edge.1 })
    let rawNodes = rawSources + rawDestinations
    let uniqueNodes = nub(rawNodes)
    var inputCount = map(uniqueNodes) { _ in 0 }
    var outputCount = inputCount
    println(rawEdges)
    let edges: [Edge] = map(rawEdges) { edge in
        let (sourceString, destinationString) = edge
        let sourceIndex = find(uniqueNodes, sourceString) ?? 0
        let destinationIndex = find(uniqueNodes, destinationString) ?? 0
        let sourceOutputNumber = outputCount[sourceIndex] + 1
        let destinationInputNumber = inputCount[sourceIndex] + 1
        let source = (Identifier(value: sourceString.toInt()!), sourceOutputNumber)
        let destination = (Identifier(value: destinationString.toInt()!), destinationInputNumber)
        return Edge(source, destination)
    }
    
    var emptyDictionary: [Identifier: String] = Dictionary()
    let nodes = uniqueNodes.reduce(emptyDictionary) { accum, curr in
        return accum + [Identifier(value: curr.toInt()!): ""]
    }
    
    let a = Identifier()
    return Graph(nodes: nodes, edges: Set(edges))
}

// MARK: - Imports

import Set
import Prelude
import Madness
