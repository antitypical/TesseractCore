//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public typealias Source = (identifier: Identifier, outputIndex: Int)
	public typealias Destination = (identifier: Identifier, inputIndex: Int)

	public init(_ source: Source, _ destination: Destination) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: Identifier, _ destination: Destination) {
		self.init(source.output(0), destination)
	}

	public let source: Source
	public let destination: Destination


	// MARK: Hashable

	public var hashValue: Int {
		return (source.identifier.hashValue + source.outputIndex) ^ (destination.identifier.hashValue + destination.inputIndex)
	}
}

public func == (left: Edge.Source, right: Edge.Source) -> Bool {
	return left.identifier == right.identifier && left.outputIndex == right.outputIndex
}

public func == (left: Edge.Destination, right: Edge.Destination) -> Bool {
	return left.identifier == right.identifier && left.inputIndex == right.inputIndex
}

public func < (left: Edge.Source, right: Edge.Source) -> Bool {
	return left.identifier == right.identifier ?
		left.outputIndex < right.outputIndex
		:	left.identifier < right.identifier
}

public func < (left: Edge.Destination, right: Edge.Destination) -> Bool {
	return left.identifier == right.identifier ?
		left.inputIndex < right.inputIndex
		:	left.identifier < right.identifier
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
}
