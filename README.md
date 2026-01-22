# 沖ドキ有利区間G数計算ツール（広告なし版）

パチスロ「沖ドキ！」シリーズの有利区間ゲーム数を計算するiOSアプリです。

## 開発を始める前に

**必ず以下のドキュメントを確認してください：**

- **[CLAUDE.md](./CLAUDE.md)** - プロジェクト構成・アーキテクチャ・ビルド方法
- **[計算ロジック仕様](./docs/CALCULATION.md)** - 計算アルゴリズムの詳細
- **[天国定義仕様](./docs/TENGOKU.md)** - 天国モードの判定ロジック

## ビルド

```bash
xcodebuild -project MyFirstApp.xcodeproj -scheme MyFirstApp \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## バージョン

| バージョン | ディレクトリ |
|-----------|-------------|
| 広告なし版 | このディレクトリ (`MyFirstApp_free`) |
| 広告あり版 | `../MyFirstApp` |
