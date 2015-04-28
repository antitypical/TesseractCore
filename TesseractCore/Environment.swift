//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Environment: CollectionType, DictionaryLiteralConvertible, Printable {
	private var bindings: Dictionary<Symbol, Value>

	public subscript (key: String) -> (Symbol, Value)? {
		let index = find(bindings) { symbol, _ in symbol.name == key }
		return index.map { self.bindings[$0] }
	}

	public subscript (key: Symbol) -> Value? {
		get { return bindings[key] }
		set { bindings[key] = newValue }
	}


	// MARK: CollectionType

	public var startIndex: Dictionary<Symbol, Value>.Index {
		return bindings.startIndex
	}

	public var endIndex: Dictionary<Symbol, Value>.Index {
		return bindings.endIndex
	}

	public subscript (index: Dictionary<Symbol, Value>.Index) -> (Symbol, Value) {
		return bindings[index]
	}


	// MARK: DictionaryLiteralConvertible

	public init(dictionaryLiteral elements: (Symbol, Value)...) {
		bindings = Dictionary(elements)
	}


	// MARK: Printable

	public var description: String {
		return "[\n" + join("", lazy(bindings).map { "\t\(toString($0)): \(toString($1)),\n" }) + "]"
	}


	// MARK: SequenceType

	public func generate() -> IndexingGenerator<Environment> {
		return IndexingGenerator(self)
	}
}

public func + (var left: Environment, right: (Symbol, Value)) -> Environment {
	left[right.0] = right.1
	return left
}


// MARK: - Prelude

extension Symbol {
	private static let Sum = Symbol.named("Sum", .function(.Kind, .function(.Kind, .Kind)))
}

public let Prelude: Environment = [
	Symbol.named("unit", .Unit): Value(()),
	Symbol.named("true", .Bool): Value(true),
	Symbol.named("false", .Bool): Value(false),
	Symbol.named("identity", Term.forall([0], .function(0, 0))): Value(id as Any -> Any),
	Symbol.named("constant", Term.forall([0, 1], .function(0, .function(1, 0)))): Value(const as Any -> Any -> Any),

	Symbol.named("Unit", .Kind): Value(Term.Unit),
	Symbol.Sum: Value { x in { y in Term.sum(x, y) } },
	Symbol.named("Bool", .Kind): Value(Graph(nodes: [ .Return(0, .Kind), .Symbolic(Symbol.Sum), ], edges: [ Edge(1, Destination(nodeIndex: 0, inputIndex: 0)) ])),
]


// MARK: - Imports

import Prelude
import Manifold
