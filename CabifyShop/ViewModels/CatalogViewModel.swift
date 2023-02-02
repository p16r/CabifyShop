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
		switch product.code {
			case .voucher:
				let index = catalog.products.firstIndex { $0.code == .voucher }
				let count = cart
					.filter { $0.product.code == .voucher }
					.count
				if let index {
					catalog.products[index].modifiedPrice = count.isMultiple(of: 2) ? nil : 0
				}
			case .tshirt:
				let count = cart
					.filter { $0.product.code == .tshirt }
					.count
				if count >= 3 {
					for index in cart.indices where cart[index].product.code == .tshirt {
						cart[index].product.modifiedPrice = 19
					}
					let index = catalog.products.firstIndex { $0.code == .tshirt }
					if let index {
						catalog.products[index].modifiedPrice = 19
					}
				}
			case .mug:
				break
		}
		self.catalog = .success(catalog)
	}

	func removeFromCart(_ product: Product) {
		guard let index = cart.lastIndex(where: { $0.product.id == product.id }) else { return }
		cart.remove(at: index)
	}

}
