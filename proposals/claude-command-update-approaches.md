# Claude Codeカスタムコマンド更新機能の実装アプローチ

## 背景

- 現在はシンボリックリンクを使用しているが、Claude Codeで動作しない可能性
- ファイルコピー方式に変更する際、サブモジュール更新時の同期問題を解決したい

## アプローチ案

### 1. 自動同期アプローチ（Git Hook利用）

**概要**: Gitのpost-mergeフックを使用して、サブモジュール更新時に自動でコマンドを同期

```bash
# .git/hooks/post-merge
#!/bin/bash
if git diff HEAD@{1} --name-only | grep -q "ai_instruction_kits"; then
    echo "AI指示書キットが更新されました。カスタムコマンドを同期します..."
    ./scripts/sync-claude-commands.sh
fi
```

**メリット**:
- 完全自動化
- 更新忘れなし
- ユーザー介入不要

**デメリット**:
- Git hookの設定が必要
- チーム間での共有が困難
- hookの実行権限問題

### 2. 明示的同期コマンドアプローチ

**概要**: setup-project.shに`--sync-claude-commands`オプションを追加

```bash
# 使用例
./scripts/setup-project.sh --sync-claude-commands
./scripts/setup-project.sh --sync-claude  # 短縮形
```

**実装例**:
```bash
sync_claude_commands() {
    echo "🔄 Claude Codeカスタムコマンドを同期中..."
    
    # バージョンチェック
    for cmd in "${claude_commands[@]}"; do
        src="$AI_INSTRUCTIONS_DIR/templates/claude-commands/$cmd"
        dst=".claude/commands/$cmd"
        
        if [ -f "$src" ] && [ -f "$dst" ]; then
            if ! diff -q "$src" "$dst" > /dev/null; then
                echo "📝 更新: $cmd"
                cp "$src" "$dst"
            fi
        fi
    done
}
```

**メリット**:
- シンプルで理解しやすい
- 既存の仕組みと統合
- 選択的実行が可能

**デメリット**:
- 手動実行が必要
- 更新忘れの可能性

### 3. チェックサム管理アプローチ

**概要**: コマンドファイルのチェックサムを記録し、起動時に差分チェック

```bash
# .claude/commands/.checksums
checkpoint.md:a1b2c3d4e5f6
commit-and-report.md:g7h8i9j0k1l2
reload-instructions.md:m3n4o5p6q7r8
```

**実装例**:
```bash
check_command_updates() {
    if [ -f ".claude/commands/.checksums" ]; then
        while IFS=: read -r file checksum; do
            new_checksum=$(md5sum "$AI_INSTRUCTIONS_DIR/templates/claude-commands/$file" | cut -d' ' -f1)
            if [ "$checksum" != "$new_checksum" ]; then
                echo "⚠️  $file に更新があります"
                return 1
            fi
        done < ".claude/commands/.checksums"
    fi
    return 0
}
```

**メリット**:
- 正確な変更検出
- 部分的な更新対応
- 履歴管理可能

**デメリット**:
- 実装が複雑
- チェックサムファイル管理
- パフォーマンスオーバーヘッド

### 4. タイムスタンプベースアプローチ

**概要**: 最終同期時刻を記録し、ソースファイルの更新を検出

```bash
# .claude/commands/.last-sync
2025-01-27 21:45:00
```

**実装例**:
```bash
needs_sync() {
    if [ -f ".claude/commands/.last-sync" ]; then
        last_sync=$(cat ".claude/commands/.last-sync")
        for cmd in "${claude_commands[@]}"; do
            src="$AI_INSTRUCTIONS_DIR/templates/claude-commands/$cmd"
            if [ -f "$src" ] && [ "$src" -nt ".claude/commands/.last-sync" ]; then
                return 0
            fi
        done
    else
        return 0
    fi
    return 1
}
```

**メリット**:
- シンプルな実装
- 高速な判定
- 一括処理向き

**デメリット**:
- タイムスタンプの信頼性
- 個別ファイル管理なし

### 5. インタラクティブ更新アプローチ

**概要**: checkpoint.sh実行時に更新チェックと提案

```bash
# checkpoint.sh の冒頭に追加
check_claude_command_updates() {
    if [ -d ".claude/commands" ]; then
        updates_available=false
        for cmd in checkpoint.md commit-and-report.md reload-instructions.md; do
            src="$SCRIPT_DIR/../templates/claude-commands/$cmd"
            dst=".claude/commands/$cmd"
            if [ -f "$src" ] && [ -f "$dst" ]; then
                if ! diff -q "$src" "$dst" > /dev/null 2>&1; then
                    updates_available=true
                    break
                fi
            fi
        done
        
        if [ "$updates_available" = true ]; then
            echo "📢 Claude Codeコマンドに更新があります。'setup-project.sh --sync-claude-commands' を実行してください。"
        fi
    fi
}
```

**メリット**:
- ユーザーへの通知
- 既存ワークフローに統合
- 非侵襲的

**デメリット**:
- 通知のみで自動更新なし
- ノイズになる可能性

## 推奨アプローチ

**第1選択: アプローチ2 + 5の組み合わせ**

1. setup-project.shに`--sync-claude-commands`オプション追加
2. checkpoint.sh実行時に更新通知
3. 初期セットアップ時はファイルコピー

**理由**:
- バランスが良い（自動化と制御のバランス）
- 既存システムとの親和性
- 段階的な導入が可能
- ユーザーの選択権を保持
- Claude専用であることが明確

**実装優先順位**:
1. ファイルコピーへの変更（即座に実施）
2. --sync-claude-commandsオプション追加
3. checkpoint.shでの更新通知
4. 将来的にGit hook対応を検討

## 命名規則の考慮

Claude Code固有の機能であることを明確にするため、以下の命名を採用：

- オプション: `--sync-claude-commands`, `--sync-claude`
- 関数名: `sync_claude_commands()`, `check_claude_command_updates()`
- ディレクトリ: `.claude/commands/`
- テンプレート: `templates/claude-commands/`

将来的に他のAIツール（Gemini、Cursor等）への対応時も、同様の命名規則を適用可能。

---
**作成日**: 2025年7月27日
**更新日**: 2025年7月27日