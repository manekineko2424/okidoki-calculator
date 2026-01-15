//
//  MachineModel.swift
//  MyFirstApp
//

import Foundation

/// 機種プリセット
enum MachineModel: String, Codable, CaseIterable, Hashable {
    case black
    case gold
    case gorgeous
    case custom

    /// 表示名（タブ用）
    var displayName: String {
        switch self {
        case .black: return "ブラック"
        case .gold: return "ゴールド"
        case .gorgeous: return "ゴージャス"
        case .custom: return "カスタム"
        }
    }

    /// フル表示名（ヘッダー用）
    var fullDisplayName: String {
        switch self {
        case .black: return "沖ドキブラック"
        case .gold: return "沖ドキゴールド"
        case .gorgeous: return "沖ドキゴージャス"
        case .custom: return "カスタム"
        }
    }

    /// プリセット設定
    var preset: MachinePreset {
        switch self {
        case .black:
            return MachinePreset(rbAdd: "24", bbAdd: "59", limitG: "2000")
        case .gold:
            return MachinePreset(rbAdd: "29", bbAdd: "69", limitG: "2000")
        case .gorgeous:
            return MachinePreset(rbAdd: "24", bbAdd: "59", limitG: "3000")
        case .custom:
            return MachinePreset(rbAdd: "24", bbAdd: "59", limitG: "2000")
        }
    }
}

/// 機種プリセット値
struct MachinePreset {
    let rbAdd: String
    let bbAdd: String
    let limitG: String
}
