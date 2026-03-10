//
//  HistoryTableView.swift
//  MyFirstApp
//
//  履歴出力テーブル（リセットバーを行間に配置）
//

import SwiftUI

/// 履歴出力テーブル
struct HistoryTableView: View {
    let entries: [HistoryEntry]
    let resetIndices: [Int]  // 複数リセットバー位置
    let maxResetIndex: Int
    let onResetBarMove: (Int, Int) -> Void  // (barIndex, delta)

    // 「現在」行が存在するか
    private var hasCurrentRow: Bool {
        entries.contains { $0.isCurrentRow }
    }

    // リセットバーの最小位置（現在行がある場合は1、ない場合は0）
    private var minResetIndex: Int {
        hasCurrentRow ? 1 : 0
    }

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HistoryHeaderView()
                .id("historyHeader")
                .background(Color(.systemGray5))

            if entries.isEmpty {
                // 空状態 - モード別の詳細説明
                emptyStateView
            } else {
                // 履歴リスト（リセットバーを行間に配置）
                VStack(spacing: 0) {
                    ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                        // 行を表示（自動スクロール用にIDを付与）
                        HistoryRowView(entry: entry)
                            .id(entry.id)

                        // この位置にあるリセットバーを全て表示
                        ForEach(Array(resetIndices.enumerated()), id: \.offset) { barIndex, resetPos in
                            if resetPos == index + 1 && index + 1 < entries.count {
                                BarIndicatorView(
                                    type: .reset,
                                    currentIndex: resetPos,
                                    minIndex: minResetIndex,
                                    maxIndex: maxResetIndex,
                                    onMove: { delta in
                                        onResetBarMove(barIndex, delta)
                                    }
                                )
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                            }
                        }

                        // 最後の行でなければ区切り線（リセットバーが表示される位置には入れない）
                        let hasBarAtThisPosition = resetIndices.contains(index + 1) && index + 1 < entries.count
                        if index < entries.count - 1 && !hasBarAtThisPosition {
                            Divider()
                                .padding(.horizontal, 12)
                        }
                    }

                    // 最後の行の後（resetPos == entries.count）- 最下部の場合
                    ForEach(Array(resetIndices.enumerated()), id: \.offset) { barIndex, resetPos in
                        if resetPos == entries.count {
                            BarIndicatorView(
                                type: .reset,
                                currentIndex: resetPos,
                                minIndex: minResetIndex,
                                maxIndex: maxResetIndex,
                                onMove: { delta in
                                    onResetBarMove(barIndex, delta)
                                }
                            )
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
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
    }

    /// 空状態の表示
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("履歴がありません")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                // モード切り替え説明
                VStack(alignment: .leading, spacing: 4) {
                    Text("モード切り替え")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    bulletItem("入力欄右端のボタンでモード切替")
                }

                Divider()

                // 履歴入力モード説明
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: InputMode.history.iconNameFill)
                            .font(.caption)
                            .foregroundColor(InputMode.history.color)
                        Text("履歴入力モード")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(InputMode.history.color)
                    }
                    bulletItem("新しい履歴は下に追加")
                    bulletItem("最新から順に登録")
                }

                Divider()

                // 実戦入力モード説明
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: InputMode.realtime.iconNameFill)
                            .font(.caption)
                            .foregroundColor(InputMode.realtime.color)
                        Text("実戦入力モード")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(InputMode.realtime.color)
                    }
                    bulletItem("新しい履歴は上に追加")
                    bulletItem("現在Gの編集可能")
                }

                Divider()

                // おすすめの使い方
                VStack(alignment: .leading, spacing: 4) {
                    Text("おすすめの使い方")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    bulletItem("台の途中から：履歴→実戦に切替")
                    bulletItem("朝一から：最初から実戦モード")
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    /// 箇条書きアイテム
    private func bulletItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Text(text)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

}

#Preview("データあり") {
    VStack {
        HistoryTableView(
            entries: [
                HistoryEntry(
                    id: UUID(),
                    index: 0,
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
            resetIndices: [2],
            maxResetIndex: 3,
            onResetBarMove: { _, _ in }
        )
        .padding()
    }
}

#Preview("空状態") {
    VStack {
        HistoryTableView(
            entries: [],
            resetIndices: [],
            maxResetIndex: 0,
            onResetBarMove: { _, _ in }
        )
        .padding()
    }
}
