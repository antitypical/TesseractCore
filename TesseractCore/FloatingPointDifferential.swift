//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct FloatingPointDifferential<FP: FloatingPointType where FP.Stride == FP>: DifferentiatorType {
	public let delta: FP


	// MARK: DifferentialType

	public static func differentiate(#before: FP, after: FP) -> FloatingPointDifferential {
		return FloatingPointDifferential(delta: after - before)
	}
}
