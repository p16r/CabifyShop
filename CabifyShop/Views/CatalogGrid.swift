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

	@StateObject var viewModel = CatalogViewModel()

	let catalog: Catalog = .sample
	var columns: [GridItem] {
		horizontalSizeClass == .compact && dynamicTypeSize.isAccessibilitySize
			? [.init()]
			: [.init(spacing: 16), .init()]
	}

	var body: some View {
		NavigationStack {
			Group {
				switch viewModel.catalog {
					case .standby:
						Button("Fetch Catalog", action: viewModel.fetchCatalog)
							.background(Color(uiColor: .systemBackground))
					case .loading:
						ProgressView()
							.background(Color(uiColor: .systemBackground))
					case .success(let catalog):
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
					case .failure(let error):
						VStack(spacing: 8) {
							Text(error.localizedDescription)
							Button("Retry", action: viewModel.fetchCatalog)
						}
						.background(Color(uiColor: .systemBackground))
				}
			}
			.sheet(item: $selectedProduct) {
				ProductDetailView(product: $0) { action, product in
					switch action {
						case .added:
							viewModel.addToCart(product)
						case .removed:
							viewModel.removeFromCart(product)
					}
				}
			}
			.navigationTitle("Cabify Shop")
			.background(Color(uiColor: .systemGroupedBackground))
		}
		.task {
			viewModel.fetchCatalog()
		}
	}

}

struct CatalogList_Previews: PreviewProvider {

	static var previews: some View {
		CatalogGrid()
	}

}
