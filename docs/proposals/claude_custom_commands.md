# Issue: Claude Codeカスタムコマンド実装計画

## 概要

AI指示書キットプロジェクトでClaude Code用の便利なカスタムコマンドを実装し、setup-project.shでの自動デプロイ機能を追加する。

## 背景

現在のワークフローでは、以下の作業を手動で繰り返し実行している：
- コミット→プッシュ→Issue報告→完了処理
- チェックポイントの実行
- 指示書システムの更新・リロード

これらを効率化するため、Claude Codeのカスタムスラッシュコマンド機能を活用する。

## 要件

### 実装するカスタムコマンド

#### 1. `/commit-and-report` - 統合コミット・報告コマンド
**機能:**
- 変更をステージング・コミット・プッシュ
- 指定されたIssueに進捗報告
- 作業完了時にIssueをクローズ

**使用例:**
```
/commit-and-report "feat: カスタムコマンド実装" 123
```

#### 2. `/checkpoint` - チェックポイント実行コマンド
**機能:**
- scripts/checkpoint.sh の実行
- タスク状況の表示・更新
- 新規タスクの開始サポート

**使用例:**
```
/checkpoint
/checkpoint start task-456 "新機能実装" 5
```

#### 3. `/reload-instructions` - 指示書リロードコマンド
**機能:**
- AI指示書サブモジュールの更新
- ROOT_INSTRUCTION.mdの再読み込み
- 更新内容の確認

**使用例:**
```
/reload-instructions
```

### setup-project.sh統合要件

#### 自動デプロイ機能
- `.claude/commands/` ディレクトリの作成
- テンプレートからカスタムコマンドをコピー
- 既存ファイルのバックアップ機能
- 多言語対応（日英）

## 実装アプローチ比較

### 1. テンプレートアプローチ ⭐ 推奨
**方法:** templates/claude-commands/ からファイルをコピー
**メリット:**
- 既存のテンプレート方式と一貫性
- バックアップ機能を活用可能
- 多言語対応が容易
- プロジェクト固有のカスタマイズが可能

### 2. シンボリックリンクアプローチ
**方法:** AI指示書キットへのシンボリックリンク
**メリット:**
- 他のスクリプトと同様の方式
- 自動更新が可能
- ストレージ効率

**デメリット:**
- プロジェクト固有のカスタマイズが困難
- リンク切れのリスク

### 3. ハイブリッドアプローチ
**方法:** 基本コマンドはテンプレート、固有コマンドは独自管理
**メリット:**
- 柔軟性と一貫性の両立
- 段階的な導入が可能

## 実装計画

### Phase 1: コマンドテンプレート作成
- [ ] `templates/claude-commands/` ディレクトリ作成
- [ ] 3つのコマンドファイル作成
  - [ ] `commit-and-report.md`
  - [ ] `checkpoint.md`
  - [ ] `reload-instructions.md`
- [ ] 多言語版の作成（日英）

### Phase 2: setup-project.sh統合
- [ ] Claude Codeコマンド設定セクション追加
- [ ] `.claude/commands/` ディレクトリ作成機能
- [ ] テンプレートコピー機能
- [ ] 確認プロンプト・バックアップ機能
- [ ] i18n対応メッセージ追加

### Phase 3: テスト・ドキュメント
- [ ] 各コマンドの動作テスト
- [ ] setup-project.sh統合テスト
- [ ] README更新
- [ ] 使用例ドキュメント作成

### Phase 4: 高度な機能
- [ ] コマンド引数の検証
- [ ] エラーハンドリング強化
- [ ] GitHub CLI統合の改善
- [ ] 設定ファイル対応

## ファイル構造

```
templates/
├── claude-commands/
│   ├── commit-and-report.md
│   ├── checkpoint.md
│   └── reload-instructions.md
└── claude-commands-en/
    ├── commit-and-report.md
    ├── checkpoint.md
    └── reload-instructions.md

# デプロイ後
project/
└── .claude/
    └── commands/
        ├── commit-and-report.md
        ├── checkpoint.md
        └── reload-instructions.md
```

## 技術仕様

### コマンドファイル形式
```yaml
---
name: command-name
description: コマンドの説明
arguments:
  - name: arg1
    description: 引数の説明
    required: true
---

# コマンドタイトル

コマンドの詳細説明

!bash scripts/example.sh $ARGUMENTS[0]
@path/to/file.md
```

### setup-project.sh追加コード
```bash
# Claude Codeカスタムコマンドの設定
setup_claude_commands() {
    echo "⚡ Setting up Claude Code custom commands..."
    
    # ディレクトリ作成
    if [ ! -d ".claude/commands" ]; then
        if confirm "Create .claude/commands directory?"; then
            mkdir -p .claude/commands
        fi
    fi
    
    # テンプレートからコピー
    copy_command_templates
}
```

## 期待される効果

### 開発効率向上
- 繰り返し作業の自動化により作業時間50%削減
- 手順の標準化によるミス防止
- ワンコマンドでの複合操作実現

### チーム協力強化
- 統一されたワークフロー
- Issue管理の自動化
- 進捗報告の効率化

### AI指示書システム活用促進
- チェックポイント機能の使いやすさ向上
- 指示書更新の簡素化
- システム導入障壁の低減

## リスク・課題

### 技術的リスク
- Claude Codeのバージョン依存性
- GitHub CLI (gh) の依存関係
- 権限エラーの可能性

### 運用リスク
- コマンドの誤用
- 自動化による見落とし
- 設定の複雑化

### 対策
- 十分なテスト実施
- エラーハンドリング強化
- ドキュメント充実
- 段階的導入

## 成功指標

- [ ] 3つのカスタムコマンドが正常動作
- [ ] setup-project.shで自動デプロイ成功
- [ ] ドキュメント完備
- [ ] 実際のワークフローでの検証完了

## 次のステップ

1. **Phase 1開始**: コマンドテンプレート作成
2. **プロトタイプ検証**: 基本動作確認
3. **setup-project.sh統合**: 自動デプロイ機能実装
4. **総合テスト**: 全機能の統合検証

---

## ライセンス情報
- **ライセンス**: Apache-2.0
- **作成日**: 2025-01-26
- **更新日**: 2025-01-26