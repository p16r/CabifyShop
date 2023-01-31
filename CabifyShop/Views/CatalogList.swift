//
//	CatalogList.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import SwiftUI

struct CatalogList: View {

	let catalog: Catalog = .sample

	var body: some View {
		NavigationStack {
			List {
				ForEach(catalog.products) {
					Text($0.name)
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
