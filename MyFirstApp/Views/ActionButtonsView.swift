//
//  ActionButtonsView.swift
//  MyFirstApp
//

import SwiftUI

/// 行操作ボタン群（5ボタン）
struct ActionButtonsView: View {
    let onAddAbove: () -> Void
    let onRemoveAbove: () -> Void
    let onAddBelow: () -> Void
    let onRemoveBelow: () -> Void
    let onClearAll: () -> Void
    let canRemoveAbove: Bool
    let canRemoveBelow: Bool

    var body: some View {
        VStack(spacing: 8) {
            // 上段: 上に追加 / 上を削除 / 下に追加 / 下を削除
            HStack(spacing: 8) {
                ActionButton(
                    title: "上に追加",
                    action: onAddAbove
                )

                ActionButton(
                    title: "上を削除",
                    action: onRemoveAbove,
                    isEnabled: canRemoveAbove
                )

                ActionButton(
                    title: "下に追加",
                    action: onAddBelow
                )

                ActionButton(
                    title: "下を削除",
                    action: onRemoveBelow,
                    isEnabled: canRemoveBelow
                )
            }

            // 下段: すべて削除
            ActionButton(
                title: "すべて削除",
                action: onClearAll,
                isDestructive: true
            )
            .frame(maxWidth: 200)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

/// 個別アクションボタン
struct ActionButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isDestructive: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.bordered)
        .tint(isDestructive ? .red : Color(red: 0.02, green: 0.41, blue: 0.63))
        .controlSize(.regular)
        .disabled(!isEnabled)
    }
}

#Preview {
    ActionButtonsView(
        onAddAbove: {},
        onRemoveAbove: {},
        onAddBelow: {},
        onRemoveBelow: {},
        onClearAll: {},
        canRemoveAbove: true,
        canRemoveBelow: true
    )
}
