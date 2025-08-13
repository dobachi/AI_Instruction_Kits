# AI指示書システム - 不要ファイル削除提案

## 概要
AI指示書システムに蓄積された不要と思われるファイルを調査しました。
以下のカテゴリに分けて削除候補をリストアップしています。

**重要**: 削除前に必ず確認をお願いします。特にGit管理下のファイルは慎重に判断してください。

## 削除候補ファイル

### 1. テスト・一時ファイル（ルートディレクトリ）
これらのファイルはテスト実行時に作成されたもので、Git管理下にあります。

```bash
# テスト関連ファイル（Git管理下）
test_modular_integration.md
test_data_analyst_after.md  
test_business_consultant_after.md
test_business_consultant_after2.md

# Issue作業時の一時ファイル（Git管理下）
issue_checkpoint_summary.md
issue_checkpoint_system_instruction_overuse.md
```

### 2. バックアップディレクトリ
古いバージョンのバックアップが残っています。

```bash
# modularシステムの古いバックアップ（Git管理下）
modular/backup_20250712_234723/  # 2025年7月12日のバックアップ
modular/ja/modules_backup_20250723_021641/  # 2025年7月23日のバックアップ
```

### 3. ログ・一時ファイル
作業ログファイルが残っています。

```bash
# ログファイル（Git管理下）
naming_fix_log.txt
naming_fix_safe_log.txt
docs/development/en_module_preparation_log.txt

# チェックポイントログ（.gitignoreで無視）
checkpoint.log
checkpoint.log.lock
```

### 4. キャッシュファイル（.gitignoreで無視）
modular/cache/配下の生成済みファイル。これらは既に.gitignoreで無視されています。
-> キャッシュは残しておいて。

```bash
modular/cache/*.md  # 全てのキャッシュファイル（約40ファイル）
-> キャッシュは残しておいて。
```

### 5. 廃止予定ファイル
既に使用されていない設定ファイル。

```bash
modular/catalog.yaml.deprecated  # 廃止された設定ファイル（Git管理下）
```

### 6. 重複・不要なファイル
モジュールシステムの移行作業で生成された不要なファイル。

```bash
# *_concise.mdファイル（バックアップディレクトリ内、約30ファイル）
modular/ja/modules_backup_20250723_021641/**/*_concise.md

# *_detailed.mdファイル（現行のモジュール内）
modular/ja/modules/**/*_detailed.md
modular/en/modules/**/*_detailed.md
```

## 推奨削除順序

### Phase 1: 安全に削除可能（即座に削除可）
1. `.gitignore`で既に無視されているファイル
   - `modular/cache/`内のすべてのファイル
   - `checkpoint.log`, `checkpoint.log.lock`

### Phase 2: 確認後削除（Git管理下）
2. テスト関連ファイル（ルート）
   - `test_*.md`ファイル
   - `issue_*.md`ファイル

3. ログファイル
   - `naming_fix_log.txt`
   - `naming_fix_safe_log.txt`
   - `docs/development/en_module_preparation_log.txt`

### Phase 3: 慎重に検討（大量のファイル）
4. バックアップディレクトリ
   - `modular/backup_20250712_234723/`
   - `modular/ja/modules_backup_20250723_021641/`

5. 廃止ファイル
   - `modular/catalog.yaml.deprecated`

## 削除コマンド例

```bash
# Phase 1: キャッシュファイルの削除（安全）
rm -f modular/cache/*.md
rm -f checkpoint.log checkpoint.log.lock

# Phase 2: テスト・ログファイルの削除（確認後）
git rm test_*.md
git rm issue_*.md
git rm naming_fix_log.txt naming_fix_safe_log.txt
git rm docs/development/en_module_preparation_log.txt

# Phase 3: バックアップディレクトリの削除（慎重に）
git rm -r modular/backup_20250712_234723/
git rm -r modular/ja/modules_backup_20250723_021641/
git rm modular/catalog.yaml.deprecated
```

## 注意事項

1. **Git管理下のファイル**: `git rm`を使用して削除し、コミットが必要
2. **大量削除**: バックアップディレクトリは多数のファイルを含むため、削除前に内容確認推奨
3. **ログファイル**: 問題調査に必要な可能性があるため、削除前に内容確認推奨

## 削除効果

- **ファイル数削減**: 約200ファイル以上
- **ディスク容量**: 数MB程度の削減
- **プロジェクト構造**: より整理された状態に

ご確認をお願いします。削除を進める場合は、Phase毎に実行することをお勧めします。
