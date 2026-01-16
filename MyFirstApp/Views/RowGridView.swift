//
//  RowGridView.swift
//  MyFirstApp
//

import SwiftUI

/// メイングリッド（行一覧 + バー表示）
struct RowGridView: View {
    let rows: [Row]
    let rowCalcs: [UUID: RowCalc]
    let limitG: Int
    let resetIndex: Int
    let cutIndex: Int?
    let showCutBar: Bool  // 有料版のみ🔵バー表示
    let onGInputChange: (UUID, String) -> Void
    let onTypeChange: (UUID, HitType) -> Void
    let onResetBarMove: (Int) -> Void
    let onCutBarMove: (Int) -> Void
    let onPrevRowBlur: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            headerRow(widths: columnWidths)

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                VStack(spacing: 0) {
                    // 🔵 切断バー（cutIndex位置に表示、有料版のみ）
                    if showCutBar && cutIndex == index {
                        BarIndicatorView(
                            type: .cut,
                            currentIndex: index,
                            minIndex: 1,              // cutも「現在」より上には移動不可
                            maxIndex: resetIndex - 1,  // cutはreset未満まで
                            onMove: onCutBarMove,
                            onDraggingChange: { isDragging in
                                draggingBarType = isDragging ? .cut : nil
                            }
                        )
                    }

                    // 🟡 リセットバー（resetIndex位置に表示）
                    if resetIndex == index {
                        BarIndicatorView(
                            type: .reset,
                            currentIndex: index,
                            minIndex: 1,              // 「現在」より上には移動不可
                            maxIndex: rows.count,
                            onMove: onResetBarMove,
                            onDraggingChange: { isDragging in
                                draggingBarType = isDragging ? .reset : nil
                            }
                        )
                    }

                    RowItemView(
                        row: row,
                        calc: rowCalcs[row.id],
                        limitG: limitG,
                        isAboveReset: index < resetIndex,
                        widths: columnWidths,
                        focusedRowId: $focusedRowId,
                        gInput: Binding(
                            get: { row.gInput },
                            set: { onGInputChange(row.id, $0) }
                        ),
                        onTypeChange: { onTypeChange(row.id, $0) }
                    )
                }
                // ドラッグ中のバーを含む行を最前面に
                .zIndex(draggingBarAtIndex(index) ? 100 : 0)
            }

            // 最後の位置にもバーが来る可能性
            if resetIndex == rows.count {
                BarIndicatorView(
                    type: .reset,
                    currentIndex: rows.count,
                    minIndex: 1,              // 「現在」より上には移動不可
                    maxIndex: rows.count,
                    onMove: onResetBarMove,
                    onDraggingChange: { isDragging in
                        draggingBarType = isDragging ? .reset : nil
                    }
                )
            }
        }
        .background(WidthReader(width: $availableWidth))
        .onChange(of: focusedRowId) { newValue in
            if let lastFocusedRowId, lastFocusedRowId == prevRowId, newValue != lastFocusedRowId {
                onPrevRowBlur()
            }
            lastFocusedRowId = newValue
        }
    }

    @State private var availableWidth: CGFloat = 0
    @State private var lastFocusedRowId: UUID? = nil
    @State private var draggingBarType: BarType? = nil
    @FocusState private var focusedRowId: UUID?

    private var prevRowId: UUID? {
        rows.count > 1 ? rows[1].id : nil
    }

    /// 指定インデックスにドラッグ中のバーがあるか
    private func draggingBarAtIndex(_ index: Int) -> Bool {
        if draggingBarType == .reset && resetIndex == index {
            return true
        }
        if draggingBarType == .cut && cutIndex == index {
            return true
        }
        return false
    }

    private var columnWidths: ColumnWidths {
        ColumnWidths.forWidth(availableWidth)
    }

    private func headerRow(widths: ColumnWidths) -> some View {
        HStack(spacing: 0) {
            headerCell("履歴", width: widths.col1)
            headerCell("当選G数", width: widths.col2)
            headerCell("種別", width: widths.col3)
            headerCell("当選時 → 終了時", width: widths.col4)
        }
    }

    private func headerCell(_ title: String, width: CGFloat) -> some View {
        Text(title)
            .font(.system(size: 12.5, weight: .semibold))
            .frame(width: width)
            .frame(minHeight: 32)
            .background(Color(.systemGray6))
            .overlay(
                Rectangle()
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )
    }
}

private struct WidthReader: View {
    @Binding var width: CGFloat

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear { width = proxy.size.width }
                .onChange(of: proxy.size.width) { width = $0 }
        }
    }
}


#Preview {
    let rows = [
        Row(kind: .now, label: "現在", gInput: "100"),
        Row(kind: .hit, label: "前回", gInput: "200", type: .rb),
        Row(kind: .hit, label: "2回前", gInput: "300", type: .bb),
    ]

    return RowGridView(
        rows: rows,
        rowCalcs: [:],
        limitG: 2000,
        resetIndex: 1,
        cutIndex: nil,
        showCutBar: false,
        onGInputChange: { _, _ in },
        onTypeChange: { _, _ in },
        onResetBarMove: { _ in },
        onCutBarMove: { _ in },
        onPrevRowBlur: {}
    )
}
