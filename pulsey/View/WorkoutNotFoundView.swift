//
//  WorkoutNotFoundView.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//


//
//  WorkoutNotFoundView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct WorkoutNotFoundView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("운동을 찾을 수 없습니다")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("요청하신 운동 데이터를 찾을 수 없습니다.\n다시 시도해 주세요.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("오류")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        onDismiss()
                    }
                    .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    WorkoutNotFoundView {
        print("닫기 버튼 탭됨")
    }
}