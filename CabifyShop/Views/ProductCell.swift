//
//	ProductCell.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct ProductCell: View {

	@ScaledMetric private var size = 80.0
	private let product: Product

	init(product: Product) {
		self.product = product
	}

	var body: some View {
		HStack {
			VStack(spacing: 0) {
				Text(product.code.icon)
					.font(.system(size: size))
					.padding(.bottom, 16)
				Text(product.name)
					.font(.headline)
					.padding(.bottom, 8)
				PriceView(for: product, alignment: .vertical(.center))
				Spacer()
			}
			.padding(.all, 16)
			.frame(maxHeight: .infinity)
			.multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity)
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}

}

struct ProductView_Previews: PreviewProvider {

	static var previews: some View {
		ProductCell(product: Catalog.sample.products[0])
			.previewLayout(.sizeThatFits)
	}

}

