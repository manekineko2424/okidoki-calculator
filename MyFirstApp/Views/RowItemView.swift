//
//  RowItemView.swift
//  MyFirstApp
//

import SwiftUI

/// 1行表示
struct RowItemView: View {
    let row: Row
    let calc: RowCalc?
    let limitG: Int
    let isAboveReset: Bool  // リセットバーより上か
    let widths: ColumnWidths
    let focusedRowId: FocusState<UUID?>.Binding
    @Binding var gInput: String
    let onTypeChange: (HitType) -> Void

    var body: some View {
        HStack(spacing: 0) {
            cell {
                Text(row.label)
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(labelColor)
            }
            .frame(width: widths.col1)

            cell {
                TextField("", text: $gInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .focused(focusedRowId, equals: row.id)
            }
            .frame(width: widths.col2)

            cell {
                if row.kind == .hit {
                    HStack(spacing: 4) {
                        typeButton(.rb, title: "RB", activeColor: Color(red: 0.88, green: 0.95, blue: 1.0), border: Color(red: 0.58, green: 0.77, blue: 1.0), textColor: Color(red: 0.02, green: 0.41, blue: 0.63))
                        typeButton(.bb, title: "BB", activeColor: Color(red: 1.0, green: 0.89, blue: 0.89), border: Color(red: 0.99, green: 0.79, blue: 0.79), textColor: Color(red: 0.73, green: 0.11, blue: 0.11))
                        typeButton(.fin, title: "最終", activeColor: Color(red: 0.95, green: 0.95, blue: 0.95), border: Color(red: 0.82, green: 0.82, blue: 0.82), textColor: Color(red: 0.26, green: 0.29, blue: 0.33))
                    }
                } else {
                    Text("—")
                        .font(.system(size: 12.5))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: widths.col3)

            cell {
                Text(displayCalc)
                    .font(.system(size: 12.5))
                    .foregroundStyle(calcColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: widths.col4)
        }
        .background(backgroundColor)
    }

    private var labelColor: Color {
        row.kind == .now ? .primary : .secondary
    }

    private var displayCalc: String {
        if row.kind == .now {
            if let current = calc?.current {
                return "\(current)G"
            }
            return "（未入力）"
        }

        if let hit = calc?.hit, let end = calc?.end {
            return "\(hit)G → \(end)G"
        }
        return "（未入力）"
    }

    /// 終了時G ≥ 天井G → グレー表示
    private var isOverLimit: Bool {
        guard let end = calc?.end else { return false }
        return end >= limitG
    }

    private var calcColor: Color {
        if calc == nil {
            return .secondary
        }
        return isOverLimit ? .secondary : .primary
    }

    private var backgroundColor: Color {
        if isOverLimit {
            return Color(.systemGray5)
        }
        return Color.white
    }

    private func cell<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(minHeight: 38)
            .frame(maxWidth: .infinity)
            .padding(6)
            .background(backgroundColor)
            .overlay(
                Rectangle()
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )
    }

    private func typeButton(
        _ type: HitType,
        title: String,
        activeColor: Color,
        border: Color,
        textColor: Color
    ) -> some View {
        let isActive = row.type == type
        return Button(action: {
            onTypeChange(type)
        }) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .frame(maxWidth: .infinity, minHeight: 32)
                .foregroundStyle(isActive ? textColor : Color(.systemGray))
                .background(isActive ? activeColor : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isActive ? border : Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RowItemPreviewContainer()
}

private struct RowItemPreviewContainer: View {
    @FocusState private var focusedRowId: UUID?

    var body: some View {
        VStack {
            RowItemView(
                row: Row(kind: .now, label: "現在"),
                calc: RowCalc(hit: nil, end: nil, current: 683),
                limitG: 2000,
                isAboveReset: true,
                widths: ColumnWidths.forWidth(360),
                focusedRowId: $focusedRowId,
                gInput: .constant("100"),
                onTypeChange: { _ in }
            )

            RowItemView(
                row: Row(kind: .hit, label: "前回"),
                calc: RowCalc(hit: 559, end: 583, current: nil),
                limitG: 2000,
                isAboveReset: true,
                widths: ColumnWidths.forWidth(360),
                focusedRowId: $focusedRowId,
                gInput: .constant("200"),
                onTypeChange: { _ in }
            )

            RowItemView(
                row: Row(kind: .hit, label: "2回前"),
                calc: RowCalc(hit: 2100, end: 2124, current: nil),
                limitG: 2000,
                isAboveReset: true,
                widths: ColumnWidths.forWidth(360),
                focusedRowId: $focusedRowId,
                gInput: .constant("2100"),
                onTypeChange: { _ in }
            )
        }
    }
}
