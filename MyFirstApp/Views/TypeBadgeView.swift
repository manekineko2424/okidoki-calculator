//
//  TypeBadgeView.swift
//  MyFirstApp
//
//  種別バッジ表示
//

import SwiftUI

/// 種別バッジ
struct TypeBadgeView: View {
    let type: HitType?  // nilは「現在」

    var body: some View {
        Text(displayText)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var displayText: String {
        guard let type = type else { return "現在" }
        switch type {
        case .rb: return "RB"
        case .bb: return "BB"
        case .fin: return "最終"
        }
    }

    private var backgroundColor: Color {
        guard let type = type else { return .gray }
        switch type {
        case .rb: return .blue
        case .bb: return .red
        case .fin: return .primary
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        TypeBadgeView(type: nil)
        TypeBadgeView(type: .rb)
        TypeBadgeView(type: .bb)
        TypeBadgeView(type: .fin)
    }
    .padding()
}
