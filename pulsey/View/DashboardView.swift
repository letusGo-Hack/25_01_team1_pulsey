//
//  DashboardView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedMonth = Date.now
    @State private var selectedDate: Date? = Date.now
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CalendarComponent(month: $selectedMonth, selected: $selectedDate)
                Divider()
                Text("상품")
//                    .foregroundStyle(.label(.alternative))
                    .frame(maxWidth: .infinity, alignment: .leading)
//                if let products = viewModel.products, let selected {
//                    let filteredProducts = products.filter {
//                        $0.expirationDate.equals(selected, components: [.year, .month, .day], using: calendar)
//                    }
//                    if filteredProducts.isEmpty {
//                        Text("상품이 없습니다")
//                            .foregroundStyle(.label(.alternative))
//                            .font(.body)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .padding(.top, 20)
//                    } else {
//                        ForEach(filteredProducts) { product in
//                            Button {
//                                selectedProduct = product
//                            } label: {
//                                ProductCell(product: product) { action in
//                                    switch action {
//                                    case .removeProduct:
//                                        showDeleteProductAlert = true
//                                        selectedDeleteProduct = product
//                                    }
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    ProgressView()
//                }
            }
        }
        .task {
            do {
                let data = try await HealthKitManager.shared.fetchWorkouts()
                data.forEach {
                    print($0)
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    DashboardView()
}
