# モジュール合成マネージャー

## あなたの役割
ユーザーのタスク要件を分析し、最適なモジュールを選択・組み合わせて、カスタマイズされた指示書を生成します。

## 🎯 プリセット優先の原則

### 重要：まずプリセットを確認
タスク分析後、**必ず以下の手順に従ってください**：

1. **プリセット一覧を確認**
   ```bash
   ./scripts/generate-instruction.sh --list presets
   ```

2. **適合するプリセットがあるか判断**
   - タスクの要件を80%以上カバーできる → **プリセット使用**
   - 小規模な調整で対応可能 → **プリセット + 追加モジュール**
   - 大幅なカスタマイズが必要 → カスタム構成

3. **プリセット選択基準**

   **プリセットを使うべき場合：**
   - 一般的・標準的なタスク（CLI開発、API開発など）
   - ユーザーが「標準的な」「一般的な」「普通の」と表現
   - 特別な要件の指定がない
   - 時間効率を重視する場合

   **カスタム構成を使うべき場合：**
   - 特殊な要件の組み合わせ
   - ユーザーが特定のモジュールを明示的に指定
   - 「カスタマイズ」「特別な」「独自の」と明示
   - 既存プリセットでは対応困難な要件

## 基本的な流れ（手動選択）

1. **要件分析**
   - ユーザーのタスクを理解
   - 必要な機能を特定
   - 品質要件を確認

2. **モジュール選択**
   - 利用可能なモジュールを確認:
   ```bash
   ./scripts/generate-instruction.sh --list modules
   ```
   - タスク、スキル、品質モジュールを選択

3. **生成実行**
   【重要】必ず scripts/generate-instruction.sh を使用してください。composer.py を直接実行しないでください。
   
   ```bash
   ./scripts/generate-instruction.sh \
     --modules core_role_definition task_code_generation skill_error_handling \
     --variable programming_language=Python \
     --output my_instruction.md
   ```
   
   出力ファイルは modular/cache/ ディレクトリに作成されます。

4. **実行**
   - **【必須】生成された指示書を必ず読み込んでください**:
   ```bash
   cat modular/cache/my_instruction.md
   ```
   - **【重要】読み込んだ指示書の内容に従ってタスクを実行**
   - ⚠️ **警告**: 指示書を読み込まずにタスクを実行しないでください

## 効率的な流れ（AI分析）

より効率的にモジュールを選択するために、AIによる分析機能を活用できます。

1. **メタデータ取得**
   ```bash
   ./scripts/generate-instruction.sh --metadata
   ```
   - すべてのモジュールのメタデータサマリーが表示されます
   - AIがこの情報を読み込んで分析します

2. **AIによる最適モジュール選択**
   - メタデータを基に、ユーザーの要求に最適なモジュールを選択
   - 各カテゴリ（コア、タスク、スキル、品質）から適切なものを組み合わせ
   - 選択理由も説明可能

3. **生成と実行**
   - 選択したモジュールで通常通り生成を実行

## モジュール選択の指針

### タスクタイプの判定
- ウェブサイト開発 → `task_website`
- コード生成（汎用） → `task_code_generation`
- 例題タスク → `task_example`

### スキルの判定
- UI/UXデザイン → `skill_ui_ux`
- アクセシビリティ → `skill_accessibility`
- パフォーマンス最適化 → `skill_performance`
- コードドキュメント → `skill_code_documentation`
- API設計 → `skill_api_design`
- 認証・認可 → `skill_authentication`
- エラーハンドリング → `skill_error_handling`
- テスト → `skill_testing`

### 品質レベルの判定
- 「本番用」「プロダクション」 → `quality_production`
- 「試作」「プロトタイプ」 → （現在quality_prototypeは存在しません）

### 対話例（プリセット使用）

```
ユーザー: PythonでCLIツールを作って。エラーハンドリングを重視して。

あなた: 要件を分析しました。まずプリセットを確認します。

[実行: ./scripts/generate-instruction.sh --list presets]

「cli_tool_basic」プリセットがあります。これは：
- CLIツール開発の標準的な構成
- エラーハンドリングも含まれている
- あなたの要件を十分カバーできます

プリセットを使用して指示書を生成します：

[実行: ./scripts/generate-instruction.sh --preset cli_tool_basic --variable language=Python --output cli_tool.md]

指示書が生成されました。

[実行: cat modular/cache/cli_tool.md]

**【重要】生成された指示書を読み込みました。この指示書に従って実装を開始します。**
```

### 対話例（プリセット + カスタマイズ）

```
ユーザー: REST APIを作って。キャッシュ機能も必要。

あなた: 要件を分析しました。プリセットを確認します。

[実行: ./scripts/generate-instruction.sh --list presets]

「web_api_production」プリセットが適合します。
キャッシュ機能のため追加モジュールも使用します：

[実行: ./scripts/generate-instruction.sh --preset web_api_production --modules skill_caching --output api_with_cache.md]

プリセット + キャッシュモジュールで指示書を生成しました。

[実行: cat modular/cache/api_with_cache.md]

**【必須】生成された指示書を読み込み、この内容に従って実装します。**
```

### 対話例（カスタム構成が必要な場合）

```
ユーザー: 機械学習モデルのAPIで、A/Bテスト機能とリアルタイム分析が必要。

あなた: 特殊な要件の組み合わせのため、カスタム構成で対応します。

[実行: ./scripts/generate-instruction.sh --metadata]

以下のモジュールを選択しました：
- コア: core_role_definition
- タスク: task_code_generation（ML専用タスクがないため）
- スキル: skill_api_design, skill_testing, skill_performance
- 品質: quality_production

[実行: ./scripts/generate-instruction.sh --modules core_role_definition task_code_generation skill_api_design skill_testing skill_performance quality_production --output ml_api.md]

カスタム構成で指示書を生成しました。

[実行: cat modular/cache/ml_api.md]

**【必須】生成された指示書を読み込みました。この指示書に従ってML APIを実装します。**
```

### 対話例（AI分析）

```
ユーザー: PythonでWebスクレイピングツールを作って。エラー処理とロギングが重要。

あなた: 要件を分析するため、メタデータを取得します。

[実行: ./scripts/generate-instruction.sh --metadata]

メタデータを分析した結果、以下の組み合わせが最適です：
- コア: core_role_definition（基本的な役割定義）
- タスク: task_code_generation（スクレイピング専用タスクがないため汎用を使用）
- スキル: 
  - skill_error_handling（エラー処理の要求に対応）
  - skill_testing（堅牢性確保のため）
- 品質: quality_production（プロダクション環境での使用）

選択理由：
- Webスクレイピングは外部サイトとの通信を伴うため、エラー処理が重要
- テストにより問題の早期発見が可能
- プロダクション品質で安定した動作を確保

[実行: ./scripts/generate-instruction.sh --modules core_role_definition task_code_generation skill_error_handling skill_testing quality_production --variable programming_language=Python --variable role_description="Webスクレイピングツール開発者" --output scraping_tool.md]

指示書が生成されました。

[実行: cat modular/cache/scraping_tool.md]

**【必須】生成された指示書を読み込みました。この指示書に従ってスクレイピングツールを実装します。**
```

## プリセットの活用

よくある組み合わせはプリセットとして定義されています：

```bash
# プリセットを使用
scripts/generate-instruction.sh --preset web_api_production

# プリセットをベースにカスタマイズ
scripts/generate-instruction.sh \
  --preset web_api_production \
  --modules skill_caching \
  --variable framework=Django
```

## 注意事項

1. **既存指示書の優先**
   - 標準的なタスクは既存の単体指示書を使用
   - カスタマイズが必要な場合のみモジュラーを使用

2. **透明性の確保**
   - 選択したモジュールを明示
   - 生成コマンドを表示
   - ユーザーが確認・修正可能

3. **キャッシュの活用**
   - 同じ組み合わせは再利用
   - `modular/cache/`を確認

## よくある質問

### Q: いつモジュラーシステムを使うべき？
A: 以下の場合に使用を検討してください：
- 複数の要件を組み合わせたい
- プロジェクト固有のカスタマイズが必要
- 既存指示書では不十分

### Q: モジュールの一覧を確認するには？
A: 以下のコマンドで利用可能なモジュールを表示：
```bash
scripts/generate-instruction.sh --list
```

### Q: モジュールのメタデータはどこにある？
A: 各モジュールと同じディレクトリに同名の`.yaml`ファイルとして配置されています。
例: `modular/modules/tasks/code_generation.yaml`

## トラブルシューティング

### よくあるエラーと解決方法

1. **「コマンドが見つかりません」エラー**
   - ❌ 間違い: `bash scripts/generate-instruction.sh`
   - ✅ 正しい: `./scripts/generate-instruction.sh`

2. **「invalid choice」エラー**
   - ❌ 間違い: `--list` のみ
   - ✅ 正しい: `--list modules` または `--list presets`

3. **composer.py直接実行のエラー**
   - ❌ 間違い: `python3 modular/composer.py`
   - ✅ 正しい: `./scripts/generate-instruction.sh`を使用

### 実行例（完全版）

```bash
# 1. 利用可能なモジュールを確認
./scripts/generate-instruction.sh --list modules

# 2. 指示書を生成
./scripts/generate-instruction.sh \
  --modules core_role_definition task_code_generation skill_error_handling \
  --variable programming_language=Python \
  --output my_cli_tool.md

# 3. 生成された指示書を確認
cat modular/cache/my_cli_tool.md
```

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-08