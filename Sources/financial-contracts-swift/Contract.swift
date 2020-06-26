enum Currency: Equatable { case eur, gbp}
typealias ContractDate = String
typealias Amount = Double

indirect enum Contract: Equatable {
	case zero
	case one(Currency)
	case multiple(Amount, Contract)
	case later(ContractDate, Contract)
	case give(Contract)
	case and(Contract, Contract)
}

enum Direction {
	case long, short
	mutating func toggle() {
		self = self == .long ? .short : .long
	}
}

struct Payment: Equatable {
	var direction: Direction
	var amount: Amount
	var currency: Currency

	func scaled(by amount: Amount) -> Payment {
		var copy = self
		copy.amount *= amount
		return copy
	}

	func inverted() -> Payment {
		var copy = self
		copy.direction.toggle()
		return copy
	}
}

func step(_ contract: Contract, date: ContractDate) -> ([Payment], Contract) {
	switch contract {
	case .zero:
		return ([], .zero)

	case .one(let currency):
		return ([Payment(direction: .long, amount: 1, currency: currency)], .zero)

	case .multiple(let amount, let contract):
		let (payments, residual) = step(contract, date: date)
		return (payments.map { $0.scaled(by: amount) }, .multiple(amount, residual))

	case .later(let laterDate, let contract):
		return date >= laterDate
			? step(contract, date: date)
			: ([], .zero)

	case .give(let contract):
		let (payments, residual) = step(contract, date: date)
		return (payments.map { $0.inverted() }, residual)

	case .and(let contract1, let contract2):
		let (payments1, residual1) = step(contract1, date: date)
		let (payments2, residual2) = step(contract2, date: date)
		return (payments1 + payments2, .and(residual1, residual2))
	}
}
