//
//  HistoryRowView.swift
//  MyFirstApp
//
//  履歴テーブルの1行表示
//

import SwiftUI

/// 履歴データ（表示用）
struct HistoryEntry: Identifiable {
    let id: UUID
    let index: Int          // 1回目, 2回目...
    let gValue: Int
    let type: HitType?      // nilは「現在」
    let calcResult: String  // "11G → 80G" or "100" (現在行)
    let isCurrentRow: Bool  // 現在行かどうか
}

/// 履歴テーブルの1行
struct HistoryRowView: View {
    let entry: HistoryEntry
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // 履歴列
                Text(indexLabel)
                    .font(.system(size: 14))
                    .frame(width: 60, alignment: .leading)

                // 当選G数列
                Text("\(entry.gValue)G")
                    .font(.system(size: 14))
                    .frame(width: 70, alignment: .trailing)

                // 種別列
                TypeBadgeView(type: entry.type)
                    .frame(width: 60)

                // 当選時→終了時列
                Text(entry.calcResult)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(entry.isCurrentRow ? Color(.systemGray6) : Color(.systemBackground))
        }
        .buttonStyle(.plain)
    }

    private var indexLabel: String {
        if entry.isCurrentRow {
            return "現在"
        }
        return "\(entry.index)回目"
    }
}

/// 履歴テーブルのヘッダー行
struct HistoryHeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("履歴")
                .frame(width: 60, alignment: .leading)

            Text("当選G数")
                .frame(width: 70, alignment: .trailing)

            Text("種別")
                .frame(width: 60)

            Text("当選時→終了時")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray5))
    }
}

#Preview {
    VStack(spacing: 0) {
        HistoryHeaderView()

        HistoryRowView(
            entry: HistoryEntry(
                id: UUID(),
                index: 1,
                gValue: 100,
                type: nil,
                calcResult: "100",
                isCurrentRow: true
            ),
            onTap: {}
        )

        Divider()

        HistoryRowView(
            entry: HistoryEntry(
                id: UUID(),
                index: 1,
                gValue: 11,
                type: .bb,
                calcResult: "11G → 80G",
                isCurrentRow: false
            ),
            onTap: {}
        )

        Divider()

        HistoryRowView(
            entry: HistoryEntry(
                id: UUID(),
                index: 2,
                gValue: 55,
                type: .rb,
                calcResult: "135G → 164G",
                isCurrentRow: false
            ),
            onTap: {}
        )
    }
}
