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
        case .reset: return Color(red: 0.9, green: 0.5, blue: 0.1)  // 濃いオレンジ
        case .cut: return .blue
        }
    }

    var backgroundColor: Color {
        switch self {
        case .reset: return Color(red: 1.0, green: 0.95, blue: 0.9)  // 薄いオレンジ
        case .cut: return Color(red: 0.9, green: 0.95, blue: 1.0)
        }
    }
}

/// バーインジケーター（ドラッグで移動可能）
struct BarIndicatorView: View {
    let type: BarType
    let onMove: (Int) -> Void

    @GestureState private var dragOffset: CGFloat = 0

    private let rowHeight: CGFloat = 50

    var body: some View {
        HStack(spacing: 10) {
            // 左側ドラッグハンドル
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(type.color)

            Text(type.label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(type.color)

            Spacer()

            // 右側ドラッグハンドル
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(type.color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(type.color, lineWidth: 2)
        )
        .cornerRadius(8)
        .offset(y: dragOffset)  // ドラッグ中の視覚的移動
        .scaleEffect(dragOffset != 0 ? 1.03 : 1.0)
        .opacity(dragOffset != 0 ? 0.9 : 1.0)
        .shadow(color: dragOffset != 0 ? .black.opacity(0.2) : .clear, radius: 4, y: 2)
        .animation(.interactiveSpring(), value: dragOffset)
        .zIndex(dragOffset != 0 ? 100 : 0)  // ドラッグ中は最前面に
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 5)
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let steps = Int(round(value.translation.height / rowHeight))
                    if steps != 0 {
                        onMove(steps)
                    }
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
