# AI主導モジュラーシステム実装計画書

**作成日**: 2025-01-08  
**Issue**: [#2 指示書のモジュラライズとテンプレートシステムの導入](https://github.com/dobachi/AI_Instruction_Kits/issues/2)  
**バージョン**: 1.0

## 1. エグゼクティブサマリー

本計画書は、既存の単体指示書システムを維持しながら、AIが対話的にモジュールを選択・組み合わせて最適な指示書を生成する「AI主導モジュラーシステム」の実装計画を示します。

### 核心コンセプト
- **既存システムの完全維持** - 単体指示書はそのまま利用可能
- **AI主導の動的生成** - AIが要件を分析してモジュールを選択
- **透明性とシンプルさ** - 生成プロセスが可視化され、理解しやすい
- **段階的採用** - 必要に応じて徐々に高度な機能を活用

## 2. システム設計

### 2.1 全体アーキテクチャ

```
AI_Instruction_Kits/
├── instructions/              # 既存の単体指示書（維持）
│   ├── ja/
│   │   └── system/
│   │       └── MODULE_COMPOSER.md  # AI用モジュール選択指示書（新規）
│   └── en/
│
├── modular/                   # モジュラーシステム（新規）
│   ├── catalog.yaml          # モジュールカタログ
│   ├── modules/              # モジュール本体
│   │   ├── core/            # 基本構造
│   │   ├── tasks/           # タスク別モジュール
│   │   ├── skills/          # スキル別モジュール
│   │   └── quality/         # 品質関連モジュール
│   ├── templates/            # プリセットテンプレート
│   ├── composer.py           # モジュール合成エンジン
│   └── cache/               # 生成結果のキャッシュ
│
└── scripts/
    ├── generate-instruction.sh  # 指示書生成スクリプト
    └── validate-modules.sh      # モジュール検証スクリプト
```

### 2.2 モジュールカタログ設計

```yaml
# modular/catalog.yaml
version: "1.0"
modules:
  # タスクモジュール（何をするか）
  tasks:
    web_api_development:
      id: "task_web_api"
      description: "RESTful Web API開発の基本構造"
      tags: ["api", "web", "backend"]
      compatible_skills: ["error_handling", "validation", "authentication"]
      variables:
        - framework: "使用するフレームワーク名"
        - database: "データベースタイプ"
    
    cli_tool_development:
      id: "task_cli"
      description: "CLIツール開発の基本構造"
      tags: ["cli", "tool", "command-line"]
      compatible_skills: ["argument_parsing", "output_formatting"]
  
  # スキルモジュール（どのように実装するか）
  skills:
    test_driven_development:
      id: "skill_tdd"
      description: "テスト駆動開発の実践"
      tags: ["testing", "quality", "tdd"]
      enhances: ["code_quality", "maintainability"]
      requires_base: true
    
    error_handling:
      id: "skill_error_handling"
      description: "堅牢なエラーハンドリング"
      tags: ["error", "exception", "robustness"]
      language_specific: true
  
  # 品質モジュール（どの程度の品質で実装するか）
  quality:
    production_ready:
      id: "quality_production"
      description: "本番環境対応の品質基準"
      includes: ["logging", "monitoring", "security"]
      
    prototype:
      id: "quality_prototype"
      description: "プロトタイプ向けの簡易実装"
      focus: ["speed", "flexibility"]

# プリセット定義
presets:
  web_api_production:
    name: "本番用Web API開発"
    modules: ["task_web_api", "skill_tdd", "skill_error_handling", "quality_production"]
    
  quick_cli_tool:
    name: "簡易CLIツール"
    modules: ["task_cli", "quality_prototype"]
```

### 2.3 MODULE_COMPOSER指示書

```markdown
# instructions/ja/system/MODULE_COMPOSER.md

# モジュール合成マネージャー

## あなたの役割
ユーザーのタスク要件を分析し、最適なモジュールを選択・組み合わせて、カスタマイズされた指示書を生成します。

## 基本的な流れ

1. **要件分析**
   - ユーザーのタスクを理解
   - 必要な機能を特定
   - 品質要件を確認

2. **モジュール選択**
   - `modular/catalog.yaml`を参照
   - タスク、スキル、品質モジュールを選択
   - 互換性を確認

3. **生成実行**
   ```bash
   scripts/generate-instruction.sh \
     --modules [選択したモジュール] \
     --variables [必要な変数] \
     --output [出力先]
   ```

4. **実行**
   - 生成された指示書を読み込み
   - タスクを実行

## モジュール選択の指針

### タスクタイプの判定
- Web開発 → `task_web_api`
- CLI開発 → `task_cli`
- データ分析 → `task_data_analysis`
- ドキュメント作成 → `task_documentation`

### 品質レベルの判定
- 「本番用」「プロダクション」 → `quality_production`
- 「試作」「プロトタイプ」 → `quality_prototype`
- 「高品質」「テスト重視」 → `skill_tdd`を追加

### 対話例

```
ユーザー: PythonでREST APIを作って。本番環境で使うので品質重視で。

あなた: 要件を分析しました。以下のモジュールで指示書を生成します：
- タスク: task_web_api (REST API開発)
- スキル: skill_tdd (テスト駆動開発)
- スキル: skill_error_handling (エラーハンドリング)
- 品質: quality_production (本番環境対応)

変数設定:
- framework: FastAPI
- database: PostgreSQL

生成を実行します...
[scripts/generate-instruction.sh を実行]

指示書が生成されました。これに従って実装を開始します。
```

## プリセットの活用

よくある組み合わせはプリセットとして定義されています：

```bash
# プリセットを使用
scripts/generate-instruction.sh --preset web_api_production

# プリセットをベースにカスタマイズ
scripts/generate-instruction.sh \
  --preset web_api_production \
  --add-module skill_caching \
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

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-08
```

## 3. 使用方法ガイド

### 3.1 エンドユーザー（AI利用者）の使い方

#### 基本的な使用フロー

1. **シンプルなタスク（既存指示書を使用）**
   ```
   ユーザー: Pythonで関数を書いて
   AI: instructions/ja/coding/basic_code_generation.md を使用します
   ```

2. **カスタマイズが必要なタスク（モジュラー使用）**
   ```
   ユーザー: 本番用のWeb APIを作って。認証付きで、テストも書いて
   AI: MODULE_COMPOSERを使用してカスタム指示書を生成します
   → モジュール選択 → 生成 → 実行
   ```

3. **明示的なモジュラー指定**
   ```
   ユーザー: モジュラーシステムを使ってCLIツールの指示書を作成して
   AI: MODULE_COMPOSERで要件を分析します
   ```

#### 実際の対話例

```
ユーザー: FastAPIで認証付きのTODO管理APIを作成してください。
        テストも含めて、本番環境で使える品質でお願いします。

AI: 要件を分析しました。カスタム指示書を生成します。

選択モジュール:
✓ task_web_api - Web API開発の基本構造
✓ skill_authentication - 認証実装
✓ skill_tdd - テスト駆動開発
✓ skill_error_handling - エラーハンドリング
✓ quality_production - 本番環境品質

[生成コマンド実行]
scripts/generate-instruction.sh \
  --modules task_web_api skill_authentication skill_tdd \
           skill_error_handling quality_production \
  --variables framework=FastAPI database=PostgreSQL \
  --output cache/todo_api_instruction.md

生成完了。実装を開始します...

[以下、生成された指示書に従って実装]
```

### 3.2 開発者の使い方

#### モジュール追加方法

1. **新しいタスクモジュールの追加**
   ```bash
   # 1. モジュールファイルを作成
   vi modular/modules/tasks/mobile_app_development.md
   
   # 2. カタログに登録
   vi modular/catalog.yaml
   # tasks:セクションに追加
   
   # 3. 検証
   ./scripts/validate-modules.sh
   ```

2. **プリセットの作成**
   ```yaml
   # modular/catalog.yaml のpresets:セクションに追加
   mobile_app_basic:
     name: "モバイルアプリ基本開発"
     modules: ["task_mobile_app", "skill_ui_design", "quality_prototype"]
   ```

#### ローカルでのテスト

```bash
# 手動でモジュール組み合わせをテスト
./scripts/generate-instruction.sh \
  --modules task_web_api skill_tdd \
  --dry-run  # 実際には生成せず、結果をプレビュー

# 生成結果の検証
./scripts/generate-instruction.sh \
  --modules task_web_api skill_tdd \
  --output test_output.md
diff test_output.md expected_output.md
```

## 4. 実装計画

### Phase 1: 基盤構築（1週間）

1. **ディレクトリ構造の作成**
   ```bash
   mkdir -p modular/{modules/{core,tasks,skills,quality},templates,cache}
   touch modular/{catalog.yaml,composer.py}
   ```

2. **基本スクリプトの実装**
   - `generate-instruction.sh`: シンプルなモジュール結合
   - `validate-modules.sh`: 構文チェック

3. **MODULE_COMPOSER.mdの作成**
   - 日本語版・英語版

### Phase 2: コアモジュールの作成（2週間）

1. **基本モジュールの抽出**
   - 既存指示書から共通部分を抽出
   - モジュール化して配置

2. **カタログの構築**
   - 初期モジュールの登録
   - タグとメタデータの整備

3. **基本的なcomposer.pyの実装**
   ```python
   def compose_modules(module_ids, variables=None):
       """モジュールを結合して指示書を生成"""
       content = []
       for module_id in module_ids:
           module_path = find_module_path(module_id)
           content.append(load_module(module_path))
       
       result = "\n\n---\n\n".join(content)
       if variables:
           result = replace_variables(result, variables)
       
       return result
   ```

### Phase 3: プリセットとテスト（1週間）

1. **よく使うプリセットの定義**
   - web_api_production
   - cli_tool_basic
   - data_analysis_notebook

2. **統合テスト**
   - AI（GPT/Claude）での動作確認
   - エッジケースのテスト

3. **ドキュメント作成**
   - 使用ガイド
   - モジュール作成ガイド

### Phase 4: 改善と最適化（1週間）

1. **フィードバック収集と改善**
2. **キャッシュ機能の実装**
3. **パフォーマンス最適化**

## 5. 成功指標

1. **使いやすさ**
   - AIが3ステップ以内でカスタム指示書を生成
   - 生成時間: 5秒以内
   - エラー率: 5%未満

2. **採用率**
   - 3ヶ月後: カスタマイズが必要なタスクの50%で使用
   - 6ヶ月後: コミュニティからのモジュール貢献10件以上

3. **品質向上**
   - 生成された指示書の品質スコア: 既存指示書と同等以上
   - ユーザー満足度: 80%以上

## 6. リスクと対策

| リスク | 影響 | 対策 |
|--------|------|------|
| モジュールの組み合わせ爆発 | 管理困難 | タグによる互換性管理、プリセットの活用 |
| AIの判断ミス | 不適切な指示書生成 | 明示的な確認ステップ、プリセット優先 |
| 既存システムとの混在による混乱 | UX低下 | 明確なガイドライン、使い分けの自動提案 |

## 7. まとめ

このAI主導モジュラーシステムにより：

1. **既存の単体指示書の良さを維持**しながら
2. **必要に応じた柔軟なカスタマイズ**が可能になり
3. **AIが最適な組み合わせを提案**することで
4. **ユーザーは意識せずに高度な機能を活用**できます

シンプルさと柔軟性のバランスを取った、実用的なソリューションです。

---

**承認**

プロジェクトオーナー: _________________ 日付: _________

技術リード: _________________ 日付: _________