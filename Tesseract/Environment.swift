//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Environment: DictionaryLiteralConvertible {
	private let bindings: [Symbol: Value]

	public subscript (key: String) -> (Symbol, Value)? {
		let index = find(bindings) { symbol, _ in symbol.name == key }
		return index.map { self.bindings[$0] }?
	}


	// MARK: DictionaryLiteralConvertible

	public init(dictionaryLiteral elements: (Symbol, Value)...) {
		bindings = Dictionary(elements)
	}
}

public let Prelude: Environment = [
	Symbol(name: "identity", parameters: [ .Parameter(0) ], returns: [ .Parameter(0) ]): .Function(id),
	Symbol(name: "const", parameters: [ .Parameter(0) ], returns: [ Type(function: .Parameter(1), .Parameter(0)) ]): .Function(const as Any -> Any -> Any),
	Symbol(name: "unit", parameters: [], returns: [ .Unit ]): .Constant(()),
]


public func evaluate(graph: Graph<Node>, from: Identifier, environment: Environment = Prelude) -> Either<(Identifier, String), Value> {
	return .left(from, "unimplemented")
}


// MARK: - Imports

import Either
import Prelude
