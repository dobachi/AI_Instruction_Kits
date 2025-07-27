# Issue: ワークフロー制約導入後、AIがシステム指示書のみを使用してプリセット/カスタム指示書を回避する問題

## 🚨 問題の概要

チェックポイントシステムにワークフロー制約を導入した結果、以下の問題が発生している：

1. **システム指示書偏重**: AIがシステム指示書（`ROOT_INSTRUCTION.md`、`CHECKPOINT_MANAGER.md`）のみを使用し、本来使うべきプリセット指示書やモジュラーシステムを回避
2. **指示書読み込み回避**: 指示書の存在を確認するだけで、実際に読み込んで内容に従わない

## 📋 現状分析

### 問題の根本原因

1. **ワークフロー制約の副作用**
   ```bash
   # scripts/checkpoint.sh の311行目
   if [ "$instruction_count" -eq 0 ]; then
       echo "❌ Error: ワークフロー違反 - 指示書が使用されていません"
       # ...推奨指示書リストに system/ も含まれている
   ```

2. **指示書階層の曖昧性**
   - `ROOT_INSTRUCTION.md`：本来はタスク分析→指示書選択の役割
   - 現状：それ自体が「指示書」として使用可能になってしまっている
   - AIは制約を満たすため、最も簡単なシステム指示書を選択

3. **推奨リストの問題**
   ```bash
   # checkpoint.sh 322-325行目
   echo "  - instructions/ja/system/ROOT_INSTRUCTION.md"      # ← システム指示書
   echo "  - instructions/ja/presets/web_api_production.md"  # ← 業務指示書
   echo "  - instructions/ja/presets/cli_tool_basic.md"      # ← 業務指示書
   ```

4. **指示書使用の形式的遵守**
   - `instruction-start`コマンドを実行するだけで制約を満たす
   - 実際に指示書を読み込んで内容に従うことが強制されていない

## 🎯 対応案

### 案1: システム指示書の除外 + 指示書読み込み強制（推奨）
**説明**: ワークフロー制約の推奨リストからシステム指示書を除外し、指示書読み込みを強制

**メリット**:
- 即座に実装可能
- AIが業務指示書を使用し、実際に読み込むことを強制

**変更内容**:
```bash
# scripts/checkpoint.sh の推奨リスト
echo "$MSG_RECOMMENDED_INST"
echo "  - instructions/ja/presets/web_api_production.md"
echo "  - instructions/ja/presets/cli_tool_basic.md" 
echo "  - instructions/ja/presets/data_analyst.md"
echo "  - instructions/ja/system/MODULE_COMPOSER.md"  # モジュラーシステムのみ残す
echo ""
echo "⚠️  指示書を指定した後、必ずその指示書を読み込んでください："
echo "   Read \"/path/to/instruction.md\""
```

### 案2: 指示書カテゴリ制約 + 読み込み検証
**説明**: 指示書のカテゴリを判定し、システム指示書をワークフロー制約から除外、読み込みログも記録

**実装**:
```bash
# 指示書パスがsystem/の場合は業務指示書として認めない
is_system_instruction() {
    local inst_path="$1"
    case "$inst_path" in
        *"/system/"*) return 0 ;;  # システム指示書
        *) return 1 ;;             # 業務指示書
    esac
}

# 指示書読み込み記録機能
instruction-read() {
    local inst_path="$1"
    local task_id="$2"
    echo "[$TIMESTAMP] [$task_id] [INSTRUCTION_READ] $inst_path" >> "$CHECKPOINT_LOG"
}
```

### 案3: 二段階ワークフロー制約 + 読み込み必須化
**説明**: システム指示書と業務指示書を分離した二段階制約、各段階で読み込みを必須化

**設計**:
1. Phase 1: システム指示書での要件分析（必須、読み込み必須）
2. Phase 2: 業務指示書での実装（progressコマンドの制約対象、読み込み必須）

### 案4: ROOT_INSTRUCTION.mdの役割明確化 + 読み込み指示強化
**説明**: ROOT_INSTRUCTION.mdを「指示書セレクター」として再定義し、選択後の読み込みを強制

**変更内容**:
- ファイル名変更: `ROOT_INSTRUCTION.md` → `INSTRUCTION_SELECTOR.md`
- 内容を「指示書選択のみ」に限定
- 選択後の読み込みを明示的に指示
- ワークフロー制約から除外

**INSTRUCTION_SELECTOR.mdの新しい構造**:
```markdown
## 必須手順
1. タスク分析
2. 適切な指示書を選択
3. **必ずその指示書を読み込む（Read tool使用）**
4. 読み込んだ指示書の内容に従って作業実行
5. instruction-start/instruction-complete でログ記録
```

### 案5: checkpoint.shに読み込み検証機能追加
**説明**: checkpoint.shに指示書が実際に読み込まれたかを検証する機能を追加

**実装**:
```bash
# 新しいサブコマンド
instruction-verify() {
    local inst_path="$1"
    local task_id="$2"
    
    # AI_INSTRUCTION_READ環境変数で読み込み状況を確認
    if [ -z "$AI_INSTRUCTION_READ" ] || [ "$AI_INSTRUCTION_READ" != "$inst_path" ]; then
        echo "❌ Error: 指示書 '$inst_path' が読み込まれていません"
        echo "必ず以下を実行してください:"
        echo "   Read \"$inst_path\""
        exit 1
    fi
}
```

## 💡 推奨解決策

**短期対応（案1）+ 中長期対応（案4 + 案5）の組み合わせ**

### Phase 1: 即座対応
1. checkpoint.shの推奨リストからシステム指示書を除外
2. MODULE_COMPOSERのみをシステム系で残す（生成機能として）
3. 指示書指定後の読み込み指示を強化

### Phase 2: 根本解決
1. `ROOT_INSTRUCTION.md` → `INSTRUCTION_SELECTOR.md` にリネーム
2. CLAUDE.mdの指示を更新
3. 指示書の役割を明確化
4. 読み込み検証機能の追加

### Phase 3: 強化対応
1. checkpoint.shに読み込み検証機能を実装
2. 環境変数による読み込み状況の追跡

## 📊 期待効果

1. **AIの適切な指示書使用**
   - プリセット指示書の活用率向上
   - モジュラーシステムの活用率向上
   - **指示書の実際の読み込みと内容遵守**

2. **ワークフロー制約の本来目的達成**
   - 業務指示書使用の強制
   - **指示書内容の確実な実行**
   - タスク品質の向上

3. **システム設計の明確化**
   - システム指示書と業務指示書の分離
   - 責任範囲の明確化
   - **指示書使用プロセスの透明化**

## 🛠️ 実装優先度

| 案 | 優先度 | 工数 | 影響範囲 | 読み込み強制 |
|---|--------|------|----------|-------------|
| 案1 | 🔥 最高 | 1時間 | checkpoint.sh のみ | ✅ 指示メッセージ |
| 案4 | 🔥 高 | 2時間 | ROOT_INSTRUCTION.md, CLAUDE.md | ✅ 構造的強制 |
| 案5 | 🔶 中 | 3時間 | checkpoint.sh | ✅ 技術的検証 |
| 案2 | 🔶 中 | 4時間 | checkpoint.sh の大幅修正 | ✅ ログ記録 |
| 案3 | 🔶 低 | 8時間 | システム全体の再設計 | ✅ 段階的強制 |

## 🏷️ ラベル
- `bug` - 意図しない動作
- `workflow` - ワークフロー関連
- `priority-critical` - 最重要
- `system-design` - システム設計
- `instruction-compliance` - 指示書遵守