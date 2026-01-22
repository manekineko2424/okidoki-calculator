# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## プロジェクト概要

- **アプリ名**: 沖ドキ！有利区間ゲーム数計算ツール
- **目的**: Web版(v15c)と完全互換のiOS計算ツール
- **対象**: iOS 17+

## ビルドコマンド

```bash
# ビルド
xcodebuild -project MyFirstApp.xcodeproj -scheme MyFirstApp -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## アーキテクチャ

### パターン
- **MVVM** + @Observable (iOS 17+)
- 計算ロジックは純粋関数として分離

### ファイル構成
```
MyFirstApp/
├── Models/          # データ構造
├── ViewModels/      # @Observable ViewModel
├── Services/        # 計算・永続化ロジック
├── Views/           # SwiftUI View
└── ContentView.swift
```

### 主要コンポーネント
| ファイル | 役割 |
|---------|------|
| AppState | 全体状態（machineStates, currentModel等） |
| MachineState | 機種ごとの状態（rows, resetIndex, cutIndex等） |
| Row | 行データ（kind, gInput, type） |
| Calculator | 純粋計算ロジック（compute関数） |
| CalculatorViewModel | UI状態管理、永続化トリガー |

## データモデル概要

### AppState
- currentModel: MachineModel (black/gold/gorgeous)
- machineStates: [MachineModel: MachineState] (機種ごとの状態)

### MachineState
- rbAdd, bbAdd, limitG: String (設定値)
- rows: [Row] (履歴行)
- resetIndex: Int (🟡バー位置)
- cutIndex: Int? (🔵バー位置、nil可)

### Row
- kind: .now | .hit
- gInput: String (G数入力)
- type: .rb | .bb | .fin

## 機種プリセット
| model | displayName | rbAdd | bbAdd | limitG |
|-------|-------------|-------|-------|--------|
| black | ブラック | 24 | 59 | 2000 |
| gold | ゴールド | 29 | 69 | 2000 |
| gorgeous | ゴージャス | 24 | 59 | 3000 |

## Web互換性の重要ポイント

1. **parseG()**: 空文字→nil、非数値→nil、0-10050にクランプ
2. **nzInt()**: 空文字→0、非数値→0、負数→0
3. **endTop**: hit行のみで更新、now行は含めない
4. **upperAtCut**: hit行のみ加算、now行は絶対に含めない
5. **normalRemain**: 常に数値（nilにしない）
6. **OK判定**: prevEnd < limit && currentTop > limit
7. **neg優先**: ok/neg共存時はneg（赤）を優先表示

## 関連ドキュメント

- [計算ロジック仕様](docs/CALCULATION.md)
- [天国定義仕様](docs/TENGOKU.md)
