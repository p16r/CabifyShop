//
//	Product.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import Foundation

struct Product: Hashable, Decodable, Identifiable {

	var id: Code { code }

	let code: Code
	let name: String
	let price: Decimal
	var modifiedPrice: Decimal? = nil

}
