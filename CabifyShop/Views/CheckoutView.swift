//
//	CheckoutView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-01.
//

import SwiftUI

struct CheckoutView: View {

	@Binding var cart: [CartItem]

	let didRemoveItem: (CartItem) -> Void
	let didCheckout: (CheckoutAction) -> Void

	@Environment(\.dismiss) private var dismiss

	@State private var isShowingConfirmPurchaseAlert = false
	@State private var isShowingConfirmClearAlert = false

	var body: some View {
		VStack(spacing: 0) {
			List {
				Section {
					ForEach(cart) { item in
						HStack(spacing: 8) {
							Text(item.product.code.icon)
								.font(.largeTitle)
							Text(item.product.name)
								.font(.headline)
							Spacer()
							PriceView(for: item.product, layout: .horizontal(.firstTextBaseline))
						}
					}
					.onDelete { indexSet in
						indexSet.forEach {
							didRemoveItem(cart[$0])
						}
						if cart.isEmpty {
							dismiss()
						}
					}
				}
				Section {
					HStack(spacing: 8) {
						Text("💵")
							.font(.largeTitle)
						Text("Total")
							.font(.headline)
						Spacer()
						PriceView(for: cart, layout: .horizontal(.firstTextBaseline))
					}
				}
			}
			HStack {
				Button(
					action: {
						isShowingConfirmPurchaseAlert = true
					},
					label: {
						Image(systemName: "checkmark")
						Text("Purchase")
							.font(.headline)
					}
				)
				.font(.headline)
				.frame(maxWidth: .infinity, minHeight: 44)
				.background(.blue)
				.foregroundColor(.white)
				.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
				.alert(isPresented: $isShowingConfirmPurchaseAlert) {
					let price = cart.reduce(0) { sum, item in
						sum + (item.product.modifiedPrice ?? item.product.price)
					}
					return Alert(
						title: Text("Confirm Purchase"),
						message: Text("Purchase \(cart.count) item(s) worth \(Text(price, format: .currency(code: "EUR")))?"),
						primaryButton: .default(Text("Purchase")) {
							didCheckout(.purchased(cart))
							dismiss()
						},
						secondaryButton: .cancel()
					)
				}
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
				.frame(maxWidth: .infinity, minHeight: 44)
				.background(.red)
				.foregroundColor(.white)
				.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
				.alert(isPresented: $isShowingConfirmClearAlert) {
					Alert(
						title: Text("Confirm clear"),
						message: Text("Clear cart?"),
						primaryButton: .destructive(Text("Clear")) {
							didCheckout(.cleared)
							dismiss()
						},
						secondaryButton: .cancel()
					)
				}
			}
			.scenePadding(.horizontal)
			.padding(.vertical, 16)
			.background(Color(uiColor: .systemBackground))
			.clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
			.padding([.horizontal, .top], 16)
			.background(Color(uiColor: .systemGroupedBackground))
		}
		.navigationTitle("Checkout")
		.navigationBarTitleDisplayMode(.inline)
	}

}

struct CheckoutView_Previews: PreviewProvider {

	static var previews: some View {
		CheckoutView(
			cart: .constant(Catalog.sample.products.map(CartItem.init)),
			didRemoveItem: { _ in },
			didCheckout: { _ in }
		)
	}

}
