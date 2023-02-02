//
//	CheckoutView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-01.
//

import SwiftUI

struct CheckoutView: View {

	let cart: [CartItem]
	let didCheckout: (CheckoutAction) -> Void

	@Environment(\.dismiss) private var dismiss

	@State private var isShowingConfirmPurchaseAlert = false
	@State private var isShowingConfirmClearAlert = false

	var body: some View {
		ZStack(alignment: .bottom) {
			List {
				Section {
					ForEach(cart) { item in
						HStack(spacing: 8) {
							Text(item.product.code.icon)
								.font(.largeTitle)
							Text(item.product.name)
								.font(.headline)
							Spacer()
							PriceView(for: item.product)
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
						PriceView(for: cart)
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
			}
			.scenePadding(.horizontal)
			.padding(.vertical, 16)
			.background(.ultraThinMaterial)
		}
		.alert(isPresented: $isShowingConfirmPurchaseAlert) {
			Alert(
				title: Text("Confirm Purchase"),
				message: Text("Proceed with purchase?"),
				primaryButton: .default(Text("Purchase")) {
					didCheckout(.purchased(cart))
					dismiss()
				},
				secondaryButton: .cancel()
			)
		}
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

}

struct CheckoutView_Previews: PreviewProvider {

	static var previews: some View {
		CheckoutView(cart: Catalog.sample.products.map(CartItem.init)) { _ in }
	}

}
