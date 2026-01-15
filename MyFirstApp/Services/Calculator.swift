//
//  Calculator.swift
//  MyFirstApp
//
//  Web版 v15c と完全互換の計算ロジック

import Foundation

/// 計算ロジック（純粋関数）
enum Calculator {

    /// メイン計算関数
    /// - Parameter state: 機種ごとの状態
    /// - Returns: 計算結果
    static func compute(state: MachineState) -> ComputedMetrics {
        // 前処理: 設定値のパース
        let rbAdd = nzInt(state.rbAdd)
        let bbAdd = nzInt(state.bbAdd)
        let limitG = nzInt(state.limitG)

        var rowCalcs: [UUID: RowCalc] = [:]

        // nowの位置を動的に探索（rows[0]前提を外す）
        let nowIndex = state.rows.firstIndex { $0.kind == .now } ?? 0

        // Step 1: 上側累積（🟡バーより上）
        var endTop = 0

        // reversed: 古い行から処理（境界に近い方が起点）
        for i in stride(from: state.resetIndex - 1, through: 0, by: -1) {
            let row = state.rows[i]

            if row.kind == .hit {
                if let g = parseG(row.gInput) {
                    let addG = getAddG(type: row.type, rbAdd: rbAdd, bbAdd: bbAdd)
                    let atHit = endTop + g
                    let atEnd = atHit + addG
                    rowCalcs[row.id] = RowCalc(hit: atHit, end: atEnd, current: nil)
                    endTop = atEnd
                } else {
                    rowCalcs[row.id] = RowCalc(hit: nil, end: nil, current: nil)
                }
            }
        }

        // now行の処理: endTopは更新しない
        let nowRow = state.rows[nowIndex]
        let nowG = parseG(nowRow.gInput)
        let currentTop = endTop + (nowG ?? 0)

        if nowG != nil {
            rowCalcs[nowRow.id] = RowCalc(hit: nil, end: nil, current: currentTop)
        } else {
            rowCalcs[nowRow.id] = RowCalc(hit: nil, end: nil, current: nil)
        }

        // Step 2: 切断計算（🔵バー位置から🟡バー直前まで）
        var upperAtCut = 0

        if let cutIdx = state.cutIndex {
            for i in cutIdx..<state.resetIndex {
                let row = state.rows[i]
                if row.kind == .hit, let g = parseG(row.gInput) {
                    let addG = getAddG(type: row.type, rbAdd: rbAdd, bbAdd: bbAdd)
                    upperAtCut += g + addG
                }
            }
        }

        // Step 3: KPI算出
        let normalRemain = limitG - currentTop

        let cutRemain: Int?
        if state.cutIndex != nil {
            cutRemain = limitG - (currentTop - upperAtCut)
        } else {
            cutRemain = nil
        }

        // Step 4: OK判定
        // prevEndNormalの探索
        var prevEndNormal = 0
        for i in 1..<state.resetIndex {
            if i < state.rows.count, let end = rowCalcs[state.rows[i].id]?.end {
                prevEndNormal = end
                break
            }
        }

        let cur = parseG(state.rows[nowIndex].gInput) ?? 0
        let currentTopNormal = prevEndNormal + cur

        let isOKNormal = prevEndNormal < limitG && currentTopNormal > limitG

        let isOKCut: Bool
        if state.cutIndex != nil {
            let cutPast = upperAtCut
            let prevEndCutEff = max(0, prevEndNormal - cutPast)
            let currentCutEff = max(0, currentTopNormal - cutPast)
            isOKCut = prevEndCutEff < limitG && currentCutEff > limitG
        } else {
            isOKCut = false
        }

        // Step 5: 下側累積（表示専用）
        var lowerAccum = 0
        for i in state.resetIndex..<state.rows.count {
            let row = state.rows[i]
            if row.kind == .hit, let g = parseG(row.gInput) {
                let addG = getAddG(type: row.type, rbAdd: rbAdd, bbAdd: bbAdd)
                let atHit = lowerAccum + g
                let atEnd = atHit + addG
                rowCalcs[row.id] = RowCalc(hit: atHit, end: atEnd, current: nil)
                lowerAccum = atEnd
            }
        }

        return ComputedMetrics(
            currentTop: currentTop,
            upperAtCut: upperAtCut,
            normalRemain: normalRemain,
            cutRemain: cutRemain,
            isOKNormal: isOKNormal,
            isOKCut: isOKCut,
            rowCalcs: rowCalcs,
            limitG: limitG
        )
    }

    /// 加算G数を取得
    private static func getAddG(type: HitType, rbAdd: Int, bbAdd: Int) -> Int {
        switch type {
        case .rb: return rbAdd
        case .bb: return bbAdd
        case .fin: return 0
        }
    }
}
