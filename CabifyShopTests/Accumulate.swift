//
//	Accumulate.swift
//	CabifyShopTests
//
//	Created by Prathamesh Kowarkar on 2023-02-03.
//

import Combine

extension Subscribers {

	class Accumulate<Input>: Subscriber {

		typealias Failure = Never

		private(set) var inputs: [Input] = []
		var latest: Input? { inputs.last }

		private var subscription: Subscription?

		init(_ publisher: any Publisher<Input, Failure>) {
			publisher.subscribe(self)
		}

		func receive(subscription: Subscription) {
			self.subscription = subscription
			subscription.request(.unlimited)
		}

		func receive(_ input: Input) -> Subscribers.Demand {
			inputs.append(input)
			return .none
		}

		func receive(completion: Subscribers.Completion<Failure>) {
		}

	}

}

extension Publisher where Failure == Never {

	func accumulate() -> Subscribers.Accumulate<Output> {
		.init(self)
	}

}

