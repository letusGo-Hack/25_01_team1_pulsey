//
//  ContentView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct UserInfoView: View {
    @State private var nickname : String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var gender: String = "남성"
    @State private var age: String = ""
    
    let genderOptions = ["남성", "여성"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("개인 정보")) {
                    HStack {
                        Text("닉네임")
                        Spacer()
                        TextField("Pulsey", text: $nickname)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("키")
                        Spacer()
                        TextField("175", text: $height)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                    }
                    
                    HStack {
                        Text("체중")
                        Spacer()
                        TextField("65", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }
                    
                    HStack {
                        Text("성별")
                        Spacer()
                        Picker("성별", selection: $gender) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }
                    
                    HStack {
                        Text("나이")
                        Spacer()
                        TextField("20", text: $age)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("세")
                    }
                }
                
                Section {
                    Button(action: {
                        // 여기에 저장 로직을 추가할 수 있습니다
                        print("키: \(height)cm, 체중: \(weight)kg, 성별: \(gender), 나이: \(age)세")
                    }) {
                        HStack {
                            Spacer()
                            Text("저장")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(height.isEmpty || weight.isEmpty || age.isEmpty)
                }
                
                if !height.isEmpty && !weight.isEmpty && !age.isEmpty {
                    Section(header: Text("입력된 정보")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("키: \(height)cm")
                            Text("체중: \(weight)kg")
                            Text("성별: \(gender)")
                            Text("나이: \(age)세")
                        }
                        .font(.body)
                    }
                }
            }
            .navigationTitle("개인 정보 입력")
        }
    }
}

#Preview {
    UserInfoView()
}
