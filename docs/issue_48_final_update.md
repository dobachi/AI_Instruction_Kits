# Issue #48: setup-project.shスクリプトの複雑性改善

## 問題の概要

現在の`setup-project.sh`スクリプトは大量のファイルリンク処理により煩雑になっており（1107行）、保守性と可読性に問題があります。

## 現状の問題点

### 1. シンボリックリンク処理の大量重複（439-972行）
以下のスクリプトファイルで同一パターンの処理を繰り返し：
- `checkpoint.sh` (439-470行)
- `scripts/lib` (782-812行) 
- `commit.sh` (814-844行)
- `generate-instruction.sh` (846-876行)
- `validate-modules.sh` (878-908行)
- `search-instructions.sh` (910-940行)
- `generate-metadata.sh` (942-972行)

### 2. AI製品別リンク処理の冗長性（582-649行）
`CLAUDE.md`, `GEMINI.md`, `CURSOR.md`（および英語版）で同じパターンの処理を個別実装

### 3. スクリプトサイズの問題
- 総行数：1107行（保守困難）
- 同一処理の重複が533行以上

### 4. バックアップ・確認処理の重複
各ファイル処理箇所で同じパターンのバックアップ・確認処理を重複実装

## 改善案の比較

### 案1: 配列+ループ統合 ⭐⭐⭐⭐
**実装期間**: 1-2日  
**コード削減**: 533行 → 150行程度（70%削減）

```bash
# 設定を配列で定義
declare -a SYMLINKS=(
    "scripts/checkpoint.sh:../instructions/ai_instruction_kits/scripts/checkpoint.sh"
    "scripts/commit.sh:../instructions/ai_instruction_kits/scripts/commit.sh"
    # ...
)

# 統一された処理関数
create_symlink() {
    local target="$1" source="$2"
    # バックアップ・確認・リンク作成の統一処理
}

# ループ処理で一括実行
for link in "${SYMLINKS[@]}"; do
    target="${link%%:*}" source="${link##*:}"
    create_symlink "$target" "$source"
done
```

**メリット**:
- 最小変更でのリスク最小化
- 即座に実装可能
- 既存テストケース完全保持
- バグ修正が一箇所で済む

**デメリット**:
- 根本的な設計改善は限定的
- i18n処理の重複は残存

### 案2: 設定ファイル分離 ⭐⭐
**実装期間**: 1-2週間

YAML設定ファイルでデータ駆動化。外部依存（yq）が必要でPOSIX準拠から逸脱。

### 案3: モジュール分割 ⭐⭐⭐
**実装期間**: 3-5日

責務別にスクリプト分割（`setup-core.sh`, `setup-symlinks.sh`, `setup-openhands.sh`）。保守性向上だがファイル数増加。

### 案4: テンプレート自動生成 ⭐
**実装期間**: 2-3週間

メタデータ駆動の自動生成。オーバーエンジニアリングでデバッグ困難。

### 案5: ハイブリッド（推奨案） ⭐⭐⭐⭐⭐
**実装期間**: 5-7日

配列統合 + 部分的モジュール分離の組み合わせ：

```bash
source "$(dirname "$0")/lib/setup-config.sh"

setup_directories
setup_instruction_files  
setup_symlinks_batch     # ←配列で一括処理
setup_ai_products       # ←ループで統合
setup_openhands
```

**メリット**:
- 最も効果的な部分を優先改善
- 段階的実装でリスク分散
- 将来的な拡張性保持
- 学習曲線が緩やか

## 推奨実装計画

### Phase 1: 配列統合（案1） - 1-2日
1. シンボリックリンク設定の配列化
2. 統一処理関数の実装
3. AI製品リンクのループ化
4. 既存テストでの動作確認

**期待効果**: コード量70%削減、保守性大幅向上

### Phase 2: 部分モジュール化（案5への発展） - 3-5日
1. 設定部分の分離（`lib/setup-config.sh`）
2. 処理関数のグループ化
3. エラーハンドリングの統一

**期待効果**: 責務明確化、テスタビリティ向上

## 実装優先度

1. **第1優先**: 案5（ハイブリッド） - 最適なバランス
2. **第2優先**: 案1（配列+ループ） - 迅速な改善が必要な場合
3. **第3優先**: 案3（モジュール分割） - 長期保守性重視

## 期待される効果

- **可読性**: スクリプト長50%以上削減
- **保守性**: 重複コード削除によるバグ修正の一元化
- **拡張性**: 新しいスクリプト追加が容易
- **テスタビリティ**: 分離された処理の個別テスト可能

## リスク評価

- **低リスク**: 案1（既存動作完全保持）
- **中リスク**: 案3, 案5（段階的移行可能）
- **高リスク**: 案2, 案4（大幅変更、外部依存）

## 関連ファイル

- `scripts/setup-project.sh` (メインターゲット)
- `scripts/lib/i18n.sh` (i18n処理)
- `templates/` (テンプレートファイル群)

---

**Labels**: enhancement, refactoring, maintenance
**Assignee**: @dobachi
**Priority**: Medium
**Estimated**: 1-2 weeks (Phase 1 + Phase 2)