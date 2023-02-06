//
//	CatalogGrid.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct CatalogGrid: View {

	@Environment(\.dynamicTypeSize) private var dynamicTypeSize
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass

	@State private var selectedProduct: Product? = nil
	@State private var isShowingConfirmClearAlert = false

	@StateObject private var viewModel = CatalogViewModel(apiService: .gist())

	private var columns: [GridItem] {
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
							.background(Color(uiColor: .systemGroupedBackground))
					case .loading:
						ProgressView()
							.background(Color(uiColor: .systemGroupedBackground))
					case .success(let catalog):
						VStack(spacing: 0) {
							if viewModel.cart.isEmpty {
								scrollView(for: catalog)
									.refreshable {
										viewModel.fetchCatalog()
									}
							} else {
								scrollView(for: catalog)
								AccessibleStack(
									alignment: .horizontal(.center, accessibleHorizontalAlignment: HorizontalAlignment.center),
									spacing: 16
								) {
									NavigationLink(
										destination: {
											CheckoutView(
												cart: $viewModel.cart,
												didRemoveItem: { item in
													viewModel.removeFromCart(item.product)
												},
												didCheckout: { _ in
													viewModel.clearCart()
												}
											)
										},
										label: {
											Image(systemName: "cart.fill")
											VStack {
												Text("Checkout")
													.font(.headline)
												Text("\(viewModel.cart.count) item(s)")
													.font(.subheadline)
											}
										}
									)
									.font(.headline)
									.padding(.vertical, 8)
									.frame(maxWidth: .infinity)
									.background(.blue)
									.foregroundColor(.white)
									.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
									Button(
										action: {
											isShowingConfirmClearAlert = true
										},
										label: {
											Image(systemName: "cart.fill.badge.minus")
											Text("Clear cart")
												.font(.headline)
										}
									)
									.font(.headline)
									.padding(.vertical, 8)
									.frame(maxWidth: .infinity, maxHeight: .infinity)
									.background(.red.opacity(0.25))
									.foregroundColor(.red)
									.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
									.alert(isPresented: $isShowingConfirmClearAlert) {
										Alert(
											title: Text("Confirm clear"),
											message: Text("Clear cart?"),
											primaryButton: .destructive(Text("Clear")) {
												viewModel.clearCart()
											},
											secondaryButton: .cancel()
										)
									}
								}
								.fixedSize(horizontal: false, vertical: true)
								.scenePadding(.horizontal)
								.padding(.vertical, 16)
								.background(Color(uiColor: .secondarySystemGroupedBackground))
								.clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
								.padding([.horizontal, .top], 16)
								.background(Color(uiColor: .systemGroupedBackground))
							}
						}
					case .failure(let error):
						VStack(spacing: 8) {
							Text(error.localizedDescription)
							Button("Retry", action: viewModel.fetchCatalog)
						}
						.background(Color(uiColor: .systemGroupedBackground))
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

	private func scrollView(for catalog: Catalog) -> some View {
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
	}

}

struct CatalogList_Previews: PreviewProvider {

	static var previews: some View {
		CatalogGrid()
	}

}
