//
//  CalculatorViewModel.swift
//  MyFirstApp
//

import SwiftUI

/// メインViewModel
@Observable
class CalculatorViewModel {
    // MARK: - State

    var appState: AppState
    var metrics: ComputedMetrics

    // MARK: - 入力エリア状態（分離型UI用）

    var inputGValue: String = ""        // 入力中のゲーム数
    var editingRowId: UUID? = nil       // 編集中の行ID（nilなら新規入力モード）
    var showResetBar: Bool = false      // リセットバー表示フラグ

    // MARK: - Computed Properties

    var currentModel: MachineModel {
        get { appState.currentModel }
        set {
            appState.currentModel = newValue
            if newValue != .custom {
                applyPresetForCurrentModel()
            } else {
                recalculate()
                save()
            }
        }
    }

    var currentState: MachineState {
        get { appState.currentState }
        set {
            appState.currentState = newValue
            recalculate()
            save()
        }
    }

    var rows: [Row] {
        get { currentState.rows }
        set {
            var state = currentState
            state.rows = newValue
            currentState = state
        }
    }

    var resetIndex: Int {
        get { currentState.resetIndex }
        set {
            var state = currentState
            state.resetIndex = max(0, min(newValue, state.rows.count))
            // cutIndexがresetIndexを超えないように調整
            if let cut = state.cutIndex, cut >= state.resetIndex {
                state.cutIndex = nil
            }
            currentState = state
        }
    }

    var cutIndex: Int? {
        get { currentState.cutIndex }
        set {
            var state = currentState
            state.cutIndex = newValue
            currentState = state
        }
    }

    var rbAdd: String {
        get { currentState.rbAdd }
        set {
            var state = currentState
            state.rbAdd = newValue
            currentState = state
        }
    }

    var bbAdd: String {
        get { currentState.bbAdd }
        set {
            var state = currentState
            state.bbAdd = newValue
            currentState = state
        }
    }

    var limitG: String {
        get { currentState.limitG }
        set {
            var state = currentState
            state.limitG = newValue
            currentState = state
        }
    }

    // MARK: - Initialization

    init() {
        let initialState: AppState
        if let saved = PersistenceManager.load() {
            initialState = saved
        } else {
            initialState = AppState.initial()
        }
        self.appState = initialState
        self.metrics = Calculator.compute(state: initialState.currentState)
    }

    // MARK: - Actions

    /// 機種を選択
    func selectModel(_ model: MachineModel) {
        currentModel = model
    }

    /// プリセットを適用
    func applyPreset() {
        applyPresetForCurrentModel()
    }

    /// 行のG数を更新
    func updateRowG(id: UUID, value: String) {
        guard let index = rows.firstIndex(where: { $0.id == id }) else { return }
        var updatedRows = rows
        updatedRows[index].gInput = value
        rows = updatedRows
    }

    /// 行の種別を更新
    func updateRowType(id: UUID, type: HitType) {
        guard let index = rows.firstIndex(where: { $0.id == id }) else { return }
        var updatedRows = rows
        updatedRows[index].type = type
        rows = updatedRows
    }

    /// 上に行を追加
    func addRowAbove() {
        var updatedRows = rows
        let newRow = Row(kind: .hit, label: "")
        updatedRows.insert(newRow, at: 1)
        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        state.resetIndex += 1
        if let cut = state.cutIndex {
            state.cutIndex = cut + 1
        }
        currentState = state
    }

    /// 上の行を削除
    func removeRowAbove() {
        guard rows.count > 1 else { return }
        var updatedRows = rows
        updatedRows.remove(at: 1)
        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        state.resetIndex = max(0, state.resetIndex - 1)
        if let cut = state.cutIndex {
            state.cutIndex = cut > 1 ? cut - 1 : nil
        }
        currentState = state
    }

    /// 下に行を追加
    func addRowBelow() {
        var updatedRows = rows
        let newRow = Row(kind: .hit, label: "")
        updatedRows.append(newRow)
        updateLabels(&updatedRows)
        rows = updatedRows
    }

    /// 下の行を削除
    func removeRowBelow() {
        guard rows.count > 1 else { return }
        var updatedRows = rows
        updatedRows.removeLast()

        var state = currentState
        state.rows = updatedRows
        state.resetIndex = min(state.resetIndex, updatedRows.count)
        if let cut = state.cutIndex, cut >= updatedRows.count {
            state.cutIndex = nil
        }
        currentState = state
    }

    /// すべて削除
    func clearAll() {
        var state = currentState
        state.rows = Row.initialRows()
        state.resetIndex = state.rows.count
        state.cutIndex = nil
        currentState = state
    }

    /// リセットバーを移動
    func moveResetBar(by delta: Int) {
        resetIndex = resetIndex + delta
    }

    /// 切断バーを移動
    func moveCutBar(by delta: Int) {
        if let current = cutIndex {
            let newIndex = current + delta
            if newIndex >= 0 && newIndex < resetIndex {
                cutIndex = newIndex
            } else if newIndex < 0 {
                cutIndex = nil
            }
        } else {
            // 初回は resetIndex - 1 に配置
            if resetIndex > 0 {
                cutIndex = resetIndex - 1
            }
        }
    }

    /// 「前回」入力のblur相当で自動行追加
    func handlePrevRowBlur() {
        guard rows.count > 1 else { return }
        let prevRow = rows[1]
        guard parseG(prevRow.gInput) != nil else { return }

        let hasNow = parseG(rows[0].gInput) != nil
        let hasAnyBelow = rows.dropFirst(2).contains { parseG($0.gInput) != nil }

        if hasAnyBelow || !hasNow {
            addRowAbove()
            clearNowInput()
        }
    }

    // MARK: - 分離型UI用プロパティ

    /// 初回入力かどうか（履歴が空）
    var isFirstEntry: Bool {
        rows.isEmpty
    }

    /// 編集モードかどうか
    var isEditMode: Bool {
        editingRowId != nil
    }

    /// 履歴エントリ一覧（表示用）
    var historyEntries: [HistoryEntry] {
        var entries: [HistoryEntry] = []
        var hitIndex = 0

        for row in rows {
            let calc = metrics.rowCalcs[row.id]
            let isCurrentRow = row.kind == .now

            let calcResult: String
            if isCurrentRow {
                if let current = calc?.current {
                    calcResult = "\(current)"
                } else {
                    calcResult = ""
                }
            } else {
                if let hit = calc?.hit, let end = calc?.end {
                    calcResult = "\(hit)G → \(end)G"
                } else {
                    calcResult = ""
                }
            }

            let gValue = parseG(row.gInput) ?? 0

            if isCurrentRow {
                entries.append(HistoryEntry(
                    id: row.id,
                    index: 0,
                    gValue: gValue,
                    type: nil,  // 「現在」行
                    calcResult: calcResult,
                    isCurrentRow: true
                ))
            } else {
                hitIndex += 1
                entries.append(HistoryEntry(
                    id: row.id,
                    index: hitIndex,
                    gValue: gValue,
                    type: row.type,
                    calcResult: calcResult,
                    isCurrentRow: false
                ))
            }
        }

        return entries
    }

    // MARK: - 分離型UI用アクション

    /// 種別ボタン押下で登録
    func registerEntry(type: HitType?) {
        guard let gValue = parseG(inputGValue), gValue > 0 else { return }

        if let editingId = editingRowId {
            // 編集モード: 既存行を更新
            updateRow(id: editingId, gInput: inputGValue, type: type)
            cancelEdit()
        } else {
            // 新規登録
            addNewEntry(gValue: inputGValue, type: type)
        }
    }

    /// 新規エントリ追加
    private func addNewEntry(gValue: String, type: HitType?) {
        var updatedRows = rows

        if type == nil {
            // 「現在」行を追加（初回のみ）
            let newRow = Row(kind: .now, label: "現在", gInput: gValue)
            updatedRows.insert(newRow, at: 0)
        } else {
            // hit行を追加
            let newRow = Row(kind: .hit, label: "", gInput: gValue, type: type!)
            if updatedRows.isEmpty {
                updatedRows.append(newRow)
            } else {
                // 現在行の次に挿入
                updatedRows.insert(newRow, at: 1)
            }
        }

        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        // リセットインデックス調整
        if type != nil && state.resetIndex > 0 {
            state.resetIndex += 1
        }
        currentState = state

        // 入力クリア
        inputGValue = ""
    }

    /// 行を更新
    private func updateRow(id: UUID, gInput: String, type: HitType?) {
        guard let index = rows.firstIndex(where: { $0.id == id }) else { return }
        var updatedRows = rows
        updatedRows[index].gInput = gInput
        if let type = type {
            updatedRows[index].type = type
        }
        rows = updatedRows
    }

    /// 行タップで編集モード開始
    func startEdit(rowId: UUID) {
        guard let row = rows.first(where: { $0.id == rowId }) else { return }
        editingRowId = rowId
        inputGValue = row.gInput
    }

    /// 編集キャンセル
    func cancelEdit() {
        editingRowId = nil
        inputGValue = ""
    }

    /// 1つ削除（最新の履歴を削除）
    func deleteOne() {
        guard !rows.isEmpty else { return }

        var updatedRows = rows
        // 現在行があれば現在行を削除、なければ最初のhit行を削除
        if let nowIndex = updatedRows.firstIndex(where: { $0.kind == .now }) {
            updatedRows.remove(at: nowIndex)
        } else if updatedRows.count > 0 {
            updatedRows.remove(at: 0)
        }

        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        state.resetIndex = max(0, min(state.resetIndex - 1, updatedRows.count))
        currentState = state

        cancelEdit()
    }

    /// 全削除
    func deleteAll() {
        var state = currentState
        state.rows = []
        state.resetIndex = 0
        state.cutIndex = nil
        currentState = state
        showResetBar = false
        cancelEdit()
    }

    /// リセットバーを追加（最下部）
    func addResetBar() {
        showResetBar = true
        // リセットインデックスを最後に設定
        var state = currentState
        state.resetIndex = state.rows.count
        currentState = state
    }

    /// リセットバーを削除
    func removeResetBar() {
        showResetBar = false
    }

    // MARK: - Private Methods

    private func recalculate() {
        metrics = Calculator.compute(state: currentState)
    }

    private func save() {
        PersistenceManager.save(appState)
    }

    private func applyPresetForCurrentModel() {
        let preset = currentModel.preset
        var state = currentState
        state.rbAdd = preset.rbAdd
        state.bbAdd = preset.bbAdd
        state.limitG = preset.limitG
        currentState = state
    }

    private func clearNowInput() {
        guard let nowIndex = rows.firstIndex(where: { $0.kind == .now }) else { return }
        var updatedRows = rows
        updatedRows[nowIndex].gInput = ""
        rows = updatedRows
    }

    private func updateLabels(_ rows: inout [Row]) {
        for i in 0..<rows.count {
            rows[i].label = Row.labelForIndex(i)
        }
    }
}
