//
//	CatalogGrid.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct CatalogGrid: View {

	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	@Environment(\.horizontalSizeClass) var horizontalSizeClass

	@State var selectedProduct: Product? = nil

	let catalog: Catalog = .sample
	var columns: [GridItem] {
		horizontalSizeClass == .compact && dynamicTypeSize.isAccessibilitySize
			? [.init()]
			: [.init(spacing: 16), .init()]
	}

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: 16) {
					ForEach(catalog.products) { product in
						ProductCell(product: product)
							.onTapGesture {
								selectedProduct = product
							}
					}
				}
			}
			.scenePadding(.horizontal)
			.navigationTitle("Cabify Shop")
			.background(Color(uiColor: .systemGroupedBackground))
		}
	}

}

struct CatalogList_Previews: PreviewProvider {

	static var previews: some View {
		CatalogGrid()
	}

}
