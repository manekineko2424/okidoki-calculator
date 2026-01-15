//
//  BarIndicatorView.swift
//  MyFirstApp
//

import SwiftUI

/// バー種別
enum BarType {
    case reset  // 🟡 リセットバー
    case cut    // 🔵 切断バー

    var label: String {
        switch self {
        case .reset: return "有利区間リセット"
        case .cut: return "切断位置"
        }
    }

    var color: Color {
        switch self {
        case .reset: return Color(red: 0.95, green: 0.75, blue: 0.1)  // ゴールド系
        case .cut: return .blue
        }
    }

    var backgroundColor: Color {
        switch self {
        case .reset: return Color(red: 1.0, green: 0.97, blue: 0.84)  // 薄いクリーム色
        case .cut: return Color(red: 0.9, green: 0.95, blue: 1.0)
        }
    }
}

/// バーインジケーター（ドラッグで移動可能）
struct BarIndicatorView: View {
    let type: BarType
    let onMove: (Int) -> Void

    @State private var isDragging: Bool = false
    @State private var lastMovedSteps: Int = 0  // 前回移動したステップ数

    private let rowHeight: CGFloat = 50  // 1行の高さ

    var body: some View {
        HStack(spacing: 8) {
            // ドラッグハンドル
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(type.color)

            Text(type.label)
                .font(.system(size: 12.5, weight: .semibold))
                .foregroundStyle(type.color)

            Spacer()

            Text("ドラッグで移動")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(type.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(type.color, lineWidth: 1.5)
        )
        .cornerRadius(6)
        .scaleEffect(isDragging ? 1.02 : 1.0)
        .opacity(isDragging ? 0.9 : 1.0)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 5)
                .onChanged { value in
                    isDragging = true

                    // ドラッグ開始位置からの累積移動量を計算
                    let totalSteps = Int(value.translation.height / rowHeight)

                    // 前回から変化があった場合のみ移動
                    let delta = totalSteps - lastMovedSteps
                    if delta != 0 {
                        onMove(delta)
                        lastMovedSteps = totalSteps
                    }
                }
                .onEnded { _ in
                    lastMovedSteps = 0
                    isDragging = false
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        BarIndicatorView(type: .reset) { delta in
            print("Reset bar moved by \(delta)")
        }

        BarIndicatorView(type: .cut) { delta in
            print("Cut bar moved by \(delta)")
        }
    }
    .padding()
}
