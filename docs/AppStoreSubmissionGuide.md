# App Store 提出マニュアル

このドキュメントでは、XcodeでのアーカイブからApp Store Connectでの審査提出までの全手順を解説します。

---

## 目次

1. [事前準備](#1-事前準備)
2. [Xcode設定](#2-xcode設定)
3. [Apple Developer Portalでのプロビジョニング](#3-apple-developer-portalでのプロビジョニング)
4. [Xcodeでのアーカイブ作成とアップロード](#4-xcodeでのアーカイブ作成とアップロード)
5. [App Store Connect設定](#5-app-store-connect設定)
6. [審査提出](#6-審査提出)
7. [トラブルシューティング](#7-トラブルシューティング)

---

## 1. 事前準備

### 1.1 Apple Developer Program

**必須**: App Storeにアプリを公開するには、Apple Developer Programへの登録が必要です。

- **費用**: 年間 ¥12,980（税込）
- **登録URL**: https://developer.apple.com/programs/
- **登録に必要なもの**:
  - Apple ID
  - クレジットカード
  - 本人確認書類（場合により）

**確認方法**:
1. https://developer.apple.com にアクセス
2. 「Account」をクリック
3. 「Membership」でステータスを確認
   - 「Active」と表示されればOK

### 1.2 必要な素材

| 素材 | 要件 | 状態 |
|------|------|------|
| アプリアイコン | 1024x1024px PNG（角丸なし） | ✅ 設定済み |
| スクリーンショット | 6.9インチ or 6.7インチ用 | ✅ `screenshots/` |
| プライバシーポリシー | 公開URL必須 | ✅ `docs/PrivacyPolicy.md` |
| 説明文 | 4000文字以内 | ✅ `docs/AppStoreDescription.md` |

### 1.3 プライバシーポリシーの公開

App Store Connectには公開URLが必要です。以下のいずれかで公開：

**オプション1: GitHub Pages（推奨）**
```bash
# リポジトリでGitHub Pagesを有効化
# Settings → Pages → Source: main / docs
# URL例: https://username.github.io/repo-name/PrivacyPolicy.html
```

**オプション2: Notion公開ページ**
1. Notionに `docs/PrivacyPolicy.md` の内容をコピー
2. 右上「Share」→「Publish to web」

**オプション3: 独自サイト**
- 任意のホスティングサービスにアップロード

---

## 2. Xcode設定

### 2.1 プロジェクト設定を開く

1. Xcodeでプロジェクトを開く
2. 左サイドバーでプロジェクト（青いアイコン）をクリック
3. 「TARGETS」→「MyFirstApp」を選択

### 2.2 General タブ

| 項目 | 設定値 | 説明 |
|------|--------|------|
| Display Name | 沖ドキ！有利区間ゲーム数計算ツール | ホーム画面に表示される名前 |
| Bundle Identifier | dev.manekineko.MyFirstApp | 一意の識別子（変更不可） |
| Version | 1.0 | ユーザーに表示されるバージョン |
| Build | 1 | 内部ビルド番号（アップデート毎に増加） |

**Supported Destinations**:
- iPhone にチェック
- iPad はオプション（サポートする場合はチェック）

**Minimum Deployments**:
- iOS 17.0（または対象の最低バージョン）

### 2.3 Signing & Capabilities タブ

**自動署名（推奨）**:
1. 「Automatically manage signing」にチェック
2. 「Team」でApple Developer Programのチームを選択
3. Signing Certificateが自動で設定される

```
Team: manekineko (Personal Team) または会社名
Bundle Identifier: dev.manekineko.MyFirstApp
Provisioning Profile: Xcode Managed Profile
Signing Certificate: Apple Distribution
```

**手動署名の場合**:
- 後述の「Apple Developer Portal」でプロファイルを作成

### 2.4 Build Settings タブ

重要な設定項目:

| 項目 | 設定値 |
|------|--------|
| Code Signing Identity (Release) | Apple Distribution |
| Development Team | あなたのTeam ID |
| Provisioning Profile | Automatic または手動で選択 |

### 2.5 Info.plist の確認

プライバシー関連の権限がある場合、説明文を設定:

```xml
<!-- 例: カメラを使用する場合 -->
<key>NSCameraUsageDescription</key>
<string>写真撮影のためにカメラを使用します</string>
```

> **本アプリの場合**: 特別な権限は不要

---

## 3. Apple Developer Portalでのプロビジョニング

> **注意**: Xcodeの「Automatically manage signing」を使用する場合、この手順はスキップ可能です。

### 3.1 App ID の作成

1. https://developer.apple.com/account にアクセス
2. 「Certificates, Identifiers & Profiles」を選択
3. 左メニュー「Identifiers」→「＋」ボタン

設定:
```
Description: MyFirstApp
Bundle ID: Explicit → dev.manekineko.MyFirstApp
Capabilities: 必要に応じて選択（本アプリは不要）
```

### 3.2 証明書の作成

**Distribution Certificate**が必要:

1. 「Certificates」→「＋」ボタン
2. 「Apple Distribution」を選択
3. CSR（Certificate Signing Request）をアップロード

**CSRの作成方法**:
```
1. キーチェーンアクセスを開く
2. メニュー「キーチェーンアクセス」→「証明書アシスタント」→「認証局に証明書を要求」
3. メールアドレスを入力
4. 「ディスクに保存」を選択
5. 生成された .certSigningRequest ファイルをアップロード
```

### 3.3 プロビジョニングプロファイルの作成

1. 「Profiles」→「＋」ボタン
2. 「App Store Connect」を選択
3. App ID を選択: `dev.manekineko.MyFirstApp`
4. Certificate を選択
5. プロファイル名を入力: `MyFirstApp Distribution`
6. 「Generate」→「Download」

**Xcodeへのインポート**:
- ダウンロードした `.mobileprovision` ファイルをダブルクリック
- または、Xcode → Preferences → Accounts → Download Manual Profiles

---

## 4. Xcodeでのアーカイブ作成とアップロード

### 4.1 ビルド設定の確認

1. Xcodeのスキーム（上部中央）を確認
   - 「MyFirstApp」が選択されている
   - デバイスは「Any iOS Device (arm64)」を選択

2. Product → Clean Build Folder（Shift + Cmd + K）

### 4.2 アーカイブの作成

**方法1: GUI（推奨）**

```
1. Product → Archive
2. ビルドが完了するまで待つ
3. 成功すると Organizer ウィンドウが自動で開く
```

**方法2: コマンドライン**

```bash
# アーカイブ作成
xcodebuild -project MyFirstApp.xcodeproj \
  -scheme MyFirstApp \
  -configuration Release \
  -archivePath build/MyFirstApp.xcarchive \
  archive

# 成功したら build/MyFirstApp.xcarchive が作成される
```

### 4.3 アーカイブのバリデーション

1. Organizer で作成したアーカイブを選択
2. 「Validate App」をクリック
3. オプション選択:
   - ☑ Upload your app's symbols（推奨）
   - ☑ Manage Version and Build Number（推奨）
4. 「Validate」をクリック
5. 緑のチェックマークが出れば成功

### 4.4 App Store Connect へのアップロード

1. Organizer で「Distribute App」をクリック
2. 「App Store Connect」を選択 → Next
3. 「Upload」を選択 → Next
4. オプション選択:
   - ☑ Upload your app's symbols
   - ☑ Manage Version and Build Number
5. 署名を確認 → Next
6. 「Upload」をクリック

```
アップロード成功のメッセージが表示されるまで待つ
（数分かかる場合あり）
```

### 4.5 アップロード後の確認

1. https://appstoreconnect.apple.com にアクセス
2. 「マイApp」→ 対象アプリを選択
3. 「TestFlight」タブでビルドが表示されることを確認
   - ステータスが「処理中」→「準備完了」になるまで待つ（最大30分程度）

---

## 5. App Store Connect設定

### 5.1 新規アプリの作成

> 初回のみ必要。既存アプリの場合はスキップ。

1. https://appstoreconnect.apple.com にアクセス
2. 「マイApp」→「＋」→「新規App」

入力項目:

| 項目 | 値 |
|------|-----|
| プラットフォーム | iOS |
| 名前 | 沖ドキ！有利区間ゲーム数計算ツール |
| プライマリ言語 | 日本語 |
| バンドルID | dev.manekineko.MyFirstApp |
| SKU | okidoki-calculator-001 |

### 5.2 App情報タブ

**「App情報」**を選択:

| 項目 | 設定値 |
|------|--------|
| 名前 | 沖ドキ！有利区間ゲーム数計算ツール |
| サブタイトル | 有利区間の残りG数を自動計算 |
| カテゴリ（プライマリ） | ユーティリティ |
| カテゴリ（セカンダリ） | エンターテインメント |
| コンテンツ配信権 | 自分で制作したコンテンツを使用 |
| 年齢制限 | 17+（ギャンブルシミュレーション） |

### 5.3 価格および配信状況

**「価格および配信状況」**を選択:

| 項目 | 設定値 |
|------|--------|
| 価格 | 無料 |
| 配信可能地域 | すべての国と地域（または日本のみ） |

### 5.4 Appプライバシー

**「Appプライバシー」**を選択:

1. 「プライバシーポリシーURL」を入力（公開したURL）
2. 「データ収集」→「データを収集していません」を選択
   - 本アプリはサーバー送信なし、データ収集なし

### 5.5 バージョン情報（iOS App タブ）

**「iOS App」**→ バージョン（1.0）を選択:

#### スクリーンショット

1. 「6.9インチ」または「6.7インチ」を選択
2. `screenshots/` フォルダから画像をドラッグ&ドロップ
3. 順序を調整（掲載順: 01→02→03→04）

| 順番 | ファイル | 内容 |
|------|----------|------|
| 1 | AppStore_01.png | 残りG数ハイライト |
| 2 | AppStore_02.png | 入力で結果表示 |
| 3 | AppStore_03.png | カスタム設定 |
| 4 | AppStore_04.png | 3機種対応 |

#### テキスト入力

| 項目 | 入力内容 |
|------|----------|
| プロモーションテキスト | [AppStoreDescription.md](AppStoreDescription.md) からコピー |
| 説明 | [AppStoreDescription.md](AppStoreDescription.md) からコピー |
| キーワード | `沖ドキ,パチスロ,有利区間,ゲーム数,計算,ツール,ブラック,ゴールド,ゴージャス,天国` |
| サポートURL | GitHub リポジトリURL または サポートページURL |
| マーケティングURL | （任意） |
| バージョン | 1.0 |
| 著作権 | © 2026 manekineko |

#### What's New（新機能）

```
初回リリース
- 沖ドキ！ブラック/ゴールド/ゴージャスに対応
- 有利区間ゲーム数の自動計算
- 複数リセット位置の管理機能
- カスタム機種設定
```

### 5.6 ビルドの選択

1. 「ビルド」セクションで「＋」をクリック
2. アップロード済みのビルドを選択
3. 「完了」をクリック

> ビルドが表示されない場合:
> - 処理中（最大30分待つ）
> - アップロードエラー（メールを確認）

### 5.7 App Review情報

**「App Review情報」**を選択:

| 項目 | 入力内容 |
|------|----------|
| 連絡先（名前） | あなたの名前 |
| 連絡先（電話） | 連絡可能な電話番号 |
| 連絡先（メール） | 連絡可能なメールアドレス |
| デモアカウント | 不要（ログイン機能なし） |
| 備考（審査ノート） | 下記参照 |

**審査ノート（推奨）**:
```
本アプリはパチスロ「沖ドキ！」シリーズの有利区間ゲーム数を計算する補助ツールです。

実際の金銭的な賭けを行う機能はなく、ゲーム数の記録と計算のみを行います。
データはすべてユーザーの端末内に保存され、サーバーへの送信は行いません。

年齢制限を17+に設定した理由：
パチスロ関連のコンテンツであるため、成人向けとしています。
ただし、アプリ自体にギャンブル機能は一切含まれていません。
```

---

## 6. 審査提出

### 6.1 輸出コンプライアンス

ビルドを選択すると、輸出コンプライアンスの質問が表示される場合があります:

**質問**: 「このAppは暗号化を使用していますか？」

**回答**:
- 本アプリは独自の暗号化を使用していない
- HTTPSのみ（標準ライブラリ）→「**いいえ**」を選択

### 6.2 提出前チェックリスト

- [ ] スクリーンショットがアップロードされている
- [ ] 説明文・キーワードが入力されている
- [ ] プライバシーポリシーURLが設定されている
- [ ] 年齢制限が設定されている（17+）
- [ ] 価格が設定されている（無料）
- [ ] ビルドが選択されている
- [ ] 審査ノートが入力されている

### 6.3 審査に提出

1. 右上の「審査用に追加」をクリック
2. すべての必須項目が入力されていることを確認
3. 「審査に提出」をクリック
4. 確認ダイアログで「提出」をクリック

### 6.4 審査状況の確認

| ステータス | 意味 |
|-----------|------|
| 審査待ち | 審査キューに入った状態 |
| 審査中 | 審査担当者がレビュー中 |
| 準備完了 | 審査通過、公開可能 |
| 却下 | リジェクト（理由を確認し修正） |

**通知設定**:
- App Store Connect → ユーザーとアクセス → 自分のアカウント
- メール通知をオンにしておく

---

## 7. トラブルシューティング

### 7.1 アーカイブが作成できない

**症状**: Product → Archive がグレーアウト

**解決策**:
- デバイスを「Any iOS Device (arm64)」に変更
- シミュレータではアーカイブ不可

### 7.2 署名エラー

**症状**: `Code Signing Error`

**解決策**:
1. Xcode → Preferences → Accounts
2. Apple IDを再ログイン
3. 「Download Manual Profiles」をクリック
4. Signing & Capabilities で Team を再選択

### 7.3 アップロードエラー

**症状**: App Store Connectへのアップロードが失敗

**確認事項**:
- Bundle IDが正しいか
- ビルド番号が前回より大きいか
- アイコンが設定されているか

**エラーメール**: Appleからのメールを確認（詳細な理由が記載）

### 7.4 ビルドが表示されない

**症状**: App Store Connectでビルドが見えない

**解決策**:
- 処理中の場合は最大30分待つ
- Appleからのエラーメールを確認
- TestFlightタブでステータスを確認

### 7.5 審査でリジェクト

**よくある理由と対策**:

| 理由 | 対策 |
|------|------|
| 商標問題 | アプリ名から「沖ドキ」を削除、キーワードのみに |
| ギャンブル関連 | 17+を設定、審査ノートで説明 |
| メタデータ不足 | 説明文・スクリーンショットを追加 |
| クラッシュ | 実機でテストして修正 |

**リジェクト後の手順**:
1. Resolution Centerで理由を確認
2. 必要な修正を行う
3. 新しいビルドをアップロード
4. 再提出

---

## クイックリファレンス

### コピー用テキスト

**キーワード（100文字以内）**:
```
沖ドキ,パチスロ,有利区間,ゲーム数,計算,ツール,ブラック,ゴールド,ゴージャス,天国
```

**プロモーションテキスト**:
```
ボーナス当選時のG数を記録するだけで、有利区間の残りゲーム数をリアルタイムで自動計算。沖ドキ！ブラック・ゴールド・ゴージャスに対応。
```

**著作権**:
```
© 2026 manekineko
```

### 重要なURL

| 用途 | URL |
|------|-----|
| Apple Developer | https://developer.apple.com |
| App Store Connect | https://appstoreconnect.apple.com |
| 証明書・プロファイル | https://developer.apple.com/account/resources/certificates |

---

## 関連ドキュメント

- [App Store 説明文](AppStoreDescription.md)
- [スクリーンショット撮影ガイド](ScreenshotGuide.md)
- [プライバシーポリシー](PrivacyPolicy.md)
- [App Store Connect 設定ガイド](AppStoreConnectGuide.md)
