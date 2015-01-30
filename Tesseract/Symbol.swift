//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Symbol: Hashable {
	public let name: String
	public let type: Type


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	type.hashValue
	}


	// MARK: Printable

	public var description: String {
		let comma = ", "
		return "\(name) :: \(type)"
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	return
		left.name == right.name
	&&	left.type == right.type
}
