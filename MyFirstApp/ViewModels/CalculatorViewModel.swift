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

    var resetIndices: [Int] {
        get { currentState.resetIndices }
        set {
            var state = currentState
            // 各インデックスを範囲内に制限
            state.resetIndices = newValue.map { max(0, min($0, state.rows.count)) }
            currentState = state
        }
    }

    /// 計算用の最初のリセットバー位置
    var primaryResetIndex: Int {
        resetIndices.first ?? rows.count
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
        state.resetIndices = state.resetIndices.map { $0 + 1 }
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
        state.resetIndices = state.resetIndices.map { max(0, $0 - 1) }
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
        state.resetIndices = state.resetIndices.map { min($0, updatedRows.count) }
        if let cut = state.cutIndex, cut >= updatedRows.count {
            state.cutIndex = nil
        }
        currentState = state
    }

    /// すべて削除
    func clearAll() {
        var state = currentState
        state.rows = Row.initialRows()
        state.resetIndices = []  // バーも全削除
        state.cutIndex = nil
        currentState = state
    }

    /// 特定のリセットバーを移動
    func moveResetBar(at barIndex: Int, by delta: Int) {
        guard barIndex < resetIndices.count else { return }
        var indices = resetIndices
        let newValue = max(0, min(indices[barIndex] + delta, rows.count))
        indices[barIndex] = newValue
        resetIndices = indices
    }

    /// 切断バーを移動
    func moveCutBar(by delta: Int) {
        if let current = cutIndex {
            let newIndex = current + delta
            if newIndex >= 0 && newIndex < primaryResetIndex {
                cutIndex = newIndex
            } else if newIndex < 0 {
                cutIndex = nil
            }
        } else {
            // 初回は primaryResetIndex - 1 に配置
            if primaryResetIndex > 0 {
                cutIndex = primaryResetIndex - 1
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

    /// 「現在」行が存在するかどうか
    var hasCurrentRow: Bool {
        rows.contains { $0.kind == .now }
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
                    calcResult = "\(current)G"  // G単位を追加
                } else {
                    calcResult = ""
                }
            } else {
                if let hit = calc?.hit, let end = calc?.end {
                    // 「最終」(fin)は内部加算0Gなので単一値表示
                    if row.type == .fin {
                        calcResult = "\(hit)G"
                    } else {
                        calcResult = "\(hit)G → \(end)G"
                    }
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

    /// 種別ボタン押下で登録（新規のみ）
    func registerEntry(type: HitType?) {
        guard let gValue = parseG(inputGValue), gValue > 0 else { return }
        addNewEntry(gValue: inputGValue, type: type)
    }

    /// 新規エントリ追加
    private func addNewEntry(gValue: String, type: HitType?) {
        var updatedRows = rows

        if type == nil {
            // 「現在」行を追加（初回のみ）
            let newRow = Row(kind: .now, label: "現在", gInput: gValue)
            updatedRows.insert(newRow, at: 0)
        } else {
            // hit行を追加（末尾に追加）
            let newRow = Row(kind: .hit, label: "", gInput: gValue, type: type!)
            updatedRows.append(newRow)
        }

        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        // 「現在」行（先頭挿入）の場合のみ、全てのインデックスを+1
        if type == nil {
            state.resetIndices = state.resetIndices.map { $0 + 1 }
            if let cut = state.cutIndex {
                state.cutIndex = cut + 1
            }
        }
        // hit行（末尾追加）の場合は更新不要
        currentState = state

        // 入力クリア
        inputGValue = ""
    }

    /// 1つ削除（一番下の行＝最も古い履歴を削除）
    func deleteOne() {
        guard !rows.isEmpty else { return }

        var updatedRows = rows
        // 一番下の行（最も古い履歴）を削除
        updatedRows.removeLast()

        updateLabels(&updatedRows)

        var state = currentState
        state.rows = updatedRows
        // リセットインデックスを範囲内に制限（行数が減った分）
        state.resetIndices = state.resetIndices.map { min($0, updatedRows.count) }
        if let cut = state.cutIndex, cut >= updatedRows.count {
            state.cutIndex = nil
        }
        currentState = state
    }

    /// 全削除
    func deleteAll() {
        var state = currentState
        state.rows = []
        state.resetIndices = []  // 全バー削除
        state.cutIndex = nil
        currentState = state
    }

    /// リセットバーを追加（最下部）
    func addResetBar() {
        var indices = resetIndices
        indices.append(rows.count)
        resetIndices = indices
    }

    /// リセットバーを削除（直近追加を削除）
    func removeLastResetBar() {
        guard !resetIndices.isEmpty else { return }
        var indices = resetIndices
        indices.removeLast()
        resetIndices = indices
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
