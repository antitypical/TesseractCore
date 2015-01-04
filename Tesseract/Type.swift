//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Type: Equatable, Printable {
	// MARK: Constructors

	public static func function(argumentType: Type, _ returnType: Type) -> Type {
		return Function(Box(argumentType), Box(returnType))
	}

	public static func polymorphic(body: Type) -> Type {
		return Polymorphic(Box(body))
	}


	// MARK: Base

	case Unit
	case Boolean
	case Integer
	case String
	case Function(Box<Type>, Box<Type>)


	// MARK: Polymorphism

	case Polymorphic(Box<Type>)
	case Parameter(Int)


	// MARK: Algebraic types

	case Sum([Type])
	case Product([Type])


	// MARK: Destructuring

	public func destructure() -> DestructuredType {
		switch self {
		case .Unit:
			return .Unit
		case .Boolean:
			return .Boolean
		case .Integer:
			return .Integer
		case .String:
			return .String
		case let .Function(x, y):
			return .Function(x.value, y.value)

		case let .Polymorphic(x):
			return .Polymorphic(x.value)
		case let .Parameter(x):
			return .Parameter(x)

		case let .Sum(xs):
			return .Sum(xs)
		case let .Product(xs):
			return .Product(xs)
		}
	}


	// MARK: Printable

	public var description: Swift.String {
		switch self {
		case Unit:
			return "Unit"
		case Boolean:
			return "Boolean"
		case Integer:
			return "Integer"
		case String:
			return "String"
		case let Function(x, y):
			return "\(x) -> \(y)"

		case let Polymorphic(t):
			return "=> \(t)"
		case let Parameter(n):
			return toString(n)

		case let Sum(xs):
			return "(" + " | ".join(xs.map(toString)) + ")"
		case let Product(xs):
			return "(" + " ✕ ".join(xs.map(toString)) + ")"
		}
	}
}

public enum DestructuredType {
	case Unit
	case Boolean
	case Integer
	case String
	case Function(Type, Type)

	case Polymorphic(Type)
	case Parameter(Int)

	case Sum([Type])
	case Product([Type])
}


public func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case (.Unit, .Unit), (.Boolean, .Boolean), (.Integer, .Integer), (.String, .String):
		return true

	case let (.Function(x1, y1), .Function(x2, y2)):
		return x1 == x2 && y1 == y2

	case let (.Polymorphic(x1), .Polymorphic(x2)):
		return x1 == x2
	// fixme: this is insufficient, we need to know the context
	case let (.Parameter(x), .Parameter(y)):
		return x == y

	case let (.Sum(xs), .Sum(ys)):
		return xs == ys
	case let (.Product(xs), .Product(ys)):
		return xs == ys

	default:
		return false
	}
}


public func typeof(term: Term, context: [(Int, Type)] = []) -> Either<String, Type> {
	switch term.destructure() {
	case let .Constant(value):
		return .right(typeof(value))

	case let .Variable(index):
		return .right(context[index].1)

	case let .Abstraction(type, body):
		return typeof(body, context: context + [(context.count, type)]).map {
			.function(type, $0)
		}

	case let .Application(a, b):
		return typeof(a, context: context).either(Either.left, { appliedType in
			switch appliedType.destructure() {
			case let .Function(parameterType, returnType):
				return typeof(b, context: context).either(Either.left, {
					$0 == parameterType ?
						.right(returnType)
					:	.left("\(term) is of type \($0), not expected type \(parameterType)")
				})
			default:
				return .left("\(term) is of type \(appliedType), not expected (function) type.")
			}
		})

	default:
		return .left("Don’t know how to typecheck \(term)")
	}
}

public func typeof(value: Value) -> Type {
	switch value {
	case .Unit:
		return .Unit
	case .Boolean:
		return .Boolean
	case .Integer:
		return .Integer
	case .String:
		return .String
	}
}


// MARK: - Imports

import Box
import Either
