//
//	Code.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

import Foundation

enum Code: String, Hashable, Decodable {

	case voucher = "VOUCHER"
	case tshirt = "TSHIRT"
	case mug = "MUG"

	var icon: String {
		switch self {
			case .voucher:
				return "🏷️"
			case .tshirt:
				return "👕"
			case .mug:
				return "☕️"
		}
	}

}
