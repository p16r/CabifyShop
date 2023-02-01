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
	@Published private(set) var cart: [Product] = []

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
		cart.append(product)
	}

	func removeFromCart(_ product: Product) {
		guard let index = cart.lastIndex(of: product) else { return }
		cart.remove(at: index)
	}

}
