//
//  Product.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

struct Product: Decodable, Identifiable {
    
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    static func mock(id: Int) -> Self {
        Product(
            id: id,
            title: "String",
            price: Double.random(
                in: 2.71828...3.14159
            ),
            description: "String",
            category: "String",
            image: "String"
        )
    }
    
}
