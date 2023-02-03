//
//	APIService.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-03.
//

import Combine
import Foundation

protocol APIService {

	func catalogPublisher() -> AnyPublisher<Data, URLError>

}
