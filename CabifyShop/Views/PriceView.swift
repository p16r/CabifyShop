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

	init(for product: Product) {
		self.price = product.price
		self.modifiedPrice = product.modifiedPrice
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
