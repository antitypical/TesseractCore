//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Symbol: Hashable {
	public let name: String
	public let parameters: [Type]
	public let returns: [Type]


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	parameters.reduce(939965963) { $0 ^ $1.hashValue }
		^	returns.reduce(904228669) { $0 ^ $1.hashValue }
	}


	// MARK: Printable

	public var description: String {
		let comma = ", "
		return "\(name) :: (\(comma.join(parameters.map(toString)))) -> (\(comma.join(returns.map(toString))))"
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	return
		left.name == right.name
	&&	left.parameters == right.parameters
	&&	left.returns == right.returns
}
