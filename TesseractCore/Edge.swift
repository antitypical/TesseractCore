//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Edge<C: CollectionType>: Hashable, Printable {
	public init(_ source: Source, _ destination: Destination) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: C.Index, _ destination: Destination) {
		self.init(Source(nodeIndex: source, outputIndex: 0), destination)
	}

	public typealias Source = TesseractCore.Source<C>
	public typealias Destination = TesseractCore.Destination<C>

	public let source: Source
	public let destination: Destination


	// MARK: Hashable

	public var hashValue: Int {
		return source.description.hashValue ^ destination.description.hashValue
	}

	
	// MARK: Printable
	
	public var description: String {
		return "\(source.nodeIndex): \(source.outputIndex) -> \(destination.nodeIndex): \(destination.inputIndex)"
	}
}
