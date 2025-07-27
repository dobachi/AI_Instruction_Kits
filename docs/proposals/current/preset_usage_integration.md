# プリセット利用方法の統合提案

**作成日**: 2025-07-27  
**概要**: 事前生成プリセットの利用方法を統合し、より効率的なシステムを実現

## 現状の問題

### 1. プリセット利用の2つの方法が混在
- **方法A**: 事前生成されたプリセットファイルを直接読み込む（高速）
  - `instructions/ja/presets/web_api_production.md` を直接使用
  - 0秒で開始可能

- **方法B**: シェルスクリプト経由で動的生成（遅い）
  - `./scripts/generate-instruction.sh --preset web_api_production`
  - Pythonスクリプトを呼び出して再生成
  - 数秒～十数秒かかる

### 2. AIの混乱
- ROOT_INSTRUCTIONでは方法Aを推奨
- しかし、generate-instruction.shは方法Bしかサポートしていない
- どちらを使うべきか不明確

## 提案する解決策

### オプション1: `--use-cached` フラグの追加（推奨）

```bash
# 事前生成プリセットを直接使用（新機能）
./scripts/generate-instruction.sh --preset web_api_production --use-cached
# → instructions/ja/presets/web_api_production.md をコピーまたはシンボリックリンク

# 従来通り動的生成
./scripts/generate-instruction.sh --preset web_api_production
# → Pythonで再生成

# デフォルトを事前生成に変更
./scripts/generate-instruction.sh --preset web_api_production
# → デフォルトで --use-cached を有効化
```

### オプション2: 新しいコマンドの追加

```bash
# 新しいコマンド: use-preset.sh
./scripts/use-preset.sh web_api_production
# → instructions/ja/presets/web_api_production.md を modular/cache/ にコピー

# 既存のコマンドは動的生成専用
./scripts/generate-instruction.sh --preset web_api_production
```

### オプション3: スマート判定（最も賢い）

```bash
# generate-instruction.sh を改良
./scripts/generate-instruction.sh --preset web_api_production

# 内部処理:
# 1. instructions/ja/presets/web_api_production.md が存在するか確認
# 2. 存在する場合:
#    - タイムスタンプをチェック
#    - 最新なら事前生成版を使用
#    - 古ければ再生成
# 3. 存在しない場合:
#    - 動的生成
```

## 実装案（オプション3）

```bash
#!/bin/bash
# generate-instruction.sh の改良部分

# プリセット処理の改良
if [[ -n "$PRESET" ]]; then
    PRESET_FILE="instructions/$LANG/presets/${PRESET}.md"
    
    # 事前生成プリセットが存在し、最新の場合
    if [[ -f "$PRESET_FILE" ]]; then
        # モジュールのタイムスタンプと比較
        PRESET_TIME=$(stat -c %Y "$PRESET_FILE" 2>/dev/null || stat -f %m "$PRESET_FILE")
        NEEDS_REGEN=false
        
        # 関連モジュールの更新チェック（簡易版）
        # 実際にはプリセット定義ファイルから依存モジュールを取得
        for module_file in modular/modules/*/*.md; do
            if [[ -f "$module_file" ]]; then
                MODULE_TIME=$(stat -c %Y "$module_file" 2>/dev/null || stat -f %m "$module_file")
                if [[ $MODULE_TIME -gt $PRESET_TIME ]]; then
                    NEEDS_REGEN=true
                    break
                fi
            fi
        done
        
        if [[ "$NEEDS_REGEN" = false ]]; then
            # 事前生成版を使用
            if [[ -n "$OUTPUT_FILE" ]]; then
                cp "$PRESET_FILE" "$OUTPUT_FILE"
                echo "✅ 事前生成プリセットを使用: $PRESET_FILE → $OUTPUT_FILE"
            else
                OUTPUT_FILE="modular/cache/${PRESET}_$(date +%Y%m%d_%H%M%S).md"
                cp "$PRESET_FILE" "$OUTPUT_FILE"
                echo "✅ 事前生成プリセットを使用: $PRESET_FILE → $OUTPUT_FILE"
            fi
            exit 0
        else
            echo "⚠️ モジュールが更新されているため、プリセットを再生成します"
        fi
    fi
    
    # 既存の動的生成処理...
fi
```

## メリット

### 1. パフォーマンス向上
- 通常のプリセット使用: 0秒（コピーのみ）
- 更新が必要な場合のみ: 数秒（再生成）

### 2. 後方互換性
- 既存のコマンドラインインターフェースを維持
- 既存のワークフローに影響なし

### 3. 自動最適化
- ユーザーが意識せずに最適な方法を使用
- 常に最新の内容を保証

## 実装手順

1. **generate-instruction.sh の改良**
   - プリセットファイル存在チェック
   - タイムスタンプ比較ロジック
   - 事前生成版の使用ロジック

2. **ドキュメント更新**
   - README.md に統合された使用方法を記載
   - ROOT_INSTRUCTION.md の説明を簡潔に

3. **テスト**
   - 事前生成版の使用
   - 更新検出と再生成
   - エラーハンドリング

## まとめ

オプション3（スマート判定）を推奨します。これにより：
- AIは単に `generate-instruction.sh --preset` を使うだけ
- 自動的に最適な方法（事前生成 or 動的生成）を選択
- ユーザーとAIの両方にとってシンプル