//
//  ContentView.swift
//  MyFirstApp
//
//  v2準拠UI - メインコンテナ
//  レイアウト順序: KPI → 設定 → 行 → 操作 → 機種
//

import SwiftUI

/// メインコンテナ
struct ContentView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showClearConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                    Section(
                        header: KPICardsView(
                            metrics: viewModel.metrics,
                            currentModel: viewModel.currentModel
                        )
                        .background(Color(.systemBackground))
                    ) {
                        VStack(spacing: 12) {
                            SettingsRowView(
                                rbAdd: $viewModel.rbAdd,
                                bbAdd: $viewModel.bbAdd,
                                limitG: $viewModel.limitG,
                                isCustom: viewModel.currentModel == .custom
                            )

                            RowGridView(
                                rows: viewModel.rows,
                                rowCalcs: viewModel.metrics.rowCalcs,
                                limitG: viewModel.metrics.limitG,
                                resetIndex: viewModel.resetIndex,
                                cutIndex: viewModel.cutIndex,
                                showCutBar: false,
                                onGInputChange: { id, value in
                                    viewModel.updateRowG(id: id, value: value)
                                },
                                onTypeChange: { id, type in
                                    viewModel.updateRowType(id: id, type: type)
                                },
                                onResetBarMove: { delta in
                                    viewModel.moveResetBar(by: delta)
                                },
                                onCutBarMove: { _ in },
                                onPrevRowBlur: {
                                    viewModel.handlePrevRowBlur()
                                }
                            )

                            ActionButtonsView(
                                onAddAbove: { viewModel.addRowAbove() },
                                onRemoveAbove: { viewModel.removeRowAbove() },
                                onAddBelow: { viewModel.addRowBelow() },
                                onRemoveBelow: { viewModel.removeRowBelow() },
                                onClearAll: { showClearConfirm = true },
                                canRemoveAbove: viewModel.rows.count > 1,
                                canRemoveBelow: viewModel.rows.count > 1
                            )
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                    }
                }
            }

            // 機種選択タブバー（画面下部固定）
            MachineTabBar(
                selectedModel: Binding(
                    get: { viewModel.currentModel },
                    set: { viewModel.selectModel($0) }
                )
            )
        }
        .alert("すべての入力を削除しますか？（機種・設定は保持）", isPresented: $showClearConfirm) {
            Button("削除", role: .destructive) {
                viewModel.clearAll()
            }
            Button("キャンセル", role: .cancel) {}
        }
        .onTapGesture {
            // キーボードを閉じる
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    ContentView()
}
