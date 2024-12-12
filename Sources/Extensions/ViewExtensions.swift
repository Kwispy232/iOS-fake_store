//
//  ViewExtensions.swift
//  iOS-fake_store
//
//  Created by Sebastian Mraz on 12/12/2024.
//

import SwiftUICore

extension View {
    
    @ViewBuilder
    func shimmer(when isLoading: Binding<Bool>) -> some View {
        if isLoading.wrappedValue {
            self.modifier(Shimmer())
                .redacted(reason: isLoading.wrappedValue ? .placeholder : [])
        } else {
            self
        }
    }
    
}
