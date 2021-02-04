//
//  NetworkRequest.swift
//
//  Created for Miner by Michael Simone
//

import Foundation
import UIKit

protocol NetworkRequest: AnyObject {
	associatedtype ModelType
	func decode(_ data: Data) -> ModelType?
	func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
	fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
		print(url)
		let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
		let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
			let s = String(decoding: data!, as: UTF8.self)
			print("data for \(url): \(data)   s:\(s)  error:\(error)")
			guard let data = data else {
				completion(nil)
				return
			}
			completion(self?.decode(data))
		})
		task.resume()
	}
}

class APIRequest<Resource: APIResource> {
	let resource: Resource
	
	init(resource: Resource) {
		self.resource = resource
	}
}

extension APIRequest: NetworkRequest {
	func decode(_ data: Data) -> Resource.ModelType? {
		let wrapper = try? JSONDecoder().decode(Wrapper<Resource.ModelType>.self, from: data)
        return (wrapper as! Resource.ModelType)
	}
	
	func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
		load(resource.url, withCompletion: completion)
	}
}

protocol APIResource {
	associatedtype ModelType: Decodable
	var methodPath: String { get }
}

extension APIResource {
	var url: URL {
		//var components = URLComponents(string: "https://mining.blockstream.com/api/v1/user/")!
		//var components = URLComponents(string: "https://mining.blockstream.com/api/user/")!
		var components = URLComponents(string: "https://mining.blockstream.com/api/v1")!
		components.path = components.path + methodPath
		return components.url!
	}
}

struct MinerResource: APIResource {
    typealias ModelType = Miner
    let methodPath = "/listmy/:page/:size"
}

struct InvoiceResource: APIResource {
    typealias ModelType = Invoice
    let methodPath = "/getInvoiceById/:id"
}


struct UserResource: APIResource {
    typealias ModelType = UnderlyingValue
    let methodPath = "/update"
}


struct HashRateResource: APIResource {
	typealias ModelType = HashRate
	let methodPath = "/getcurrenthashrate"
}

/*
struct ElectricityResource: APIResource {
    typealias ModelType = Electricity
    let methodPath = "/getelectricityUsed"
}
*/
