//
//  HistoryTableView.swift
//  MyFirstApp
//
//  履歴出力テーブル
//

import SwiftUI

/// 履歴出力テーブル
struct HistoryTableView: View {
    let entries: [HistoryEntry]
    let showResetBar: Bool
    let onRowTap: (UUID) -> Void
    let onRemoveResetBar: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HistoryHeaderView()

            if entries.isEmpty {
                // 空状態
                VStack(spacing: 8) {
                    Text("履歴がありません")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("ゲーム数を入力して種別を選択してください")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // 履歴リスト
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(entries) { entry in
                            VStack(spacing: 0) {
                                HistoryRowView(entry: entry) {
                                    onRowTap(entry.id)
                                }

                                if entry.id != entries.last?.id {
                                    Divider()
                                }
                            }
                        }

                        // リセットバー（最下部）
                        if showResetBar {
                            ResetBarView(onRemove: onRemoveResetBar)
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

/// リセットバー（簡略版）
struct ResetBarView: View {
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Text("🟡")
            Text("ここで有利区間リセット")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.orange)

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.orange.opacity(0.1))
        .overlay(
            Rectangle()
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack {
        HistoryTableView(
            entries: [
                HistoryEntry(
                    id: UUID(),
                    index: 1,
                    gValue: 100,
                    type: nil,
                    calcResult: "100",
                    isCurrentRow: true
                ),
                HistoryEntry(
                    id: UUID(),
                    index: 1,
                    gValue: 11,
                    type: .bb,
                    calcResult: "11G → 80G",
                    isCurrentRow: false
                ),
                HistoryEntry(
                    id: UUID(),
                    index: 2,
                    gValue: 55,
                    type: .rb,
                    calcResult: "135G → 164G",
                    isCurrentRow: false
                )
            ],
            showResetBar: true,
            onRowTap: { _ in },
            onRemoveResetBar: {}
        )

        HistoryTableView(
            entries: [],
            showResetBar: false,
            onRowTap: { _ in },
            onRemoveResetBar: {}
        )
    }
}
