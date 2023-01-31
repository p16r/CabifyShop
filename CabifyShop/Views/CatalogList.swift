//
//	CatalogList.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct CatalogList: View {

	let catalog: Catalog = .sample
	let columns: [GridItem] = [.init(spacing: 16), .init()]

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: 16) {
					ForEach(catalog.products) {
						ProductCell(product: $0)
					}
				}
			}
			.navigationTitle("Cabify Shop")
		}
	}

}

struct CatalogList_Previews: PreviewProvider {

	static var previews: some View {
		CatalogList()
	}

}
