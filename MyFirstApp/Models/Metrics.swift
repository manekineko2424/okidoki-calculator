//
//  Metrics.swift
//  MyFirstApp
//

import Foundation

/// 行ごとの計算結果
struct RowCalc {
    var hit: Int?      // 当選時の累計G（hit行のみ）
    var end: Int?      // 終了時の累計G（hit行のみ）
    var current: Int?  // 現在の累計G（now行のみ）

    /// 表示用文字列
    var displayText: String? {
        if let hit = hit, let end = end {
            return "\(hit)→\(end)"
        } else if let current = current {
            return "\(current)"
        }
        return nil
    }
}

/// 計算結果（compute関数の出力）
struct ComputedMetrics {
    let currentTop: Int         // 現在の累計G
    let upperAtCut: Int         // 切断位置以降の累計G
    let normalRemain: Int       // 🟡 通常残りG
    let cutRemain: Int?         // 🔵 切断想定残りG（nil可）
    let isOKNormal: Bool        // 🟡 OK判定
    let isOKCut: Bool           // 🔵 OK判定
    let rowCalcs: [UUID: RowCalc]  // 行ごとの計算結果
    let limitG: Int             // 天井G（表示用）

    /// 🟡 残りGがマイナスか
    var isNegNormal: Bool {
        normalRemain < 0
    }

    /// 🔵 残りGがマイナスか
    var isNegCut: Bool {
        guard let remain = cutRemain else { return false }
        return remain < 0
    }
}
