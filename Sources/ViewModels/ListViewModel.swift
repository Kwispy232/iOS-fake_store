//
//  ListViewModel.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import Foundation
import Combine

class ListViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var categories: [String] = []
    @Published var selectedCategory: String? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let requestManager: RequestManager
    
    init(requestManager: RequestManager = .shared) {
        self.requestManager = requestManager
    }
    
    func fetchProducts() {
        isLoading = true
        loadPlaceholderData()
        errorMessage = nil
        
        requestManager.fetchAllProducts()
            .done { [weak self] products in
                self?.products = products
                self?.isLoading = false
            }
            .catch { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
    }
    
    func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        requestManager.fetchAllCategories()
            .done { [weak self] categories in
                self?.categories = categories
                self?.isLoading = false
            }
            .catch { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
    }
    
    func fetchProducts(with category: String) {
        isLoading = true
        loadPlaceholderData()
        errorMessage = nil
        
        requestManager.fetchProducts(with: category)
            .done { [weak self] products in
                self?.products = products
                self?.isLoading = false
            }
            .catch { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
    }
    
    func toggleCategorySelection(_ category: String) {
        if selectedCategory == category {
            clearSelectedCategory()
        } else {
            selectedCategory = category
            fetchProducts(with: category)
        }
    }
    
    func clearSelectedCategory() {
        selectedCategory = nil
        fetchProducts()
    }
    
    private func loadPlaceholderData() {
        self.products = (1...100).map { Product.mock(id: $0) }
    }
    
}
