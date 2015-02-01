//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Value: Printable {
	public init(constant: Any) {
		self = Constant(Box(constant))
	}

	public init<T, U>(function: T -> U) {
		self = Function(Box(function))
	}

	case Constant(Box<Any>)
	case Function(Box<Any>)
	case Graph(TesseractCore.Graph<Node>)

	public func constant<T>() -> T? {
		switch self {
		case let Constant(v):
			return v.value as? T
		default:
			return nil
		}
	}

	public func function<T, U>() -> (T -> U)? {
		switch self {
		case let Function(f):
			return f.value as? T -> U
		default:
			return nil
		}
	}


	public func apply(argument: Value) -> Value? {
		return (function() as (Any -> Any)?)
			.map { argument.constant().map($0) }?
			.map { Value(constant: $0) }
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Constant(constant):
			return ".Constant(\(constant))"
		case let Function(function):
			return ".Function(\(function))"
		case let Graph(graph):
			return ".Graph(\(graph))"
		}
	}
}


// MARK: - Imports

import Box
