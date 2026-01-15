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

    @GestureState private var dragState = DragState.inactive
    @State private var cumulativeSteps: Int = 0

    private let rowHeight: CGFloat = 50

    private enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive: return .zero
            case .dragging(let translation): return translation
            }
        }

        var isDragging: Bool {
            switch self {
            case .inactive: return false
            case .dragging: return true
            }
        }
    }

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
        .padding(.vertical, 12)  // タッチ領域拡大
        .background(type.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(type.color, lineWidth: 2)
        )
        .cornerRadius(8)
        .scaleEffect(dragState.isDragging ? 1.02 : 1.0)
        .opacity(dragState.isDragging ? 0.85 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: dragState.isDragging)
        .contentShape(Rectangle())
        .highPriorityGesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .updating($dragState) { value, state, _ in
                    state = .dragging(translation: value.translation)
                }
                .onChanged { value in
                    let totalSteps = Int(round(value.translation.height / rowHeight))
                    let delta = totalSteps - cumulativeSteps

                    if delta != 0 {
                        cumulativeSteps = totalSteps
                        onMove(delta)
                    }
                }
                .onEnded { _ in
                    cumulativeSteps = 0
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
