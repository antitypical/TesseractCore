//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Equatable, Printable {
	public init(_ constant: Any) {
		self = Constant(Box(constant))
	}

	public init(_ graph: TesseractCore.Graph<[Node]>) {
		self = Graph(graph)
	}

	case Constant(Box<Any>)
	case Graph(TesseractCore.Graph<[Node]>)

	public func analysis<Result>(@noescape #ifConstant: Any -> Result, @noescape ifGraph: TesseractCore.Graph<[Node]> -> Result) -> Result {
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

	public var graph: TesseractCore.Graph<[Node]>? {
		return analysis(
			ifConstant: const(nil),
			ifGraph: unit)
	}


	public func apply(argument: Value, _ index: TesseractCore.Graph<[Node]>.Index, _ environment: Environment) -> Either<Error<TesseractCore.Graph<[Node]>.Index>, Memo<Value>> {
		if let function: Any -> Any = function() {
			return (argument.constant()
				|>	(flip(flatMap) <| function >>> unit))
				.map { .right(Memo(evaluated: Value($0))) }
			??	error("could not apply function", index)
		} else if let graph = graph {
			return find(graph.nodes) { $0.`return` != nil }
				.map { evaluate(graph, $0, environment + (.Index(0, .Unit), argument)) }
			??	error("could not find return node", index)
		}
		return error("cannot apply \(self)", index)
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifConstant: { ".Constant(\($0))" },
			ifGraph: { ".Graph(\($0))" })
	}
}


// MARK: - Imports

import Box
import Either
import Prelude
import Memo
