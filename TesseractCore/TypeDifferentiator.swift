//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum TypeDifferential: FixpointType {

	// MARK: Cases

	case Patch(Type<TypeDifferential>)
	case Empty


	// MARK: FixpointType

	public typealias Recur = Type<TypeDifferential>

	public static func In(type: Recur) -> TypeDifferential {
		return .Patch(type)
	}

	public static func out(diff: TypeDifferential) -> Recur {
		return diff.analysis(ifPatch: unit, ifEmpty: const(nil))!
	}
}


import Manifold
import Prelude
