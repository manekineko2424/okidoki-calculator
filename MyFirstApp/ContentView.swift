//
//  ContentView.swift
//  MyFirstApp
//
//  分離型UI - メインコンテナ
//  レイアウト: KPI+設定 → 入力 → 履歴テーブル → 機種タブ
//

import SwiftUI

/// メインコンテナ
struct ContentView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showSettings = false
    @State private var showClearConfirm = false
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack(spacing: 0) {
            // 上部: KPI + 設定ボタン（固定）
            headerSection

            // 入力エリア（固定・ScrollViewの外）
            InputAreaView(
                gInput: $viewModel.inputGValue,
                hasCurrentRow: viewModel.hasCurrentRow,
                onRegister: { type in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.registerEntry(type: type)
                    }
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 12)

            // 履歴エリア（スクロール可能、自動スクロール付き）
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        // 履歴テーブル
                        HistoryTableView(
                            entries: viewModel.historyEntries,
                            resetIndices: viewModel.resetIndices,
                            maxResetIndex: viewModel.rows.count,
                            onResetBarMove: { barIndex, delta in
                                viewModel.moveResetBar(at: barIndex, by: delta)
                            }
                        )
                        .padding(.horizontal, 12)

                        // 削除ボタン（2つ: 1つ削除、すべて削除）
                        if !viewModel.rows.isEmpty {
                            HStack(spacing: 10) {
                                // 1つ削除ボタン
                                Button {
                                    withAnimation {
                                        viewModel.deleteOne()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("1つ削除")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                // すべて削除ボタン
                                Button(role: .destructive) {
                                    showClearConfirm = true
                                } label: {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                        Text("すべて削除")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)

                            // リセットバー追加・削除ボタン（横並び）
                            HStack(spacing: 10) {
                                // 追加ボタン
                                Button {
                                    withAnimation {
                                        viewModel.addResetBar()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text("バー追加")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(Color(red: 0.9, green: 0.5, blue: 0.1))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 1.0, green: 0.95, blue: 0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                // 削除ボタン
                                Button {
                                    withAnimation {
                                        viewModel.removeLastResetBar()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "minus.circle")
                                        Text("バー削除")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(viewModel.resetIndices.isEmpty ? .gray : Color(red: 0.9, green: 0.5, blue: 0.1))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.resetIndices.isEmpty ? Color(.systemGray5) : Color(red: 1.0, green: 0.95, blue: 0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .disabled(viewModel.resetIndices.isEmpty)
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 8)

                            Spacer().frame(height: 16)
                                .id("bottomSpacer")
                        }
                    }
                }
                .onChange(of: viewModel.historyEntries.count) { _, _ in
                    if let lastEntry = viewModel.historyEntries.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            scrollProxy.scrollTo(lastEntry.id, anchor: .bottom)
                        }
                    }
                }
            }

            // 下部: 機種選択タブバー（キーボード非表示時のみ表示）
            if !isKeyboardVisible {
                MachineTabBar(
                    selectedModel: Binding(
                        get: { viewModel.currentModel },
                        set: { viewModel.selectModel($0) }
                    )
                )
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                limitG: $viewModel.limitG,
                rbAdd: $viewModel.rbAdd,
                bbAdd: $viewModel.bbAdd,
                isCustom: viewModel.currentModel == .custom,
                onClose: {
                    showSettings = false
                }
            )
            .presentationDetents([.medium])
        }
        .alert("すべての入力を削除しますか？", isPresented: $showClearConfirm) {
            Button("削除", role: .destructive) {
                withAnimation {
                    viewModel.deleteAll()
                }
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("機種・設定は保持されます")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onTapGesture {
            // キーボードを閉じる
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    // ヘッダーセクション（KPI + 設定ボタン）
    private var headerSection: some View {
        VStack(spacing: 8) {
            // タイトル行
            HStack {
                Text("沖ドキ！有利区間ゲーム数計算ツール")
                    .font(.system(size: 15, weight: .bold))

                Spacer()

                // 設定ボタン
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary)
                }
            }

            // KPI表示（コンパクト版）
            HStack(spacing: 12) {
                // 機種名
                Text(viewModel.currentModel.displayName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(viewModel.currentModel.themeColor)
                    .clipShape(Capsule())

                Spacer()

                // 残りG数
                HStack(spacing: 4) {
                    Text("残り")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Text(remainingText)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(remainingColor)

                    Text("G")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private var remainingText: String {
        return "\(viewModel.metrics.normalRemain)"
    }

    private var remainingColor: Color {
        return .primary
    }
}

#Preview {
    ContentView()
}
