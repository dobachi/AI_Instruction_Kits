# モジュラーシステムのファイル名規則改訂仕様

## 概要

モジュラーシステムにおける簡潔版/詳細版のファイル命名規則を、より直感的で効率的な構造に改訂する。

## 現状の問題点

現在の実装では以下の命名規則を採用している：
- `module_name.md` - 詳細版（フルバージョン）
- `module_name_concise.md` - 簡潔版

しかし、デフォルトで簡潔版を使用するという設計思想と矛盾している。

## 新しい仕様

### ファイル命名規則

```
modules/
├── expertise/
│   ├── machine_learning.md          # 簡潔版（デフォルト）
│   ├── machine_learning_detailed.md # 詳細版
│   └── machine_learning.yaml        # メタデータ（共通）
```

### 基本原則

1. **デフォルトファイル名は簡潔版**
   - `module_name.md` は常に簡潔版を指す
   - 既存の参照は自動的に簡潔版を使用

2. **詳細版は明示的なサフィックス**
   - `module_name_detailed.md` で詳細版を指定
   - 必要な場合のみ明示的に選択

3. **メタデータは共通**
   - 一つの `.yaml` ファイルで両バージョンを管理
   - バージョン情報を含む

### メタデータ構造の更新

```yaml
# machine_learning.yaml
name: machine_learning
category: expertise
description: 機械学習とAIの専門知識

# バージョン情報
versions:
  concise:
    default: true
    file: machine_learning.md
    size_estimate: 10KB
    token_estimate: 2500
  detailed:
    file: machine_learning_detailed.md
    size_estimate: 35KB
    token_estimate: 8500

# 共通の変数定義など
variables:
  - name: ml_task
    # ...
```

### システム動作

#### デフォルト動作
```bash
# 簡潔版を使用（ファイル名にサフィックスなし）
./scripts/generate-instruction.sh --modules expertise_machine_learning
# → machine_learning.md を読み込む
```

#### 詳細版の使用
```bash
# --verboseフラグで詳細版を使用
./scripts/generate-instruction.sh --modules expertise_machine_learning --verbose
# → machine_learning_detailed.md を読み込む
```

## 移行戦略

### Phase 1: 仕様確定（現在）
- ファイル命名規則の決定
- メタデータ構造の設計
- 実装計画の作成

### Phase 2: 段階的移行
1. 新規モジュールは新仕様で作成
2. 既存モジュールの段階的移行
   - 現在の詳細版を `_detailed.md` にリネーム
   - 簡潔版を標準ファイル名に移動
3. composer.pyのロジック更新

### Phase 3: 完全移行
- すべてのモジュールを新仕様に統一
- ドキュメントの更新
- 旧仕様のサポート終了

## 利点

1. **直感的な構造**
   - デフォルトのファイル名で最も使用頻度の高い簡潔版を取得
   - 特別な要求（詳細版）には特別なサフィックス

2. **後方互換性の向上**
   - 既存のモジュール参照は自動的に簡潔版を使用
   - 段階的な移行が可能

3. **効率性**
   - トークン効率を重視したデフォルト動作
   - 必要に応じて詳細版を選択可能

4. **保守性**
   - ファイル名から用途が明確
   - メタデータの一元管理

## 実装への影響

### composer.py
- ファイル探索ロジックの変更
  - 現在: 簡潔版を先に探す → 詳細版
  - 新仕様: デフォルトを読む → verboseなら詳細版

### generate-instruction.sh
- 変更なし（--verboseフラグの動作は同じ）

### 既存モジュール
- ファイル名の変更が必要
- メタデータの更新

## リスクと対策

### リスク
1. 既存システムへの影響
2. 移行期間中の混乱
3. ドキュメントの不整合

### 対策
1. 段階的な移行計画
2. 移行期間中は両方式をサポート
3. 包括的なテストとドキュメント更新

## 実装計画

### 優先度と順序

1. **Phase 1: 準備とテスト**（今回実施）
   - [ ] composer.pyのロジック修正
   - [ ] ファイル探索の新しいロジックをテスト
   - [ ] 移行スクリプトの作成

2. **Phase 2: パイロット実装**
   - [ ] machine_learningモジュールで実施
     - 現在の `machine_learning.md` → `machine_learning_detailed.md`
     - 現在の `machine_learning_concise.md` → `machine_learning.md`
   - [ ] 動作確認とテスト

3. **Phase 3: 段階的展開**
   - [ ] 他のexpertiseモジュールへ適用
   - [ ] ドキュメントの更新
   - [ ] ユーザーへの通知

### 技術的変更点

#### composer.py の変更

**現在のロジック:**
```python
if self.use_concise:
    concise_path = self.modules_dir / category / f"{file_name}_concise.md"
    if concise_path.exists():
        module_path = concise_path
    else:
        module_path = self.modules_dir / category / f"{file_name}.md"
```

**新しいロジック:**
```python
if self.use_concise:
    # デフォルトパス（簡潔版）
    module_path = self.modules_dir / category / f"{file_name}.md"
else:
    # 詳細版を探す
    detailed_path = self.modules_dir / category / f"{file_name}_detailed.md"
    if detailed_path.exists():
        module_path = detailed_path
    else:
        # 詳細版がない場合はデフォルトを使用（後方互換性）
        module_path = self.modules_dir / category / f"{file_name}.md"
```

#### 移行スクリプト

```bash
#!/bin/bash
# migrate_module_files.sh

# 対象モジュールのパス
MODULE_PATH="$1"
MODULE_NAME=$(basename "$MODULE_PATH" .md)
MODULE_DIR=$(dirname "$MODULE_PATH")

# ファイルの存在確認
if [ -f "${MODULE_DIR}/${MODULE_NAME}_concise.md" ]; then
    # バックアップ作成
    cp "${MODULE_PATH}" "${MODULE_PATH}.backup"
    
    # ファイル移動
    mv "${MODULE_PATH}" "${MODULE_DIR}/${MODULE_NAME}_detailed.md"
    mv "${MODULE_DIR}/${MODULE_NAME}_concise.md" "${MODULE_PATH}"
    
    echo "Migrated: ${MODULE_NAME}"
else
    echo "Skipped: ${MODULE_NAME} (no concise version found)"
fi
```

## 結論

この新しい命名規則により、モジュラーシステムはより直感的で効率的になり、デフォルトでトークン効率を重視する設計思想と一致する。

---

関連Issue: #35
作成日: 2025-01-21
作成者: AI Instruction Kits Project