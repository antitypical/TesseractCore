//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Environment: DictionaryLiteralConvertible, Printable {
	private var bindings: Dictionary<Symbol, Value>

	public subscript (key: String) -> (Symbol, Value)? {
		let index = find(bindings) { symbol, _ in symbol.name == key }
		return index.map { self.bindings[$0] }?
	}

	public subscript (key: Symbol) -> Value? {
		get { return bindings[key] }
		set { bindings[key] = newValue }
	}


	// MARK: DictionaryLiteralConvertible

	public init(dictionaryLiteral elements: (Symbol, Value)...) {
		bindings = Dictionary(elements)
	}


	// MARK: Printable

	public var description: String {
		return "[\n" + join("", lazy(bindings).map { "\t\(toString($0)): \(toString($1)),\n" }) + "]"
	}
}

public func + (var left: Environment, right: (Symbol, Value)) -> Environment {
	left[right.0] = right.1
	return left
}


// MARK: - Prelude

public let Prelude: Environment = [
	Symbol("unit", .Unit): Value(constant: ()),
	Symbol("true", .Boolean): Value(constant: true),
	Symbol("false", .Boolean): Value(constant: false),
	Symbol("identity", 0 --> 0): Value(function: id as Any -> Any),
	Symbol("constant", 0 --> 1 --> 0): Value(function: const as Any -> Any -> Any),
]


// MARK: - Imports

import Prelude
