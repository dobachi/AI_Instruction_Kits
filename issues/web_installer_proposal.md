# feat: ワンライナーインストーラ機能の実装

## 概要
AI指示書キットのセットアップを1行のコマンドで実行できるインストーラを実装する。

## 背景
現在の `setup-project.sh` は強力だが、以下の課題がある：
- 事前にリポジトリのクローンが必要
- オプションが多く初心者には複雑
- 初回セットアップのハードルが高い

## 提案する実装方法

### 方法1: ワンライナーインストーラ（推奨・最優先）
**メリット:**
- **1行のコマンドで完全セットアップ**
- リポジトリのクローン不要
- 多くの有名プロジェクトで実績あり（Homebrew、rustup、nvm等）
- メンテナンスが簡単

**実装内容:**
```bash
# 基本インストール（インタラクティブ）
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash

# プリセット付き高速セットアップ
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset web_api --force

# カスタムリポジトリ＆英語版
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --repo https://github.com/yourname/fork.git --lang en
```

**スクリプト機能:**
- ✅ 環境チェック（Git、curl/wget）
- ✅ インタラクティブモード（デフォルト）
- ✅ プリセット対応（web_api、cli_tool、data_analyst等）
- ✅ 多言語対応（日本語/英語）
- ✅ カスタムリポジトリ対応
- ✅ 既存の setup-project.sh を内部で活用

### 方法2: 静的HTMLベースのセットアップウィザード
**メリット:**
- GitHub Pagesで簡単にホスティング可能
- 追加のインフラ不要
- オフラインでも利用可能（ダウンロード後）

**実装内容:**
```html
<!-- docs/installer/index.html -->
- プロジェクトタイプ選択UI
- 統合モード選択（copy/clone/submodule）
- 言語選択（日本語/英語）
- カスタマイズオプション
```

**生成物:**
- カスタマイズされたワンライナーコマンド
- setup-project.sh用の設定ファイル
- プロジェクト固有のPROJECT.mdテンプレート

### 方法2: ローカルWebサーバー方式
**メリット:**
- リアルタイムでファイル操作可能
- プログレス表示が可能
- エラーハンドリングが容易

**実装内容:**
```python
# scripts/web-installer.py
- Flask/FastAPIベースの軽量サーバー
- RESTful API for setup operations
- WebSocketでリアルタイム進捗表示
```

**起動方法:**
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/web-installer.py | python3
```

### 方法3: クラウドベースインストーラ
**メリット:**
- 常に最新版を提供
- 利用統計の収集が可能
- マルチユーザー対応

**実装内容:**
- Vercel/Netlify Functions
- GitHub API連携
- プロジェクトテンプレート管理システム

## 実装計画

### フェーズ1: ワンライナーインストーラ（1週間）
- [x] install.sh スクリプトの作成
- [ ] エラーハンドリングの強化
- [ ] テスト（各OS、各シェル環境）
- [ ] README.mdへの使用例追加
- [ ] ドキュメント更新

### フェーズ2: 拡張機能（オプション）
- [ ] Windowsサポート（PowerShell版）
- [ ] Docker版インストーラ
- [ ] プログレスバー表示
- [ ] オフライン対応（バンドル版）

### フェーズ3: Webウィザード（将来的な拡張）
- [ ] 静的HTMLウィザード
- [ ] ワンライナー生成UI
- [ ] カスタムモジュール選択UI

## 技術スタック案
- **フロントエンド:** Vanilla JS + Tailwind CSS（依存最小化）
- **ビルドツール:** Vite（開発時のみ）
- **ホスティング:** GitHub Pages
- **CI/CD:** GitHub Actions

## UIモックアップ案

```
┌─────────────────────────────────────┐
│     AI指示書キット セットアップ      │
├─────────────────────────────────────┤
│                                     │
│  1. プロジェクトタイプを選択:        │
│     ○ Web API開発                  │
│     ○ CLIツール開発                │
│     ○ データ分析                   │
│     ○ カスタム                     │
│                                     │
│  2. 統合方法を選択:                 │
│     ○ サブモジュール（推奨）        │
│     ○ クローン                     │
│     ○ コピー                       │
│                                     │
│  3. オプション:                     │
│     ☑ Claude Codeコマンド          │
│     ☑ Git hooks                    │
│     ☐ OpenHands設定                │
│                                     │
│  [セットアップコマンド生成]         │
│                                     │
└─────────────────────────────────────┘
```

## 期待される効果
- **セットアップ時間を5分→30秒に短縮**
- **コマンド1行で完全セットアップ**
- 初心者のハードルを大幅に低減
- プロジェクト固有設定の標準化
- 有名プロジェクトと同等のUX提供

## 関連Issue
- #70 セットアップの簡略化
- #65 ドキュメントの改善

## チェックリスト
- [ ] 実装方法の決定
- [ ] プロトタイプ作成
- [ ] ユーザビリティテスト
- [ ] ドキュメント作成
- [ ] リリース

## ラベル
- enhancement
- documentation
- good first issue