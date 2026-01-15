//
//  KPICardsView.swift
//  MyFirstApp
//
//  KPI表示カード - 分離型UI対応
//

import SwiftUI

/// KPI表示カード（上部固定）
struct KPICardsView: View {
    let metrics: ComputedMetrics
    let currentModel: MachineModel

    var body: some View {
        VStack(spacing: 8) {
            Text("沖ドキ有利区間G数計算ツール - \(currentModel.displayName)")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            KPICard(
                label: "有利区間上限G数まで残り",
                value: metrics.normalRemain,
                isOK: metrics.isOKNormal,
                isNeg: metrics.isNegNormal,
                accentColor: currentModel.themeColor
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground).opacity(0.95))
    }
}

/// 個別KPIカード
struct KPICard: View {
    let label: String
    let value: Int?
    let isOK: Bool
    let isNeg: Bool
    let accentColor: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 12.5, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(displayText)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(textColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(badgeBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(badgeBorder, lineWidth: 1)
                )
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 2)
        )
    }

    private var displayText: String {
        if let v = value {
            return "\(v)G"
        }
        return "—"
    }

    private var backgroundColor: Color {
        return Color(.systemGray6)
    }

    private var borderColor: Color {
        return accentColor.opacity(0.6)
    }

    private var badgeBackground: Color {
        return Color.clear
    }

    private var badgeBorder: Color {
        return Color.clear
    }

    private var textColor: Color {
        return .primary
    }
}

#Preview {
    VStack {
        KPICardsView(
            metrics: ComputedMetrics(
                currentTop: 2124,
                upperAtCut: 583,
                normalRemain: -124,
                cutRemain: 1900,
                isOKNormal: true,
                isOKCut: false,
                rowCalcs: [:],
                limitG: 2000
            ),
            currentModel: .black
        )
    }
}
