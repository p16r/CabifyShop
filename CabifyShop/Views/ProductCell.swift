//
//	ProductCell.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct ProductCell: View {

	@ScaledMetric private var size = 80.0
	let product: Product

	var body: some View {
		HStack {
			Spacer()
			VStack(spacing: 0) {
				Spacer(minLength: 16)
				Text(product.code.icon)
					.font(.system(size: size))
					.padding(.vertical, 16)
				Text(product.name)
					.font(.headline)
					.padding(.bottom, 8)
				Text(product.price, format: .currency(code: "EUR"))
				Spacer(minLength: 16)
			}
			.multilineTextAlignment(.center)
			Spacer()
		}
		.background(Color(uiColor: .systemBackground))
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}

}

struct ProductView_Previews: PreviewProvider {

	static var previews: some View {
		ProductCell(product: Catalog.sample.products[0])
			.previewLayout(.sizeThatFits)
	}

}

