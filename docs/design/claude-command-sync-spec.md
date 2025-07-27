# Claude Codeカスタムコマンド同期機能仕様書

## 概要

AI指示書キットのClaude Codeカスタムコマンドをシンボリックリンクからファイルコピー方式に変更し、更新時の同期機能を実装する。

## 背景

- Claude Codeがシンボリックリンクを正しく解決できない可能性がある
- ファイルコピー方式への変更により、サブモジュール更新時の同期が必要

## 機能仕様

### 1. 初期セットアップ（ファイルコピー方式）

#### 変更前（現在）
```bash
ln -sf "../../../templates/claude-commands/checkpoint.md" ".claude/commands/checkpoint.md"
```

#### 変更後
```bash
cp "$AI_INSTRUCTIONS_DIR/templates/claude-commands/checkpoint.md" ".claude/commands/checkpoint.md"
```

### 2. 同期機能

#### 2.1 コマンドラインオプション

```bash
# Claude専用オプション
./scripts/setup-project.sh --sync-claude-commands
./scripts/setup-project.sh --sync-claude  # 短縮形

# 将来的な拡張性を考慮した名称
./scripts/setup-project.sh --sync-ai-commands claude  # AI種別を指定する形式も検討
```

#### 2.2 同期処理フロー

1. **差分検出**
   ```bash
   # 各コマンドファイルの差分をチェック
   for cmd in "${claude_commands[@]}"; do
       src="$AI_INSTRUCTIONS_DIR/templates/claude-commands/$cmd"
       dst=".claude/commands/$cmd"
       if ! diff -q "$src" "$dst" > /dev/null 2>&1; then
           # 差分あり
       fi
   done
   ```

2. **更新確認**
   - 差分があるファイルをリスト表示
   - ユーザーに更新の確認を求める

3. **バックアップと更新**
   - 既存ファイルをバックアップ
   - 新しいファイルをコピー

### 3. 自動通知機能

#### 3.1 checkpoint.sh統合

```bash
# checkpoint.sh の冒頭に追加
check_claude_command_updates() {
    local updates_available=false
    local update_files=()
    
    # .claude/commands ディレクトリが存在する場合のみチェック
    if [ ! -d ".claude/commands" ]; then
        return
    fi
    
    for cmd in checkpoint.md commit-and-report.md reload-instructions.md; do
        src="$SCRIPT_DIR/../templates/claude-commands/$cmd"
        dst=".claude/commands/$cmd"
        
        if [ -f "$src" ] && [ -f "$dst" ]; then
            if ! diff -q "$src" "$dst" > /dev/null 2>&1; then
                updates_available=true
                update_files+=("$cmd")
            fi
        fi
    done
    
    if [ "$updates_available" = true ]; then
        echo "📢 Claude Codeコマンドに更新があります: ${update_files[*]}"
        echo "   実行: ./scripts/setup-project.sh --sync-claude-commands"
    fi
}

# status表示時にのみチェック（毎回は実行しない）
if [ "$ACTION" = "" ] || [ "$ACTION" = "status" ]; then
    check_claude_command_updates
fi
```

### 4. 実装詳細

#### 4.1 関数定義

```bash
# Claude Codeコマンドの同期
sync_claude_commands() {
    echo "🔄 Claude Codeカスタムコマンドを同期中..."
    
    # .claudeディレクトリの存在確認
    if [ ! -d ".claude/commands" ]; then
        MSG_NO_CLAUDE_DIR=$(get_message "no_claude_dir" ".claude/commands directory not found" ".claude/commandsディレクトリが見つかりません")
        echo "⚠️  $MSG_NO_CLAUDE_DIR"
        
        if confirm "Claude Codeコマンドディレクトリを作成しますか？"; then
            mkdir -p .claude/commands
            echo "✅ .claude/commandsディレクトリを作成しました"
        else
            return
        fi
    fi
    
    local claude_commands=("commit-and-report.md" "checkpoint.md" "reload-instructions.md")
    local updated_count=0
    local skipped_count=0
    
    for cmd_file in "${claude_commands[@]}"; do
        local src=""
        local dst=".claude/commands/$cmd_file"
        
        # ソースファイルの検索
        if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
        elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
            src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
        else
            echo "⚠️  ソースファイルが見つかりません: $cmd_file"
            continue
        fi
        
        # 差分チェック
        if [ -f "$dst" ]; then
            if diff -q "$src" "$dst" > /dev/null 2>&1; then
                echo "✓ $cmd_file は最新です"
                skipped_count=$((skipped_count + 1))
                continue
            fi
            
            # 更新確認
            echo ""
            echo "📝 $cmd_file に更新があります"
            if confirm "更新しますか？"; then
                backup_file "$dst"
                cp "$src" "$dst"
                echo "✅ $cmd_file を更新しました"
                updated_count=$((updated_count + 1))
            else
                echo "⏭️  $cmd_file の更新をスキップしました"
                skipped_count=$((skipped_count + 1))
            fi
        else
            echo "📝 $cmd_file が存在しません"
            if confirm "作成しますか？"; then
                cp "$src" "$dst"
                echo "✅ $cmd_file を作成しました"
                updated_count=$((updated_count + 1))
            fi
        fi
    done
    
    echo ""
    echo "📊 同期完了: 更新 $updated_count 件、スキップ $skipped_count 件"
}
```

#### 4.2 既存関数の修正

```bash
# Claude Codeカスタムコマンドの設定（修正版）
setup_claude_commands() {
    MSG_SETUP_CLAUDE_COMMANDS=$(get_message "setup_claude_commands" "Setting up Claude Code custom commands" "Claude Codeカスタムコマンドを設定")
    echo "⚡ $MSG_SETUP_CLAUDE_COMMANDS..."
    
    # .claude/commands ディレクトリ作成
    if [ ! -d ".claude/commands" ]; then
        MSG_CREATE_CLAUDE_COMMANDS_DIR=$(get_message "create_claude_commands_dir" "Create .claude/commands directory for Claude Code?" "Claude Code用の.claude/commandsディレクトリを作成しますか？")
        if confirm "$MSG_CREATE_CLAUDE_COMMANDS_DIR"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "mkdir -p .claude/commands"
            else
                mkdir -p .claude/commands
                MSG_CLAUDE_COMMANDS_DIR_CREATED=$(get_message "claude_commands_dir_created" ".claude/commands directory created" ".claude/commandsディレクトリを作成しました")
                echo "✅ $MSG_CLAUDE_COMMANDS_DIR_CREATED"
            fi
        fi
    else
        MSG_CLAUDE_COMMANDS_DIR_EXISTS=$(get_message "claude_commands_dir_exists" ".claude/commands directory already exists" ".claude/commandsディレクトリは既に存在します")
        echo "✓ $MSG_CLAUDE_COMMANDS_DIR_EXISTS"
    fi
    
    # コマンドファイルのコピー（シンボリックリンクではなく）
    if [ -d ".claude/commands" ] || [ "$DRY_RUN" = true ]; then
        echo ""
        MSG_COPY_CLAUDE_COMMANDS=$(get_message "copy_claude_commands" "Copying Claude Code command files" "Claude Codeコマンドファイルをコピー")
        echo "🔗 $MSG_COPY_CLAUDE_COMMANDS..."
        
        local claude_commands=("commit-and-report.md" "checkpoint.md" "reload-instructions.md")
        
        for cmd_file in "${claude_commands[@]}"; do
            local src=""
            local dst=".claude/commands/$cmd_file"
            
            # 既存ファイルチェック（シンボリックリンクの移行処理含む）
            if [ -e "$dst" ]; then
                if [ -L "$dst" ]; then
                    MSG_MIGRATE_SYMLINK=$(get_message "migrate_symlink" "Migrate symbolic link to file?" "シンボリックリンクをファイルに移行しますか？")
                    echo "🔄 $cmd_file はシンボリックリンクです"
                    if confirm "$MSG_MIGRATE_SYMLINK"; then
                        # ソースファイルの検索
                        if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
                            src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
                        elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
                            src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
                        fi
                        
                        if [ -n "$src" ] && [ -f "$src" ]; then
                            if [ "$DRY_RUN" = true ]; then
                                dry_echo "rm $dst && cp $src $dst"
                            else
                                rm "$dst"
                                cp "$src" "$dst"
                                echo "✅ $cmd_file をファイルに移行しました"
                            fi
                        fi
                    fi
                else
                    MSG_CLAUDE_COMMAND_EXISTS=$(get_message "claude_command_exists" "already exists" "は既に存在します")
                    echo "✓ $cmd_file $MSG_CLAUDE_COMMAND_EXISTS"
                fi
                continue
            fi
            
            # ソースファイルの検索とコピー
            if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
                src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
            elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
                src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
            fi
            
            if [ -n "$src" ] && [ -f "$src" ]; then
                MSG_CREATE_CLAUDE_COMMAND=$(get_message "create_claude_command" "Create Claude Code command" "Claude Codeコマンドを作成しますか？")
                if confirm "$cmd_file $MSG_CREATE_CLAUDE_COMMAND"; then
                    if [ "$DRY_RUN" = true ]; then
                        dry_echo "cp $src $dst"
                    else
                        cp "$src" "$dst"
                        MSG_CLAUDE_COMMAND_CREATED=$(get_message "claude_command_created" "Claude Code command created" "Claude Codeコマンドを作成しました")
                        echo "✅ $MSG_CLAUDE_COMMAND_CREATED: $cmd_file"
                    fi
                fi
            else
                MSG_CLAUDE_COMMAND_TEMPLATE_NOT_FOUND=$(get_message "claude_command_template_not_found" "Claude Code command template not found" "Claude Codeコマンドテンプレートが見つかりません")
                echo "⚠️  $MSG_CLAUDE_COMMAND_TEMPLATE_NOT_FOUND: $cmd_file"
            fi
        done
    fi
}
```

### 5. コマンドライン処理

```bash
# コマンドライン引数の処理
SYNC_CLAUDE_COMMANDS_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --sync-claude-commands|--sync-claude)
            SYNC_CLAUDE_COMMANDS_ONLY=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "不明なオプション: $1"
            echo "ヘルプを表示: $0 --help"
            exit 1
            ;;
    esac
done

# --sync-claude-commands が指定された場合
if [ "$SYNC_CLAUDE_COMMANDS_ONLY" = true ]; then
    sync_claude_commands
    exit 0
fi
```

### 6. ヘルプメッセージの追加

```bash
show_help() {
    echo "使用方法: $0 [オプション]"
    echo ""
    echo "オプション:"
    echo "  --sync-claude-commands, --sync-claude"
    echo "                        Claude Codeカスタムコマンドを同期"
    echo "  --dry-run, -n         実際の変更を行わず、実行内容を表示"
    echo "  --help, -h            このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0                    通常のセットアップを実行"
    echo "  $0 --sync-claude      Claude Codeコマンドの同期のみ実行"
}
```

## テスト計画

1. **新規インストールテスト**
   - .claude/commandsディレクトリが存在しない状態から
   - ファイルが正しくコピーされることを確認

2. **移行テスト**
   - シンボリックリンクが存在する状態から
   - ファイルに正しく変換されることを確認

3. **同期テスト**
   - テンプレートファイルを更新
   - --sync-claude-commandsで正しく同期されることを確認

4. **通知テスト**
   - 更新があるファイルが存在する状態で
   - checkpoint.shが通知を表示することを確認

## 影響範囲

- setup-project.sh: 大幅な修正
- checkpoint.sh: 軽微な追加
- README.md: 使用方法の更新
- 既存ユーザー: 次回setup-project.sh実行時に自動移行

## 将来の拡張性

- `--sync-ai-commands gemini` のような形式で他のAIツールにも対応可能
- `.cursor/`, `.gemini/` などのディレクトリ構造にも適用可能

---
**作成日**: 2025年7月27日
**更新日**: 2025年7月27日