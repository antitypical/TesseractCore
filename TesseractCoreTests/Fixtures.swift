//  Copyright (c) 2015 Rob Rix. All rights reserved.

let absoluteValue = Graph<[String]>(nodes: [
	"x",
	"result",
	"0",
	"unaryMinus",
	"if",
	"lessThan"
], edges: [
	Edge(Source(nodeIndex: 0), Destination(nodeIndex: 5, inputIndex: 0)),
	Edge(Source(nodeIndex: 2), Destination(nodeIndex: 5, inputIndex: 1)),
	Edge(Source(nodeIndex: 5), Destination(nodeIndex: 4, inputIndex: 0)),
	Edge(Source(nodeIndex: 0), Destination(nodeIndex: 3, inputIndex: 0)),
	Edge(Source(nodeIndex: 3), Destination(nodeIndex: 5, inputIndex: 1)),
	Edge(Source(nodeIndex: 0), Destination(nodeIndex: 4, inputIndex: 2)),
	Edge(Source(nodeIndex: 4), Destination(nodeIndex: 1, inputIndex: 0))
])


// MARK: - Imports

import TesseractCore
