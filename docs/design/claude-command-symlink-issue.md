# Claude Codeカスタムコマンドシンボリックリンク問題調査報告書

## 調査概要

**調査日時**: 2025年7月27日  
**調査者**: AI指示書キット開発チーム  
**タスクID**: TASK-cmd-check

## 問題の概要

AI指示書キットプロジェクトで設定したClaude Codeカスタムコマンドが動作していない可能性がある。

## 調査結果

### 1. 現在の設定状況

#### ディレクトリ構造
```
AI_Instruction_Kits/
├── .claude/
│   └── commands/
│       ├── checkpoint.md -> ../../../templates/claude-commands/checkpoint.md
│       ├── commit-and-report.md -> ../../../templates/claude-commands/commit-and-report.md
│       └── reload-instructions.md -> ../../../templates/claude-commands/reload-instructions.md
└── templates/
    └── claude-commands/
        ├── checkpoint.md
        ├── commit-and-report.md
        └── reload-instructions.md
```

#### 確認された事実
- `.claude/commands/`内のファイルはすべてシンボリックリンク
- リンク先は`templates/claude-commands/`ディレクトリ内の実ファイル
- setup-project.shの実装済み機能（2025年7月27日 01:47に作成）

### 2. シンボリックリンクの潜在的な問題

#### Claude Codeの仕様
公式ドキュメントによると：
- カスタムコマンドは`.claude/commands/`に配置されたMarkdownファイルとして認識される
- ファイル名（拡張子を除く）がコマンド名になる
- サブディレクトリによる名前空間サポート

#### 問題の可能性
1. **ファイル読み込みの問題**
   - Claude Codeがシンボリックリンクを正しく解決できない可能性
   - 実ファイルとして認識されない可能性

2. **パス解決の問題**
   - コマンド内の相対パス（`!bash scripts/checkpoint.sh`）がシンボリックリンクから正しく解決されない
   - 作業ディレクトリがリンク先ディレクトリになる可能性

3. **権限・セキュリティ**
   - シンボリックリンクへのアクセス制限
   - セキュリティポリシーによる制約

### 3. 検証結果

#### シンボリックリンクの状態
```bash
$ ls -la .claude/commands/
lrwxrwxrwx 1 dobachi dobachi 48 7月 27 01:47 checkpoint.md -> ../../../templates/claude-commands/checkpoint.md
```

- シンボリックリンクは正しく作成されている
- 相対パスでリンクされている
- 読み取り権限は適切に設定されている

## 推奨される対応策

### 1. 短期的対応（即座に実施可能）

#### Option A: 実ファイルへの変更
```bash
# シンボリックリンクを実ファイルに置き換え
cd .claude/commands/
rm checkpoint.md commit-and-report.md reload-instructions.md
cp ../../templates/claude-commands/*.md .
```

#### Option B: ハードリンクの使用
```bash
# ハードリンクに変更（同一ファイルシステム内のみ）
cd .claude/commands/
rm checkpoint.md
ln ../../templates/claude-commands/checkpoint.md checkpoint.md
```

### 2. 長期的対応（setup-project.sh改修）

#### 実装案
```bash
setup_claude_commands() {
    echo "⚡ Setting up Claude Code custom commands..."
    
    if [ ! -d ".claude/commands" ]; then
        mkdir -p .claude/commands
    fi
    
    # シンボリックリンクではなくコピーを使用
    if confirm "Copy Claude Code custom commands?"; then
        for cmd_file in "$AI_INSTRUCTIONS_DIR/templates/claude-commands/"*.md; do
            cmd_name=$(basename "$cmd_file")
            if [ -e ".claude/commands/$cmd_name" ]; then
                backup_file ".claude/commands/$cmd_name"
            fi
            cp "$cmd_file" ".claude/commands/"
            echo "  ✓ Copied $cmd_name"
        done
    fi
}
```

### 3. テスト手順

1. **動作確認テスト**
   ```
   /checkpoint
   /checkpoint start test-123 "テストタスク" 3
   ```

2. **パス解決テスト**
   - scripts/checkpoint.shが正しく実行されるか確認
   - 相対パスが正しく解決されるか確認

3. **エラーログ確認**
   - Claude Codeのエラーメッセージを確認
   - 実行時のパスを確認

## 結論

シンボリックリンクを使用したカスタムコマンドの設定は、Claude Codeの実装によっては問題を引き起こす可能性がある。最も確実な解決策は、シンボリックリンクではなく実ファイルのコピーを使用することである。

## 推奨アクション

1. **即時対応**: 実ファイルへの置き換えテスト
2. **恒久対応**: setup-project.shの改修
3. **ドキュメント更新**: この問題と解決策をREADMEに記載

---
**作成日**: 2025年7月27日  
**更新日**: 2025年7月27日