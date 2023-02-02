//
//	ProductDetailView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct ProductDetailView: View {

	@Environment(\.dismiss) private var dismiss

	let product: Product
	let cartAction: (CartAction, Product) -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(product.code.icon)
				.font(.system(size: 160))
				.frame(maxWidth: .infinity)
			Text(product.name)
				.font(.title)
			PriceView(for: product, layout: .horizontal(.firstTextBaseline))
				.padding(.bottom, 16)
			HStack(spacing: 16) {
				Button("Add To Cart") {
					dismiss()
					cartAction(.added, product)
				}
				.font(.body.bold())
				.frame(maxWidth: .infinity, minHeight: 44)
				.background(.blue)
				.foregroundColor(.white)
				.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
				Button("Remove from Cart") {
					dismiss()
					cartAction(.removed, product)
				}
				.frame(maxWidth: .infinity, minHeight: 44)
				.background(.red)
				.foregroundColor(.white)
				.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
			}
			.frame(maxWidth: .infinity)
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.padding(.vertical, 16)
		.scenePadding(.horizontal)
	}

}

struct ProductDetailView_Previews: PreviewProvider {

	static var previews: some View {
		ProductDetailView(product: Catalog.sample.products[0]) { _, _ in }
	}

}
