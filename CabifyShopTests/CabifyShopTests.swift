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

}
