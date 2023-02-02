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

	func fetchCatalog() {
		let url = URL(string: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")!
		catalog = .loading
		URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: Catalog.self, decoder: JSONDecoder())
			.map(NetworkResult.success)
			.catch { Just(NetworkResult.failure($0)) }
			.receive(on: DispatchQueue.main)
			.assign(to: &$catalog)
	}

	func addToCart(_ product: Product) {
		guard var catalog = catalog.value else { return }
		cart.append(.init(product: product))
		updateCatalog(&catalog, for: product)
		self.catalog = .success(catalog)
	}

	func removeFromCart(_ product: Product) {
		guard var catalog = catalog.value else { return }
		guard let index = cart.lastIndex(where: { $0.product.id == product.id }) else { return }
		cart.remove(at: index)
		updateCatalog(&catalog, for: product)
		self.catalog = .success(catalog)
	}

	private func updateCatalog(_ catalog: inout Catalog, for product: Product) {
		switch product.code {
			case .voucher:
				let count = cart
					.filter { $0.product.code == .voucher }
					.count
				let modifiedPrice: Decimal? = count.isMultiple(of: 2) ? nil : 0
				updateCatalog(&catalog, setNewPrice: modifiedPrice, for: .voucher)
			case .tshirt:
				let count = cart
					.filter { $0.product.code == .tshirt }
					.count
				let modifiedPrice: Decimal? = count >= 3 ? 19 : nil
				updateCart(&cart, setNewPrice: modifiedPrice, for: .tshirt)
				updateCatalog(&catalog, setNewPrice: modifiedPrice, for: .tshirt)
			case .mug:
				break
		}
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

}
