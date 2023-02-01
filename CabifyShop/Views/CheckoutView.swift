//
//	CheckoutView.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-01.
//

import SwiftUI

struct CheckoutView: View {

	let cart: [Product]
	let didPurchase: ([Product]) -> Void

	@Environment(\.dismiss) private var dismiss

	@State private var isShowingConfirmPurchaseAlert = false

	var body: some View {
		ZStack(alignment: .bottom) {
			List {
				Section {
					ForEach(cart) { product in
						HStack(spacing: 8) {
							Text(product.code.icon)
								.font(.largeTitle)
							Text(product.name)
								.font(.headline)
							Spacer()
							Text(product.price, format: .currency(code: "EUR"))
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
						Text(
							cart.reduce(.zero, { sum, product in sum + product.price }),
							format: .currency(code: "EUR")
						)
					}
				}
			}
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
			.scenePadding(.horizontal)
			.padding(.vertical, 16)
			.background(.ultraThinMaterial)
		}
		.alert(isPresented: $isShowingConfirmPurchaseAlert) {
			Alert(
				title: Text("Confirm Purchase"),
				message: Text("Proceed with purchase?"),
				primaryButton: .default(Text("Purchase")) {
					didPurchase(cart)
					dismiss()
				},
				secondaryButton: .cancel()
			)
		}
	}

}

struct CheckoutView_Previews: PreviewProvider {

	static var previews: some View {
		CheckoutView(cart: Catalog.sample.products) { _ in }
	}

}
