import XCTest
@testable import financial_contracts_swift

final class financial_contracts_swiftTests: XCTestCase {
    func testExample() {
			let zcb1: Contract = .later("2020-12-24", (.multiple(100, .one(.eur))))
			let payment1 = Payment(direction: .long, amount: 100, currency: .eur)

			XCTAssertEqual(step(zcb1, date: "2020-12-31").0, [payment1])

			let zcb2: Contract = .later("2020-12-30", (.multiple(100, .one(.gbp))))
			let payment2 = Payment(direction: .long, amount: 100, currency: .gbp)

			XCTAssertEqual(step(zcb2, date: "2020-12-31").0, [payment2])

			let contract1: Contract = .and(zcb1, zcb2)
			let combinedPayments = [payment1, payment2]

			XCTAssertEqual(step(contract1, date: "2020-12-31").0, combinedPayments)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
