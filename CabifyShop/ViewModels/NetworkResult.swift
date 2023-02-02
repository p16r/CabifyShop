//
//	NetworkResult.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-01-31.
//

enum NetworkResult<Output, Failure> where Failure: Error {

	case standby
	case loading
	case success(Output)
	case failure(Failure)

	var value: Output? {
		guard case .success(let value) = self else { return nil }
		return value
	}

	var error: Failure? {
		guard case .failure(let error) = self else { return nil }
		return error
	}

}
