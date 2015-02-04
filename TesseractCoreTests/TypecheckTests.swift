//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Either
import Prelude
import TesseractCore
import XCTest

final class TypecheckTests: XCTestCase {
	func testConstantNodesTypecheck() {
		let a = Identifier()
		let symbol = Symbol.Named("true", .Boolean)
		let graph = Graph(nodes: [ a: Node.Symbolic(symbol) ])
		assertEqual(assertRight(typecheck(graph, a, [symbol: Value(constant: true)])), Type.Boolean)
	}

	func testBoundFunctionNodesTypecheck() {
		let (a, b) = (Identifier(), Identifier())
		let identitySymbol = Symbol.Named("identity", 0 --> 0)
		let inputSymbol = Symbol.Named("true", .Boolean)
		let graph = Graph(nodes: [ a: Node.Symbolic(inputSymbol), b: Node.Symbolic(identitySymbol) ], edges: [ Edge((a, 0), (b, 0)) ])
		assertEqual(assertRight(typecheck(graph, b, [ inputSymbol: Value(constant: true), identitySymbol: Value(function: id as Any -> Any) ])), Type.Boolean)
	}
}
