//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Printable {
	public init(constant: Any) {
		self = Constant(Box(constant))
	}

	public init<T, U>(function: T -> U) {
		self = Function(Box(function))
	}

	public init(graph: TesseractCore.Graph<Node>) {
		self = Graph(graph)
	}

	case Constant(Box<Any>)
	case Function(Box<Any>)
	case Graph(TesseractCore.Graph<Node>)

	public func analysis<Result>(@noescape #ifConstant: Any -> Result, @noescape ifFunction: Any -> Result, @noescape ifGraph: TesseractCore.Graph<Node> -> Result) -> Result {
		switch self {
		case let Constant(v):
			return ifConstant(v.value)
		case let Function(v):
			return ifFunction(v.value)
		case let Graph(g):
			return ifGraph(g)
		}
	}

	public func constant<T>() -> T? {
		return analysis(
			ifConstant: { $0 as? T },
			ifFunction: const(nil),
			ifGraph: const(nil))
	}

	public func function<T, U>() -> (T -> U)? {
		return analysis(
			ifConstant: const(nil),
			ifFunction: { $0 as? T -> U },
			ifGraph: const(nil))
	}

	public var graph: TesseractCore.Graph<Node>? {
		return analysis(
			ifConstant: const(nil),
			ifFunction: const(nil),
			ifGraph: unit)
	}


	public func apply(argument: Value, _ identifier: Identifier, _ environment: Environment) -> Either<Error<Identifier>, Memo<Value>> {
		return analysis(
			ifConstant: const(error("cannot apply \(self)", identifier)),
			ifFunction: { function in
				// fixme: this wrongly rejects higher-order functions (because constant() returns nil for function values)
				(argument.constant()
					|>	(flip(flatMap) <| { (function as? Any -> Any)?($0) }))
					.map { .right(Memo(evaluated: Value(constant: $0))) }
				??	error("could not apply function", identifier)
			},
			ifGraph: { graph in
				graph
					.find { $1.isReturn }
					.map { evaluate(graph, graph[$0].identifier, environment + (.Parameter(0, .Unit), argument)) }
				??	error("could not find return node", identifier)
			})
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifConstant: { ".Constant(\($0))" },
			ifFunction: { ".Function(\($0))" },
			ifGraph: { ".Graph(\($0))" })
	}
}


// MARK: - Imports

import Box
import Either
import Prelude
import Memo
