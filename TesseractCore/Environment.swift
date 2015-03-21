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

public let Prelude: Environment = [
	Symbol("unit", .Unit): Value(()),
	Symbol("true", .Bool): Value(true),
	Symbol("false", .Bool): Value(false),
	Symbol("identity", Term.forall([0], .function(Term(0), Term(0)))): Value(function: id as Any -> Any),
	Symbol("constant", Term.forall([0, 1], .function(Term(0), .function(Term(1), Term(0))))): Value(function: const as Any -> Any -> Any),
]


// MARK: - Imports

import Prelude
import Manifold
