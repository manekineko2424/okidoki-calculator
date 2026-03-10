//
//  InputMode.swift
//  MyFirstApp
//
//  入力モード定義
//

import Foundation
import SwiftUI

/// 入力モード
enum InputMode: String, CaseIterable {
    /// 履歴入力モード - 末尾に追加、BB/RB/最終が有効
    case history
    /// 実戦中モード - 現在の直下に挿入、現在/BB/RBが有効
    case realtime

    /// 表示名
    var displayName: String {
        switch self {
        case .history: return "履歴"
        case .realtime: return "実戦"
        }
    }

    /// SF Symbolsアイコン名
    var iconName: String {
        switch self {
        case .history: return "arrow.down.circle"
        case .realtime: return "arrow.up.circle"
        }
    }

    /// 塗りつぶしアイコン名
    var iconNameFill: String {
        switch self {
        case .history: return "arrow.down.circle.fill"
        case .realtime: return "arrow.up.circle.fill"
        }
    }

    /// モードを切り替え
    var toggled: InputMode {
        switch self {
        case .history: return .realtime
        case .realtime: return .history
        }
    }

    /// モード別カラー
    var color: Color {
        switch self {
        case .history: return Color(red: 0.2, green: 0.45, blue: 0.9)    // 青系
        case .realtime: return Color(red: 0.95, green: 0.55, blue: 0.1) // オレンジ系
        }
    }
}
