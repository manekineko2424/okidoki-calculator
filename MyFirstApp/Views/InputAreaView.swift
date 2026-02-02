//
//  InputAreaView.swift
//  MyFirstApp
//
//  分離型UI - 入力エリア（シンプル版）
//

import SwiftUI

/// 入力エリア
struct InputAreaView: View {
    @Binding var gInput: String
    let hasCurrentRow: Bool  // 「現在」行が既に存在するか
    let onRegister: (HitType?) -> Void  // 登録コールバック（nilは「現在」）

    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 8) {
            // G数入力フィールド
            Text("G数を入力")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                TextField("0", text: $gInput)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isInputFocused ? Color.accentColor : Color(.systemGray4), lineWidth: isInputFocused ? 2 : 1)
                    )
                    .focused($isInputFocused)

                Text("G")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            // 種別ボタン（タップで即登録）
            Text("種別を選択して登録")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                // 「現在」ボタン（現在行がない場合のみ有効）
                if !hasCurrentRow {
                    RegisterButton(
                        title: "現在",
                        color: .gray,
                        isEnabled: isValidInput
                    ) {
                        onRegister(nil)
                    }
                }

                // RBボタン
                RegisterButton(
                    title: "RB",
                    color: .blue,
                    isEnabled: isValidInput && hasCurrentRow
                ) {
                    onRegister(.rb)
                }

                // BBボタン
                RegisterButton(
                    title: "BB",
                    color: .red,
                    isEnabled: isValidInput && hasCurrentRow
                ) {
                    onRegister(.bb)
                }

                // 最終ボタン
                RegisterButton(
                    title: "最終",
                    color: .primary,
                    isEnabled: isValidInput && hasCurrentRow
                ) {
                    onRegister(.fin)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            isInputFocused = true
        }
    }

    private var isValidInput: Bool {
        guard let value = Int(gInput), value > 0 else { return false }
        return true
    }
}

/// 登録ボタン
struct RegisterButton: View {
    let title: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(isEnabled ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isEnabled ? color : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
    }
}

#Preview("初回入力（現在行なし）") {
    VStack {
        InputAreaView(
            gInput: .constant("100"),
            hasCurrentRow: false,
            onRegister: { _ in }
        )
        .padding()
    }
    .background(Color(.systemBackground))
}

#Preview("通常入力（現在行あり）") {
    VStack {
        InputAreaView(
            gInput: .constant("200"),
            hasCurrentRow: true,
            onRegister: { _ in }
        )
        .padding()
    }
    .background(Color(.systemBackground))
}
