//
//  RequestManager.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import Foundation
import Alamofire
import PromiseKit

class RequestManager {
    
    static let shared = RequestManager()
    
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session = Session(configuration: configuration)
    }
    
    func get(url: String, parameters: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Promise<Data> {
        return Promise { seal in
            session.request(url, method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        seal.fulfill(data)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
        }
    }
    
    func decode<T: Decodable>(_ data: Data, to type: T.Type) -> Promise<T> {
        return Promise { seal in
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                seal.fulfill(model)
            } catch {
                seal.reject(error)
            }
        }
    }
    
}

extension RequestManager {
    
    func fetchAllProducts() -> Promise<[Product]> {
        let url = "https://fakestoreapi.com/products"
        return get(url: url).then { data in
            self.decode(data, to: [Product].self)
        }
    }
    
    func fetchAllCategories() -> Promise<[String]> {
        let url = "https://fakestoreapi.com/products/categories"
        return get(url: url).then { data in
            self.decode(data, to: [String].self)
        }
    }
    
    func fetchProducts(with category: String) -> Promise<[Product]> {
        let url = "https://fakestoreapi.com/products/category/\(category)"
        return get(url: url).then { data in
            self.decode(data, to: [Product].self)
        }
    }
    
    func fetchProduct(with id: Int) -> Promise<Product> {
        let url = "https://fakestoreapi.com/products/\(id)"
        return get(url: url).then { data in
            self.decode(data, to: Product.self)
        }
    }
    
}


