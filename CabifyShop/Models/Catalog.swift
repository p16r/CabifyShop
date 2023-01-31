//
//	Catalog.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import Foundation

struct Catalog: Decodable {

	let products: [Product]

}

extension Catalog {

	static var sample: Self {
		let json = """
		{
			"products": [
				{
					"code": "VOUCHER",
					"name": "Cabify Voucher",
					"price": 5
				},
				{
					"code": "TSHIRT",
					"name": "Cabify T-Shirt",
					"price": 20
				},
				{
					"code": "MUG",
					"name": "Cabify Coffee Mug",
					"price": 7.5
				}
			]
		}
		"""
		let data = Data(json.utf8)
		let catalog = try! JSONDecoder().decode(Self.self, from: data)
		return catalog
	}

}
