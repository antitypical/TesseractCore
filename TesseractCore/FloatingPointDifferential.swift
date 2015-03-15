//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct FloatingPointDifferential<FP: FloatingPointType where FP.Stride == FP> {
	public static func differentiate(#before: FP, after: FP) -> FP {
		return after - before
	}
}
