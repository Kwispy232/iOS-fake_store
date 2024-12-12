//
//  ProductDetailViewModel.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    
    @Published var product: Product
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let requestManager: RequestManager
    private let productId: Int
    
    let category: String
    
    init(productId: Int, category: String, requestManager: RequestManager = .shared) {
        self.product = Product.mock(id: productId)
        self.productId = productId
        self.requestManager = requestManager
        self.category = category
    }
    
    func fetchProductDetail() {
        isLoading = true
        errorMessage = nil
        
        requestManager.fetchProduct(with: productId)
            .done { [weak self] product in
                self?.product = product
                self?.isLoading = false
            }
            .catch { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
    }
    
}
