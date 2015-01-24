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
		return Dictionary(Swift.filter(self, includeKeyAndValue))
	}
}
