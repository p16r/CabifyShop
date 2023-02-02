//
//	PriceView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-02.
//

import SwiftUI

struct PriceView: View {

	private let price: Decimal
	private let modifiedPrice: Decimal?

	private var isDiscounted: Bool {
		guard let modifiedPrice else { return false }
		return price != modifiedPrice
	}

	init(_ price: Decimal, discountedTo modifiedPrice: Decimal? = nil) {
		self.price = price
		self.modifiedPrice = modifiedPrice
	}

	init(for product: Product) {
		self.init(product.price, discountedTo: product.modifiedPrice)
	}

	init(for cart: [CartItem]) {
		let (price, modifiedPrice): (Decimal, Decimal) = cart.reduce((0, 0)) { tuple, item in
			(tuple.0 + item.product.price, tuple.1 + (item.product.modifiedPrice ?? item.product.price))
		}
		self.init(price, discountedTo: modifiedPrice	)
	}

	var body: some View {
		VStack(spacing: 4) {
			Text(price, format: .currency(code: "EUR"))
				.strikethrough(isDiscounted)
				.foregroundColor(isDiscounted ? .secondary : .primary)
			if isDiscounted, let modifiedPrice = modifiedPrice {
				Text(modifiedPrice, format: .currency(code: "EUR"))
			}
		}
	}

}
