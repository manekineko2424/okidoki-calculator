//
//  SettingsRowView.swift
//  MyFirstApp
//
//  v2準拠: 内部加算 / 有利区間上限G
//  機種選択は画面下部のMachineTabBarに移動
//

import SwiftUI

/// 設定値入力エリア
struct SettingsRowView: View {
    @Binding var rbAdd: String
    @Binding var bbAdd: String
    @Binding var limitG: String
    let isCustom: Bool

    private let inputGroupWidth: CGFloat = 230

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("内部加算")
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Text("RB")
                            .font(.system(size: 12.5, weight: .bold))
                            .fixedSize()
                        TextField("", text: $rbAdd)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 70)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 16))
                            .disabled(!isCustom)
                            .opacity(isCustom ? 1 : 0.6)
                        Text("G")
                            .font(.system(size: 12.5))
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 6) {
                        Text("BB")
                            .font(.system(size: 12.5, weight: .bold))
                            .fixedSize()
                        TextField("", text: $bbAdd)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 70)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 16))
                            .disabled(!isCustom)
                            .opacity(isCustom ? 1 : 0.6)
                        Text("G")
                            .font(.system(size: 12.5))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: inputGroupWidth, alignment: .trailing)
            }

            HStack {
                Text("有利区間上限G")
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                TextField("", text: $limitG)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: inputGroupWidth)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsRowView(
        rbAdd: .constant("24"),
        bbAdd: .constant("59"),
        limitG: .constant("2000"),
        isCustom: false
    )
}
