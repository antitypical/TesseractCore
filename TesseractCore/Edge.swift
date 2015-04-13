//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Edge<C: CollectionType>: Hashable, Printable {
	public typealias Source = (index: C.Index, outputIndex: Int)
	public typealias Destination = (index: C.Index, inputIndex: Int)

	public init(_ source: Source, _ destination: Destination) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: C.Index, _ destination: Destination) {
		self.init((source, 0), destination)
	}

	public let source: Source
	public let destination: Destination


	// MARK: Hashable

	public var hashValue: Int {
		return (toString(source.index).hashValue + source.outputIndex) ^ (toString(destination.index).hashValue + destination.inputIndex)
	}

	
	// MARK: Printable
	
	public var description: String {
		return "\(source.index): \(source.outputIndex) -> \(destination.index): \(destination.inputIndex)"
	}
}

public func == <C: CollectionType> (left: (C.Index, Int), right: (C.Index, Int)) -> Bool {
	return left.0 == right.0 && left.1 == right.1
}

public func == <C: CollectionType> (left: Edge<C>, right: Edge<C>) -> Bool {
	return
		left.source.index == right.source.index && left.source.outputIndex == right.source.outputIndex
	&&	left.destination.index == right.destination.index && left.destination.inputIndex == right.destination.inputIndex
}
