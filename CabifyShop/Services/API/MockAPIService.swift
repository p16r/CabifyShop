//
//	MockAPIService.swift
//	CabifyShopTests
//
//	Created by Prathamesh Kowarkar on 2023-02-03.
//

import Combine
import Foundation
@testable import CabifyShop

struct MockAPIService: APIService {

	func catalogPublisher() -> AnyPublisher<Data, URLError> {
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
		return Just(Data(json.utf8))
			.setFailureType(to: URLError.self)
			.eraseToAnyPublisher()
	}

}

extension APIService where Self == MockAPIService {

	static func mock() -> MockAPIService {
		.init()
	}

}
