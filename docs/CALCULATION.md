# 計算ロジック仕様書

Web版 v15c と完全互換の計算ロジック。

## パース関数

### parseG(value: String) -> Int?

| 入力 | 出力 | 備考 |
|------|------|------|
| `""` | `nil` | 空文字 |
| `"  "` | `nil` | 空白のみ |
| `"abc"` | `nil` | 非数値 |
| `"100"` | `100` | 正常 |
| `"100.7"` | `100` | 小数切り捨て |
| `"-50"` | `0` | 負数は0にクランプ |
| `"99999"` | `10050` | 上限クランプ |

```swift
func parseG(_ value: String) -> Int? {
    let trimmed = value.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return nil }
    guard let num = Double(trimmed) else { return nil }
    let truncated = Int(num)
    return max(0, min(truncated, 10050))
}
```

### nzInt(value: String) -> Int

| 入力 | 出力 |
|------|------|
| `""` | `0` |
| `"abc"` | `0` |
| `"24"` | `24` |
| `"-10"` | `0` |

```swift
func nzInt(_ value: String) -> Int {
    guard let num = Double(value) else { return 0 }
    let truncated = Int(num)
    return max(0, truncated)
}
```

## Calculator.compute() - 5ステップ

### Step 1: 上側累積
- 処理順序: resetIndex-1 → 0（reversed）
- endTopはhit行のみで更新
- now行は別途処理（endTop更新しない）
- nowIndexは動的に探索（rows[0]前提を置かない）

### Step 2: 切断計算
- cutIndex〜resetIndex-1のhit行のみ合計
- now行は絶対に含めない
- cutIndex=nilの場合、upperAtCut=0

### Step 3: KPI算出
- normalRemain = limitG - currentTop（常に数値）
- cutRemain = limitG - (currentTop - upperAtCut)（cutIndex有時のみ）

### Step 4: OK判定
- 条件: prevEnd < limit && currentTop > limit
- prevEndNormal: index1からresetIndex-1まで走査し、calc.endがある最初の行
- 🔵OK: 切断後の有効累計で判定

### Step 5: 下側累積
- 表示専用（KPI計算には影響しない）

## 計算例

### 例1: 基本ケース（BLACK, resetIndex=3）
```
rows[0]: kind=now,  g="100"
rows[1]: kind=hit,  g="200", type=RB
rows[2]: kind=hit,  g="300", type=BB
resetIndex=3, cutIndex=nil
rbAdd=24, bbAdd=59, limitG=2000
```

**計算結果**:
- endTop = 583 (359 + 224)
- currentTop = 683 (583 + 100)
- normalRemain = 1317 (2000 - 683)

### 例2: OK判定成立
```
rows[0]: kind=now,  g="500"
rows[1]: kind=hit,  g="1600", type=RB
resetIndex=2, cutIndex=nil
```

**計算結果**:
- prevEndNormal = 1624
- currentTopNormal = 2124
- normalRemain = -124 (neg状態)
- isOKNormal = true (1624 < 2000 && 2124 > 2000)

### 例3: 切断ありケース
```
rows[0]: kind=now,  g="100"
rows[1]: kind=hit,  g="200", type=RB  ← cutIndex=1
rows[2]: kind=hit,  g="300", type=BB
resetIndex=3, cutIndex=1
```

**計算結果**:
- upperAtCut = 583 (224 + 359)
- normalRemain = 1317
- cutRemain = 1900 (2000 - (683 - 583))

## 表示形式

- hit行: `"{atHit}→{atEnd}"` (例: "559→583")
- now行: `"{currentTop}"` (例: "683")
- 天井超え行: グレー表示（狙い目でない）
