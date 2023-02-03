//
//	CatalogViewModel.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import Combine
import Foundation

class CatalogViewModel: ObservableObject {

	@Published var catalog: NetworkResult<Catalog, Error> = .standby
	@Published var cart: [CartItem] = []

	private let apiService: any APIService

	init(apiService: APIService) {
		self.apiService = apiService
	}

	func fetchCatalog() {
		apiService.catalogPublisher()
			.decode(type: Catalog.self, decoder: JSONDecoder())
			.map(NetworkResult.success)
			.catch { Just(NetworkResult.failure($0)) }
			.receive(on: DispatchQueue.main)
			.assign(to: &$catalog)
	}

	func addToCart(_ product: Product) {
		guard var catalog = catalog.value else { return }
		cart.append(.init(product: product))
		update(&catalog, &cart, with: product)
		self.catalog = .success(catalog)
	}

	func removeFromCart(_ product: Product) {
		guard var catalog = catalog.value else { return }
		guard let index = cart.lastIndex(where: { $0.product.id == product.id }) else { return }
		cart.remove(at: index)
		update(&catalog, &cart, with: product)
		self.catalog = .success(catalog)
	}

	private func update(_ catalog: inout Catalog, _ cart: inout [CartItem], with product: Product) {
		switch product.code {
			case .voucher:
				let code: Code = .voucher
				let count = self.count(of: code, in: cart)
				let modifiedPrice: Decimal? = count.isMultiple(of: 2) ? nil : 0
				updateCatalog(&catalog, setNewPrice: modifiedPrice, for: code)
			case .tshirt:
				let code: Code = .tshirt
				let count = self.count(of: code, in: cart)
				let modifiedPrice: Decimal? = count >= 3 ? 19 : nil
				updateCart(&cart, setNewPrice: modifiedPrice, for: code)
				updateCatalog(&catalog, setNewPrice: modifiedPrice, for: code)
			case .mug:
				break
		}
	}

	private func count(of code: Code, in cart: [CartItem]) -> Int {
		cart
			.filter { $0.product.code == code }
			.count
	}

	private func updateCatalog(_ catalog: inout Catalog, setNewPrice modifiedPrice: Decimal?, for code: Code) {
		let index = catalog.products.firstIndex { $0.code == code }
		guard let index else { return }
		catalog.products[index].modifiedPrice = modifiedPrice
	}

	private func updateCart(_ cart: inout [CartItem], setNewPrice modifiedPrice: Decimal?, for code: Code) {
		for index in cart.indices where cart[index].product.code == code {
			cart[index].product.modifiedPrice = modifiedPrice
		}
	}

	func clearCart() {
		cart.removeAll()
		guard var catalog = catalog.value else { return }
		for index in catalog.products.indices {
			catalog.products[index].modifiedPrice = nil
		}
		self.catalog = .success(catalog)
	}

}
