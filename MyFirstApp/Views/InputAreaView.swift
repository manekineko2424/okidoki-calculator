//
//  InputAreaView.swift
//  MyFirstApp
//
//  分離型UI - 入力エリア（Chrome AI風デザイン）
//

import SwiftUI

/// 入力エリア
struct InputAreaView: View {
    @Binding var gInput: String
    @Binding var inputMode: InputMode
    let hasCurrentRow: Bool  // 「現在」行が既に存在するか
    let isFirstEntry: Bool   // 履歴が空かどうか
    let onRegister: (HitType?) -> Void  // 登録コールバック（nilは「現在」）

    @FocusState private var isInputFocused: Bool

    /// モード切替が有効か（履歴がある場合のみ）
    private var isModeToggleEnabled: Bool {
        hasCurrentRow
    }

    var body: some View {
        VStack(spacing: 8) {
            // G数入力フィールド + モード切替ボタン（入力欄内）
            HStack(spacing: 8) {
                TextField("ゲーム数", text: $gInput)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .focused($isInputFocused)

                // モード切替ボタン（Chrome AI風、常に表示）
                ModeToggleButton(
                    mode: inputMode,
                    isEnabled: isModeToggleEnabled,
                    modeColor: inputMode.color
                ) {
                    inputMode = inputMode.toggled
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isInputFocused ? Color.accentColor : Color(.systemGray4), lineWidth: isInputFocused ? 2 : 1)
            )

            // 種別ボタン（タップで即登録）
            Text("種別を選択して登録")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !hasCurrentRow {
                // 履歴なし: 「現在」ボタンのみ表示
                HStack(spacing: 10) {
                    RegisterButton(
                        title: "現在",
                        color: .gray,
                        isEnabled: isValidInput
                    ) {
                        onRegister(nil)
                    }
                }
            } else {
                // 履歴あり: 4つのボタンを表示（モードで有効/無効を制御）
                HStack(spacing: 10) {
                    // 「現在」ボタン（実戦中モードのみ有効）
                    RegisterButton(
                        title: "現在",
                        color: .gray,
                        isEnabled: isValidInput && inputMode == .realtime
                    ) {
                        onRegister(nil)
                    }

                    // RBボタン（両モードで有効）
                    RegisterButton(
                        title: "RB",
                        color: .blue,
                        isEnabled: isValidInput
                    ) {
                        onRegister(.rb)
                    }

                    // BBボタン（両モードで有効）
                    RegisterButton(
                        title: "BB",
                        color: .red,
                        isEnabled: isValidInput
                    ) {
                        onRegister(.bb)
                    }

                    // 最終ボタン（履歴入力モードのみ有効）
                    RegisterButton(
                        title: "最終",
                        color: .primary,
                        isEnabled: isValidInput && inputMode == .history
                    ) {
                        onRegister(.fin)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            isInputFocused = true
        }
        .onChange(of: isFirstEntry) { _, newValue in
            // 履歴が空になったらモードをリセット
            if newValue {
                inputMode = .history
            }
        }
    }

    private var isValidInput: Bool {
        guard let value = Int(gInput), value > 0 else { return false }
        return true
    }
}

/// モード切替ボタン（Chrome AI風 Capsule）
struct ModeToggleButton: View {
    let mode: InputMode
    let isEnabled: Bool
    let modeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: mode.iconNameFill)
                    .font(.system(size: 14))
                Text(mode.displayName)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isEnabled ? modeColor : .gray)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isEnabled ? modeColor.opacity(0.15) : Color(.systemGray5))
            )
            .overlay(
                Capsule()
                    .stroke(isEnabled ? modeColor.opacity(0.3) : Color(.systemGray4), lineWidth: 1)
            )
        }
        .disabled(!isEnabled)
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
            inputMode: .constant(.history),
            hasCurrentRow: false,
            isFirstEntry: true,
            onRegister: { _ in }
        )
        .padding()
    }
    .background(Color(.systemBackground))
}

#Preview("履歴入力モード") {
    VStack {
        InputAreaView(
            gInput: .constant("200"),
            inputMode: .constant(.history),
            hasCurrentRow: true,
            isFirstEntry: false,
            onRegister: { _ in }
        )
        .padding()
    }
    .background(Color(.systemBackground))
}

#Preview("実戦中モード") {
    VStack {
        InputAreaView(
            gInput: .constant("200"),
            inputMode: .constant(.realtime),
            hasCurrentRow: true,
            isFirstEntry: false,
            onRegister: { _ in }
        )
        .padding()
    }
    .background(Color(.systemBackground))
}
