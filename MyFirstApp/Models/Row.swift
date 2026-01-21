//
//  Row.swift
//  MyFirstApp
//

import Foundation

/// 行の種類
enum RowKind: String, Codable {
    case now  // 現在
    case hit  // 当選履歴
}

/// 当選種別
enum HitType: String, Codable, CaseIterable {
    case rb   // RB（REG相当）
    case bb   // BB（BIG相当）
    case fin  // 終了（加算なし）
}

/// 行データ
struct Row: Identifiable, Codable {
    let id: UUID
    var kind: RowKind
    var label: String
    var gInput: String
    var type: HitType

    init(id: UUID = UUID(), kind: RowKind, label: String, gInput: String = "", type: HitType = .rb) {
        self.id = id
        self.kind = kind
        self.label = label
        self.gInput = gInput
        self.type = type
    }

    /// 初期行を生成（初期状態は空）
    static func initialRows() -> [Row] {
        []
    }

    /// ラベルを生成（インデックスから）
    static func labelForIndex(_ index: Int) -> String {
        switch index {
        case 0: return "現在"
        case 1: return "前回"
        case 2: return "2回前"
        default: return "\(index)回前"
        }
    }
}

// MARK: - パース関数（Web完全互換）

/// G数入力のパース
/// - 空文字 → nil
/// - 非数値 → nil
/// - 0〜1050にクランプ
func parseG(_ value: String) -> Int? {
    let trimmed = value.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return nil }
    guard let num = Double(trimmed) else { return nil }
    let truncated = Int(num)
    return max(0, min(truncated, 1050))
}

/// 設定値のパース（Non-Zero Int）
/// - 空文字 → 0
/// - 非数値 → 0
/// - 負数 → 0
func nzInt(_ value: String) -> Int {
    guard let num = Double(value) else { return 0 }
    let truncated = Int(num)
    return max(0, truncated)
}
