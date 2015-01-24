//  Copyright (c) 2015 Rob Rix. All rights reserved.

extension Dictionary {
	init<S: SequenceType where S.Generator.Element == Element>(_ elements: S) {
		self.init()
		var generator = elements.generate()
		let next: () -> Element? = { generator.next() }
		for (key, value) in GeneratorOf(next) {
			updateValue(value, forKey: key)
		}
	}

	func filter(includeKeyAndValue: Element -> Bool) -> Dictionary {
		return Dictionary(lazy(self).filter(includeKeyAndValue))
	}

	func map<K: Hashable, V>(transform: Element -> (K, V)) -> Dictionary<K, V> {
		return Dictionary<K, V>(lazy(self).map(transform))
	}

	func reduce<Into>(initial: Into, combine: (Into, Element) -> Into) -> Into {
		return Swift.reduce(self, initial, combine)
	}
}
