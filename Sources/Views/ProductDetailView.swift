//
//  ProductDetailView.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import SwiftUI

struct ProductDetailView: View {
    
    @ObservedObject var viewModel: ProductDetailViewModel
    
    init(productId: Int, category: String) {
        viewModel = ProductDetailViewModel(productId: productId, category: category)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                AsyncImage(url: URL(string: viewModel.product.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(.bottom, 16)
                
                Text(viewModel.product.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundStyle(Color(uiColor: UIColor.blue))
                
                Text(viewModel.product.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("ID produktu:")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text("\(viewModel.product.id)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .trailing) {
                        Text("Cena:")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text("\(viewModel.product.price, specifier: "%.2f") €")
                    }
                }
            }
            .padding(.all, 32)
            .shimmer(when: $viewModel.isLoading)
            .onAppear {
                viewModel.fetchProductDetail()
            }
            .navigationTitle(viewModel.category)
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                Text(viewModel.errorMessage ?? "Unknown error"),
                isPresented: .constant(viewModel.errorMessage != nil)
            ) {
                Button("Retry") {
                    viewModel.fetchProductDetail()
                }
            }
        }
    }
    
}
