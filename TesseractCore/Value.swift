//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Equatable, Printable {
	public init(_ constant: Any) {
		self = Constant(Box(constant))
	}

	public init(_ graph: TesseractCore.Graph<Node>) {
		self = Graph(graph)
	}

	case Constant(Box<Any>)
	case Graph(TesseractCore.Graph<Node>)

	public func analysis<Result>(@noescape #ifConstant: Any -> Result, @noescape ifGraph: TesseractCore.Graph<Node> -> Result) -> Result {
		switch self {
		case let Constant(v):
			return ifConstant(v.value)
		case let Graph(g):
			return ifGraph(g)
		}
	}

	public func constant<T>() -> T? {
		return analysis(
			ifConstant: { $0 as? T },
			ifGraph: const(nil))
	}

	public func constant<T>(_: T.Type) -> T? {
		return analysis(
			ifConstant: { $0 as? T },
			ifGraph: const(nil))
	}

	public func function<T, U>() -> (T -> U)? {
		return analysis(
			ifConstant: { $0 as? T -> U },
			ifGraph: const(nil))
	}

	public var graph: TesseractCore.Graph<Node>? {
		return analysis(
			ifConstant: const(nil),
			ifGraph: unit)
	}


	public func apply(argument: Value, _ identifier: Identifier, _ environment: Environment) -> Either<Error<Identifier>, Memo<Value>> {
		let f = function().map { (function: Any -> Any) in
			(argument.constant()
				|>	(flip(flatMap) <| function >>> unit))
				.map { .right(Memo(evaluated: Value($0))) }
			??	error("could not apply function", identifier)
		}
		let g = graph.map { graph in
			graph
				.find { $1.`return` != nil }
				.map { evaluate(graph, graph[$0].0, environment + (.Index(0, .Unit), argument)) }
			??	error("could not find return node", identifier)
		}
		return f ?? g ?? error("cannot apply \(self)", identifier)
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifConstant: { ".Constant(\($0))" },
			ifGraph: { ".Graph(\($0))" })
	}
}

/// Value equality.
///
/// Two values are equal iff their state is of the same known equatable type and equal.
///
/// “Known equatable types” currently include:
///
/// - Bool
/// - Void
public func == (left: Value, right: Value) -> Bool {
	if let a = left.constant(Bool.self), let b = right.constant(Bool.self) {
		return a == b
	} else if let a: () = left.constant(Void.self), let b: () = right.constant(Void.self) {
		return true
	}
	return false
}


// MARK: - Imports

import Box
import Either
import Prelude
import Memo
