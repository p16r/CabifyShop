//
//	CartItem.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-02.
//

import Foundation

struct CartItem: Identifiable, Equatable {

	let id = UUID()
	let product: Product

	static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}

}
