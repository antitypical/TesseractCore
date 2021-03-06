//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum TypeDifferential: Equatable, FixpointType, Printable {
	// MARK: Constructors

	public static func variable(v: Variable) -> TypeDifferential {
		return In(.Variable(v))
	}


	public static func function(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return In(.function(t1, t2))
	}

	public static func sum(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return In(.sum(t1, t2))
	}

	public static func product(t1: TypeDifferential, _ t2: TypeDifferential) -> TypeDifferential {
		return In(.product(t1, t2))
	}


	public static func universal(s: Set<Variable>, _ t: TypeDifferential) -> TypeDifferential {
		return In(.universal(s, t))
	}


	public static var Unit: TypeDifferential {
		return In(.Unit)
	}

	public static var Bool: TypeDifferential {
		return sum(Unit, Unit)
	}


	// MARK: Cases

	case Patch(Term, Term)
	case Copy(Recur)


	/// Case analysis.
	public func analysis<Result>(@noescape #ifPatch: (Term, Term) -> Result, @noescape ifCopy: Recur -> Result) -> Result {
		switch self {
		case let Patch(before, after):
			return ifPatch(before, after)
		case let Copy(type):
			return ifCopy(type)
		}
	}


	/// Merges patches into terms using `transform` and reconstructs a `Term` from the resulting instances.
	public func merge(transform: (Term, Term) -> Term) -> Term {
		return analysis(
			ifPatch: transform,
			ifCopy: {
				Term.In($0.map { $0.merge(transform) })
			})
	}

	/// Returns the type before diffing.
	public var before: Term {
		return merge { before, _ in before }
	}

	/// Returns the type after diffing.
	public var after: Term {
		return merge { _, after in after }
	}


	// MARK: FixpointType

	public typealias Recur = Type<TypeDifferential>

	public static func In(type: Recur) -> TypeDifferential {
		return .Copy(type)
	}

	public static func out(diff: TypeDifferential) -> Recur {
		return diff.analysis(ifPatch: { $1.type.map { $0.differential } }, ifCopy: id)
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifPatch: { "{ \($0) => \($1) }" },
			ifCopy: toString)
	}
}


public struct TypeDifferentiator {
	public static func differentiate(#before: Term, after: Term) -> TypeDifferential {
		if before == after { return .Copy(after.type.map { $0.differential }) }
		if let v1 = before.variable, let v2 = after.variable {
			return TypeDifferential.variable(v2)
		} else if let t1 = before.function, let t2 = after.function {
			return TypeDifferential.function(differentiate(before: t1.0, after: t2.0), differentiate(before: t1.1, after: t2.1))
		} else if let t1 = before.sum, let t2 = after.sum {
			return TypeDifferential.sum(differentiate(before: t1.0, after: t2.0), differentiate(before: t1.1, after: t2.1))
		} else if let t1 = before.product, let t2 = after.product {
			return TypeDifferential.product(differentiate(before: t1.0, after: t2.0), differentiate(before: t1.1, after: t2.1))
		} else if let u1 = before.universal, let u2 = after.universal {
			return TypeDifferential.universal(u2.0, differentiate(before: u1.1, after: u2.1))
		}
		return TypeDifferential.Patch(before, after)
	}
}


extension Term {
	public var differential: TypeDifferential {
		return TypeDifferential.In(type.map { $0.differential })
	}
}


import Manifold
import Prelude
