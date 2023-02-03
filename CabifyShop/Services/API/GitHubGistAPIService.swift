//
//	GitHubGistAPIService.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-03.
//

import Combine
import Foundation

struct GitHubGistAPIService: APIService {

	func catalogPublisher() -> AnyPublisher<Data, URLError> {
		let url = URL(string: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")!
		return URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)
			.eraseToAnyPublisher()
	}

}

extension APIService where Self == GitHubGistAPIService {

	static func gist() -> GitHubGistAPIService {
		.init()
	}

}
