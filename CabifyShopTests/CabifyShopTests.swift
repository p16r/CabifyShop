//
//	CabifyShopTests.swift
//	CabifyShopTests
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import Combine
import XCTest
@testable import CabifyShop

final class CabifyShopTests: XCTestCase {

	private let timeout: TimeInterval = 0.02

	private var viewModel: CatalogViewModel!
	private var catalogAccumulator: Subscribers.Accumulate<Catalog>!
	private var cartAccumulator: Subscribers.Accumulate<[CartItem]>!

	override func setUp() {
		super.setUp()
		self.viewModel = CatalogViewModel(apiService: .mock())
		self.catalogAccumulator = viewModel.$catalog
			.dropFirst()
			.compactMap(\.value)
			.accumulate()
		self.cartAccumulator = viewModel.$cart
			.dropFirst()
			.accumulate()
	}

	override func tearDown() {
		self.viewModel = nil
		self.catalogAccumulator = nil
		self.cartAccumulator = nil
		super.tearDown()
	}

	func testFetchCatalog() throws {
		fetchCatalog()

		XCTAssertNotNil(catalogAccumulator.latest)
	}

	func testAddToCart() throws {
		fetchCatalog()

		try addToCart(.voucher)

		let cart = try XCTUnwrap(cartAccumulator.latest)
		XCTAssertFalse(cart.isEmpty)
	}

	func testRemoveFromCart() throws {
		fetchCatalog()

		try addToCart(.voucher)
		try removeFromCart(.voucher)

		let cart = try XCTUnwrap(cartAccumulator.latest)
		XCTAssertTrue(cart.isEmpty)
	}

	func testClearCart() throws {
		fetchCatalog()

		try addToCart(.voucher)
		try addToCart(.tshirt)
		try addToCart(.mug)

		var cart = try XCTUnwrap(cartAccumulator.latest)
		XCTAssertFalse(cart.isEmpty)

		clearCart()

		cart = try XCTUnwrap(cartAccumulator.latest)
		XCTAssertTrue(cart.isEmpty)
	}

	func testVoucherDiscount() throws {
		fetchCatalog()

		try addToCart(.voucher)
		try addToCart(.voucher)

		try assertPrices(price: 10.00, modifiedPrice: 5.00)
	}

	func testTshirtDiscount() throws {
		fetchCatalog()

		try addToCart(.tshirt)
		try addToCart(.tshirt)
		try addToCart(.tshirt)

		try assertPrices(price: 60.00, modifiedPrice: 57.00)
	}

	func testMugDiscount() throws {
		fetchCatalog()

		try addToCart(.mug)
		try addToCart(.mug)

		try assertPrices(price: 15.00, modifiedPrice: 15.00)
	}

	private func setupState(timeout: TimeInterval, block: @escaping () throws -> Void) rethrows {
		let expectation = expectation(description: "Awaiting state settle.")
		try block()
		DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: expectation.fulfill)
		waitForExpectations(timeout: timeout, handler: nil)
	}

	private func getProductFromCatalog(with code: Code) -> Product? {
		catalogAccumulator
			.latest?
			.products
			.first { $0.code == code }
	}

	private func fetchCatalog() {
		setupState(timeout: timeout) {
			self.viewModel.fetchCatalog()
		}
	}

	private func addToCart(_ code: Code) throws {
		let product = try XCTUnwrap(getProductFromCatalog(with: code))
		setupState(timeout: timeout) {
			self.viewModel.addToCart(product)
		}
	}

	private func removeFromCart(_ code: Code) throws {
		let product = try XCTUnwrap(getProductFromCatalog(with: code))
		setupState(timeout: timeout) {
			self.viewModel.removeFromCart(product)
		}
	}

	private func clearCart() {
		setupState(timeout: timeout) {
			self.viewModel.clearCart()
		}
	}

	private func assertPrices(
		price: Decimal,
		modifiedPrice: Decimal,
		file: StaticString = #file,
		line: UInt = #line
	) throws {
		let cart = try XCTUnwrap(cartAccumulator.latest, file: file, line: line)
		let (totalPrice, totalModifiedPrice) = cart
			.reduce(into: ((Decimal.zero, Decimal.zero))) { tuple, item in
				let product = item.product
				tuple.0 += product.price
				tuple.1 += product.modifiedPrice ?? product.price
			}
		XCTAssertEqual(totalPrice, price, file: file, line: line)
		XCTAssertEqual(totalModifiedPrice, modifiedPrice, file: file, line: line)
	}

}
