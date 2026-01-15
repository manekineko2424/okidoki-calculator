//
//  InputAreaView.swift
//  MyFirstApp
//
//  分離型UI - 入力エリア
//

import SwiftUI

/// 入力エリア
struct InputAreaView: View {
    @Binding var gInput: String
    let isFirstEntry: Bool  // 初回入力かどうか（履歴が空）
    let isEditMode: Bool    // 編集モードかどうか
    let onTypeSelect: (HitType?) -> Void  // 種別選択時のコールバック（nilは「現在」）
    let onDeleteOne: () -> Void
    let onDeleteAll: () -> Void
    let onAddResetBar: () -> Void
    let onCancelEdit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // ゲーム数入力
            HStack {
                Text("ゲーム数")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                TextField("", text: $gInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 16))

                Text("G")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            // 種別ボタン
            VStack(alignment: .leading, spacing: 8) {
                Text("種別")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                HStack(spacing: 8) {
                    // 現在ボタン
                    TypeButton(
                        title: "現在",
                        isEnabled: isFirstEntry,
                        color: .gray
                    ) {
                        onTypeSelect(nil)
                    }

                    // RBボタン
                    TypeButton(
                        title: "RB",
                        isEnabled: !isFirstEntry,
                        color: .blue
                    ) {
                        onTypeSelect(.rb)
                    }

                    // BBボタン
                    TypeButton(
                        title: "BB",
                        isEnabled: !isFirstEntry,
                        color: .red
                    ) {
                        onTypeSelect(.bb)
                    }

                    // 最終ボタン
                    TypeButton(
                        title: "最終",
                        isEnabled: !isFirstEntry,
                        color: .primary
                    ) {
                        onTypeSelect(.fin)
                    }
                }
                .padding(.horizontal)
            }

            // 編集モード時のキャンセルボタン
            if isEditMode {
                Button(action: onCancelEdit) {
                    Text("編集をキャンセル")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }

            Divider()
                .padding(.vertical, 4)

            // アクションボタン
            HStack(spacing: 8) {
                InputActionButton(title: "1つ削除", action: onDeleteOne)
                InputActionButton(title: "全削除", isDestructive: true, action: onDeleteAll)
                InputActionButton(title: "リセット位置", action: onAddResetBar)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

/// 種別ボタン
struct TypeButton: View {
    let title: String
    let isEnabled: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isEnabled ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isEnabled ? color : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(!isEnabled)
    }
}

/// アクションボタン（入力エリア用）
private struct InputActionButton: View {
    let title: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundStyle(isDestructive ? .red : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isDestructive ? Color.red.opacity(0.3) : Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}

#Preview {
    VStack {
        InputAreaView(
            gInput: .constant("100"),
            isFirstEntry: true,
            isEditMode: false,
            onTypeSelect: { _ in },
            onDeleteOne: {},
            onDeleteAll: {},
            onAddResetBar: {},
            onCancelEdit: {}
        )

        InputAreaView(
            gInput: .constant("200"),
            isFirstEntry: false,
            isEditMode: true,
            onTypeSelect: { _ in },
            onDeleteOne: {},
            onDeleteAll: {},
            onAddResetBar: {},
            onCancelEdit: {}
        )
    }
}
