# LPコード改善点レビュー

## 対象範囲
- ディレクトリ: `app-lp`
- 主な対象ファイル: `index.html`, `assets/css/style.css`, `assets/js/main.js`

## 指摘一覧（重大度順）

### [P1] JS無効時に主要コンテンツが非表示のままになる
- 該当: `assets/css/style.css`
- 概要: `.fade-in-up` が初期状態で `opacity: 0` のため、JSが動かない環境だと本文が表示されない。
- 影響: LPの主要メッセージが見えず、UX/コンバージョンに致命的な影響。

### [P1] App Storeリンクが不正な可能性
- 該当: `index.html`
- 概要: `https://apps.apple.com/us/app//id6758393837` の形式が不自然で、遷移失敗の可能性がある。
- 影響: インストール導線が機能しないリスク。

### [P2] OGP画像が相対パスのまま
- 該当: `index.html`
- 概要: `og:image` が相対パスのため、SNSでのプレビューが表示されない可能性。
- 影響: 共有時の見栄え/クリック率低下。

### [P3] Smooth scrollが二重・死コード
- 該当: `assets/css/style.css`, `assets/js/main.js`
- 概要: CSSの `scroll-behavior: smooth;` とJSの `scrollIntoView` が重複。さらに `href="#..."` のアンカーが存在せずJS側が実質無効。
- 影響: 不要コード増加と挙動の冗長化。

### [P3] リポジトリ管理上の改善
- 該当: ルート
- 概要: `.gitignore` が無く、`node_modules` や `.DS_Store` が含まれやすい。
- 影響: 差分肥大・管理コスト増。

## Open Questions / Assumptions
- App Store URLの正しい形式は未確認。
- OGPの絶対URL化には公開ドメインが必要。
