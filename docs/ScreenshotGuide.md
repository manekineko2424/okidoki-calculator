# App Store スクリーンショット撮影ガイド

## 現在の状態

- **iPhone 17 Pro Max シミュレータ**: 起動済み、アプリインストール済み
- **対応サイズ**: 6.9インチ (1320 x 2868px)

## 撮影手順

### Step 1: シミュレータの準備

シミュレータは既に起動しています。以下を確認してください：

1. ステータスバーが `9:41` を表示していること
2. 電波がフル、バッテリー100%であること

### Step 2: デモデータ入力

以下の4つのシナリオで撮影します。各シナリオでの推奨入力値：

---

#### スクリーンショット 1: メイン画面（アプリ起動直後）

**目的**: アプリの全体像を見せる

**入力手順**:
1. アプリを起動（既に起動済み）
2. 機種タブで「ブラック」を選択
3. G数に `1234` を入力
4. まだボタンは押さない

**撮影ポイント**:
- 機種選択タブが見える
- G数入力フィールドに数値が入っている
- 「残り」表示が見える

---

#### スクリーンショット 2: 計算結果表示

**目的**: 主要機能（残りG数計算）をアピール

**入力手順**:
1. G数に `1234` を入力
2. 「+RB」ボタンをタップ（RB当選を記録）
3. G数に `450` を入力
4. 「+BB」ボタンをタップ
5. G数に `850` を入力して「現在」のまま

**期待される表示**:
- 履歴に2行（RB、BB）が表示
- 「現在」行に850Gが表示
- 残りG数が計算されて表示

---

#### スクリーンショット 3: 履歴一覧

**目的**: データ管理機能を見せる

**入力手順**:
1. 前の状態から続けて、さらにデータを追加：
   - G数 `123` → 「+RB」
   - G数 `56` → 「+BB」
   - G数 `234` → 「+RB」
   - G数 `178` → 「+BB」

**期待される表示**:
- 複数のRB/BB履歴が表示
- 色分けされた種別バッジ
- 計算結果が各行に表示

---

#### スクリーンショット 4: リセットバー操作

**目的**: 直感的な操作性をアピール

**入力手順**:
1. 「バー追加」ボタンをタップして🟡リセットバーを追加
2. リセットバーの ◀▶ ボタンで位置を2〜3行目の間に移動

**期待される表示**:
- 🟡リセットバーが履歴の間に表示
- ◀▶ 移動ボタンが見える
- バー追加/削除ボタンが見える

---

## 撮影方法

シミュレータで `⌘+S` を押すとスクリーンショットがデスクトップに保存されます。

```bash
# 保存先の確認
ls -la ~/Desktop/*.png | tail -10
```

## ファイル命名規則

撮影後、以下のようにリネームしてください：

```
screenshot_1_main.png      # メイン画面
screenshot_2_result.png    # 計算結果
screenshot_3_history.png   # 履歴一覧
screenshot_4_resetbar.png  # リセットバー操作
```

## 6.7インチ用スクリーンショット（オプション）

6.9インチがあれば6.7インチは自動スケーリングされますが、
別途撮影する場合は以下のコマンドで別のシミュレータを起動できます：

```bash
# iPhone 17用シミュレータを起動
xcrun simctl boot 'iPhone 17'

# アプリをインストール
xcrun simctl install 'iPhone 17' ~/Library/Developer/Xcode/DerivedData/MyFirstApp-hjsjyhnudtnwtueszxsofrpzsbxb/Build/Products/Debug-iphonesimulator/MyFirstApp.app

# アプリを起動
xcrun simctl launch 'iPhone 17' dev.manekineko.MyFirstApp
```

## Figmaでのデザイン作成（推奨）

よりプロフェッショナルなスクリーンショットを作成する場合：

1. Figmaを開く: https://www.figma.com/
2. フレームサイズ: 1320 x 2868 px（6.9インチ用）
3. 構成:
   - 背景色: #1A1A1A（ダーク）or #F5F5F5（ライト）
   - キャッチコピー（上部）
   - iPhone枠 + スクリーンショット（中央）

### キャッチコピー案

| 枚数 | キャッチコピー |
|------|--------------|
| 1枚目 | 有利区間を一目で把握 |
| 2枚目 | 残りG数を自動計算 |
| 3枚目 | 当選履歴を簡単管理 |
| 4枚目 | 3機種対応 |

## チェックリスト

- [ ] iPhone 17 Pro Max シミュレータでアプリ起動
- [ ] デモデータ入力（4パターン）
- [ ] 各画面で ⌘+S でスクリーンショット保存
- [ ] ファイルをリネーム
- [ ] （オプション）Figmaでデザイン追加
- [ ] App Store Connectにアップロード

## トラブルシューティング

### シミュレータが見つからない場合
```bash
# 利用可能なシミュレータ一覧
xcrun simctl list devices available
```

### アプリが起動しない場合
```bash
# 再ビルド
xcodebuild -project MyFirstApp.xcodeproj -scheme MyFirstApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build

# 再インストール
xcrun simctl install 'iPhone 17 Pro Max' ~/Library/Developer/Xcode/DerivedData/MyFirstApp-hjsjyhnudtnwtueszxsofrpzsbxb/Build/Products/Debug-iphonesimulator/MyFirstApp.app
```
