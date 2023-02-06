//
//	PriceView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-02.
//

import SwiftUI

struct PriceView: View {

	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	private let price: Decimal
	private let modifiedPrice: Decimal?
	private let alignment: AccessibleAlignment

	private var isDiscounted: Bool {
		guard let modifiedPrice else { return false }
		return price != modifiedPrice
	}

	init(_ price: Decimal, discountedTo modifiedPrice: Decimal? = nil, alignment: AccessibleAlignment) {
		self.price = price
		self.modifiedPrice = modifiedPrice
		self.alignment = alignment
	}

	init(for product: Product, alignment: AccessibleAlignment) {
		self.init(product.price, discountedTo: product.modifiedPrice, alignment: alignment)
	}

	init(for cart: [CartItem], alignment: AccessibleAlignment) {
		let (price, modifiedPrice): (Decimal, Decimal) = cart.reduce((0, 0)) { tuple, item in
			(tuple.0 + item.product.price, tuple.1 + (item.product.modifiedPrice ?? item.product.price))
		}
		self.init(price, discountedTo: modifiedPrice, alignment: alignment)
	}

	var body: some View {
		AccessibleStack(alignment: alignment, spacing: 4) {
			Text(price, format: .currency(code: "EUR"))
				.strikethrough(isDiscounted)
				.foregroundColor(isDiscounted ? .secondary : .primary)
			if isDiscounted, let modifiedPrice = modifiedPrice {
				Text(modifiedPrice, format: .currency(code: "EUR"))
			}
		}
	}

}
