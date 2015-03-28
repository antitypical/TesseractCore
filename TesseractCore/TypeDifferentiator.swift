//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum TypeDifferential: Equatable, FixpointType, Printable {
	// MARK: Constructors

	public static func variable(v: Variable) -> TypeDifferential {
		return In(.Variable(v))
	}


	public static func constructed(c: Constructor<TypeDifferential>) -> TypeDifferential {
		return In(.constructed(c))
	}

	public static func function(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return constructed(.function(t1, t2))
	}

	public static func sum(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return constructed(.sum(t1, t2))
	}

	public static func product(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return constructed(.product(t1, t2))
	}


	public static func universal(s: Set<Variable>, _ t: TypeDifferential) -> TypeDifferential {
		return In(.universal(s, t))
	}


	public static var Unit: TypeDifferential {
		return constructed(.Unit)
	}

	public static var Bool: TypeDifferential {
		return sum(Unit, Unit)
	}


	// MARK: Cases

	case Patch(Type<TypeDifferential>)
	case Empty


	/// Case analysis.
	public func analysis<Result>(@noescape #ifPatch: Type<TypeDifferential> -> Result, @noescape ifEmpty: () -> Result) -> Result {
		switch self {
		case let Patch(patch):
			return ifPatch(patch)
		case Empty:
			return ifEmpty()
		}
	}


	/// Applies the diff to a type.
	public func apply(type: Term) -> Term {
		switch self {
		case let .Patch(patch):
			switch patch {
			case let .Variable(variable) where type.variable != nil:
				return Term(variable)
			case let .Constructed(constructor) where type.constructed != nil:
				switch constructor.value {
				case .Unit:
					return .Unit
				case let .Function(x, y) where type.function != nil:
					return Term.function(x.value.apply(type.function!.0), y.value.apply(type.function!.1))
				case let .Sum(x, y) where type.sum != nil:
					return Term.sum(x.value.apply(type.sum!.0), y.value.apply(type.sum!.1))
				case let .Product(x, y) where type.product != nil:
					return Term.product(x.value.apply(type.product!.0), y.value.apply(type.product!.1))
				default:
					return type
				}
			case let .Universal(variables, quantified) where type.universal != nil:
				return Term.forall(variables, quantified.value.apply(type.universal!.1))
			default:
				return type
			}
		case .Empty:
			return type
		}
	}


	// MARK: FixpointType

	public typealias Recur = Type<TypeDifferential>

	public static func In(type: Recur) -> TypeDifferential {
		return .Patch(type)
	}

	public static func out(diff: TypeDifferential) -> Recur {
		return diff.analysis(ifPatch: unit, ifEmpty: const(nil))!
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifPatch: { "\($0)" },
			ifEmpty: { ".Empty" })
	}
}

public func == (left: TypeDifferential, right: TypeDifferential) -> Bool {
	switch (left, right) {
	case let (.Patch(p1), .Patch(p2)):
		return p1 == p2
	case (.Empty, .Empty):
		return true
	default:
		return false
	}
}


extension Term {
	public var differential: TypeDifferential {
		return TypeDifferential.In(type.map { $0.differential })
	}
}


import Manifold
import Prelude
