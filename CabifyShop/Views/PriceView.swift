//
//	PriceView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-02.
//

import SwiftUI

struct PriceView: View {

	enum Layout {

		case horizontal(VerticalAlignment, accessibleHorizontalAlignment: HorizontalAlignment = .center)
		case vertical(HorizontalAlignment)

	}

	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	private let price: Decimal
	private let modifiedPrice: Decimal?
	private let layout: Layout

	private var isDiscounted: Bool {
		guard let modifiedPrice else { return false }
		return price != modifiedPrice
	}

	@ViewBuilder private var stackContents: some View {
		Text(price, format: .currency(code: "EUR"))
			.strikethrough(isDiscounted)
			.foregroundColor(isDiscounted ? .secondary : .primary)
		if isDiscounted, let modifiedPrice = modifiedPrice {
			Text(modifiedPrice, format: .currency(code: "EUR"))
		}
	}

	init(_ price: Decimal, discountedTo modifiedPrice: Decimal? = nil, layout: Layout) {
		self.price = price
		self.modifiedPrice = modifiedPrice
		self.layout = layout
	}

	init(for product: Product, layout: Layout) {
		self.init(product.price, discountedTo: product.modifiedPrice, layout: layout)
	}

	init(for cart: [CartItem], layout: Layout) {
		let (price, modifiedPrice): (Decimal, Decimal) = cart.reduce((0, 0)) { tuple, item in
			(tuple.0 + item.product.price, tuple.1 + (item.product.modifiedPrice ?? item.product.price))
		}
		self.init(price, discountedTo: modifiedPrice	, layout: layout)
	}

	var body: some View {
		switch layout {
			case .horizontal(let verticalAlignment, let accessibleHorizontalAlignment):
				if dynamicTypeSize.isAccessibilitySize {
					VStack(alignment: accessibleHorizontalAlignment, spacing: 4) {
						stackContents
					}
				} else {
					HStack(alignment: verticalAlignment, spacing: 4) {
						stackContents
					}
				}
			case .vertical(let horizontalAlignment):
				VStack(alignment: horizontalAlignment, spacing: 4) {
					stackContents
				}
		}
	}

}
