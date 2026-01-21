//
//  HistoryRowView.swift
//  MyFirstApp
//
//  履歴テーブルの1行表示（シンプル版 - 表示のみ）
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

/// 履歴テーブルの1行（表示のみ）
struct HistoryRowView: View {
    let entry: HistoryEntry

    var body: some View {
        HStack(spacing: 0) {
            // 履歴列
            Text(indexLabel)
                .font(.system(size: 14))
                .frame(width: 60, alignment: .center)

            // 当選G数列
            Text("\(entry.gValue)G")
                .font(.system(size: 14))
                .frame(width: 70, alignment: .center)

            // 種別列
            TypeBadgeView(type: entry.type)
                .frame(width: 60, alignment: .center)

            // 当選時→終了時列
            Text(entry.calcResult)
                .font(.system(size: 13))
                .foregroundStyle(.primary)  // グレーから通常色に変更
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
    }

    private var indexLabel: String {
        if entry.isCurrentRow {
            return "現在"
        }
        if entry.index == 1 {
            return "前回"
        }
        return "\(entry.index)回前"
    }
}

/// 履歴テーブルのヘッダー行
struct HistoryHeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("履歴")
                .frame(width: 60, alignment: .center)

            Text("当選G数")
                .frame(width: 70, alignment: .center)

            Text("種別")
                .frame(width: 60, alignment: .center)

            Text("当選時→終了時")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .font(.caption)
        .foregroundStyle(.primary)  // 文字色を通常色に
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))  // より明るい背景色に
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
            )
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
            )
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
            )
        )
    }
}
