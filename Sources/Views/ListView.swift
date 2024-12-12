//
//  ContentView.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject private var viewModel = ListViewModel()
    @State private var showFilterMenu: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                Divider()
                List(viewModel.products) { product in
                    productRow(product: product)
                        .overlay {
                            NavigationLink(
                                destination: ProductDetailView(productId: product.id, category: product.category),
                                label: { EmptyView() }
                            )
                            .opacity(0)
                            .disabled(viewModel.isLoading)
                        }
                }
                .listStyle(.plain)
                .shimmer(when: $viewModel.isLoading)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.selectedCategory ?? "Produkty")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(viewModel.selectedCategory ?? "Produkty")
                            .font(.headline)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFilterMenu = true
                        }) {
                            Text("Filter")
                        }
                        .disabled($viewModel.categories.isEmpty)
                    }
                }
                .onAppear {
                    if let category = viewModel.selectedCategory {
                        viewModel.fetchProducts(with: category)
                    } else {
                        viewModel.fetchProducts()
                        viewModel.fetchCategories()
                    }
                }
                .confirmationDialog("Select Category", isPresented: $showFilterMenu) {
                    ForEach(
                        viewModel.categories.sorted { st1, _ in st1 == viewModel.selectedCategory },
                        id: \.self
                    ) { category in
                        Button(
                            viewModel.selectedCategory == category
                            ? "zrušiť \(category)"
                            : category,
                            role: viewModel.selectedCategory == category ? .destructive : .none
                        ) {
                            if viewModel.selectedCategory == category {
                                viewModel.clearSelectedCategory()
                            } else {
                                viewModel.toggleCategorySelection(category)
                            }
                        }
                    }
                }
                .alert(
                    Text(viewModel.errorMessage ?? "Unknown error"),
                    isPresented: .constant(viewModel.errorMessage != nil)
                ) {
                    Button("Retry") {
                        viewModel.fetchProducts()
                        viewModel.fetchCategories()
                    }
                }
            }
        }
    }
    
}

// MARK: - Components

private extension ListView {
    
    func productRow(product: Product) -> some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 64)
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(product.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 16)
    }
    
}

