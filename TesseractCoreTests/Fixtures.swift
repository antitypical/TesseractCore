//  Copyright (c) 2015 Rob Rix. All rights reserved.

private let x = Identifier()
private let result = Identifier()
private let zero = Identifier()
private let lessThan = Identifier()
private let iff = Identifier()
private let unaryMinus = Identifier()
let absoluteValue = Graph<String>(nodes: [
	x: "x",
	result: "result",
	zero: "0",
	unaryMinus: "unaryMinus",
	iff: "if",
	lessThan: "lessThan"
], edges: [
	Edge(x, lessThan.input(0)),
	Edge(zero, lessThan.input(1)),
	Edge(lessThan, iff.input(0)),
	Edge(x, unaryMinus.input(0)),
	Edge(unaryMinus, iff.input(1)),
	Edge(x, iff.input(2)),
	Edge(iff, result.input(0))
])


// MARK: - Imports

import TesseractCore
