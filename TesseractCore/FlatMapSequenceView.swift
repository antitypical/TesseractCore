//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct FlatMapSequenceView<Base: SequenceType, Each: SequenceType>: SequenceType {
	public init(_ base: Base, _ transform: Base.Generator.Element -> Each) {
		self.base = base
		self.transform = transform
	}


	// MARK: SequenceType

	public func generate() -> GeneratorOf<Each.Generator.Element> {
		var outer = base.generate()
		var inner: Each.Generator?
		return GeneratorOf {
			next(
				{ () -> Bool in
					inner = outer.next().map(self.transform)?.generate()
					return inner != nil
				},
				{ inner?.next() }
			)
		}
	}


	// MARK: Private

	private let base: Base
	private let transform: Base.Generator.Element -> Each
}

private func next<T>(outer: () -> Bool, inner: () -> T?) -> T? {
	return inner() ?? (outer() ? next(outer, inner) : nil)
}


extension LazySequence {
	func flatMap<Each: SequenceType>(transform: S.Generator.Element -> Each) -> LazySequence<FlatMapSequenceView<LazySequence<S>, Each>> {
		return lazy(FlatMapSequenceView(self, transform))
	}
}

extension LazyForwardCollection {
	func flatMap<Each: SequenceType>(transform: S.Generator.Element -> Each) -> LazySequence<FlatMapSequenceView<LazyForwardCollection<S>, Each>> {
		return lazy(FlatMapSequenceView(self, transform))
	}
}

extension LazyBidirectionalCollection {
	func flatMap<Each: SequenceType>(transform: S.Generator.Element -> Each) -> LazySequence<FlatMapSequenceView<LazyBidirectionalCollection<S>, Each>> {
		return lazy(FlatMapSequenceView(self, transform))
	}
}

extension LazyRandomAccessCollection {
	func flatMap<Each: SequenceType>(transform: S.Generator.Element -> Each) -> LazySequence<FlatMapSequenceView<LazyRandomAccessCollection<S>, Each>> {
		return lazy(FlatMapSequenceView(self, transform))
	}
}
