# OpenHands統合設計書

## 概要
AI指示書キットをOpenHandsに完全統合し、OpenHandsが自律的に最適な指示書を選択・適用できるようにする。

## 背景と課題

### 現状
- OpenHandsは `.openhands/microagents/repo.md` を参照
- 現在は `PROJECT.md` へのシンボリックリンクで対応
- OpenHandsが自身の実行環境を認識できない
- OpenHands特有の最適化が適用されない

### 課題
1. 環境検出の欠如：OpenHandsが自身の環境を認識できない
2. 最適化の不足：OpenHands特有の機能（並列処理、自動リトライ等）が活用されない
3. 統合の不完全性：既存の指示書システムとの連携が不十分

## 設計方針

### 基本方針
1. **環境認識の自動化**：OpenHandsが確実に自身の環境を認識
2. **既存システムとの互換性**：現在の指示書システムを破壊しない
3. **段階的な拡張性**：将来の機能追加を容易にする

### アーキテクチャ
```
OpenHands起動
    ↓
OPENHANDS_ROOT.md（新規：OpenHands専用ルート）
    ↓
ROOT_INSTRUCTION.md（既存：共通ルート、変更なし）
    ↓
各種指示書（MODULE_COMPOSER、個別指示書等）
```

## 詳細設計

### 1. ファイル構成
```
AI_Instruction_Kits/
├── instructions/
│   └── ja/
│       └── system/
│           ├── OPENHANDS_ROOT.md（新規）
│           └── ROOT_INSTRUCTION.md（既存、変更なし）
├── .openhands/
│   └── microagents/
│       └── repo.md → ../../instructions/ja/system/OPENHANDS_ROOT.md
└── scripts/
    └── setup-project.sh（修正）
```

### 2. OPENHANDS_ROOT.md の内容

#### 基本構造
```markdown
# OpenHands専用ルート指示書

## 1. 環境認識とセットアップ
- OpenHandsバージョンの確認
- 利用可能な機能の確認
- 最適化設定の適用

## 2. 共通指示書システムの読み込み
- ROOT_INSTRUCTION.md を必ず読み込む
- 以降、通常の指示書フローに従う
- ただし、OpenHands向け最適化を常に意識する

## 3. OpenHands特有の拡張機能
- 並列タスク実行
- 自動エラーリカバリー
- 進捗の可視化
- ブラウザUIとの連携

## 4. パフォーマンス最適化
- ファイル操作のバッチ処理
- キャッシュの活用
- リソース管理
```

### 3. setup-project.sh の修正

#### 変更点
```bash
# 従来
ln -sf ../../instructions/PROJECT.md .openhands/microagents/repo.md

# 新規
if [ -f "instructions/ja/system/OPENHANDS_ROOT.md" ]; then
    # AI指示書キット自体の開発時
    ln -sf ../../instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md
else
    # 通常のプロジェクト（サブモジュール使用時）
    ln -sf ../../instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md
fi
```

## 実装計画

### フェーズ1：基礎実装（必須）
1. OPENHANDS_ROOT.md の作成
2. setup-project.sh の修正
3. 基本的な動作確認

### フェーズ2：最適化機能（推奨）
1. 並列処理の実装
2. エラーリカバリーの強化
3. キャッシュ機能の追加

### フェーズ3：高度な統合（オプション）
1. ブラウザUIとの深い連携
2. タスクの自動分割
3. 機械学習による最適化

## 影響範囲

### 影響を受けるファイル
- `scripts/setup-project.sh`
- 新規作成：`instructions/ja/system/OPENHANDS_ROOT.md`
- 新規作成：`instructions/en/system/OPENHANDS_ROOT.md`

### 変更が**不要**なファイル
- `instructions/ja/system/ROOT_INSTRUCTION.md`（既存のまま使用）
- その他の既存指示書すべて

### 後方互換性
- 既存のプロジェクトに影響なし
- PROJECT.md を使用している場合も動作継続
- 段階的な移行が可能

## テスト計画

### 単体テスト
1. OPENHANDS_ROOT.md の読み込みテスト
2. 環境検出の動作確認
3. 既存指示書との連携確認

### 統合テスト
1. 新規プロジェクトでのセットアップ
2. 既存プロジェクトでの動作確認
3. エラーケースの確認

### 受け入れテスト
1. 実際のOpenHands環境での動作
2. パフォーマンス測定
3. ユーザビリティ確認

## リスクと対策

### リスク1：既存システムへの影響
- **対策**：オプトイン方式で段階的に導入

### リスク2：複雑性の増加
- **対策**：シンプルな設計を維持、ドキュメント充実

### リスク3：OpenHandsバージョン依存
- **対策**：バージョン検出と互換性維持

## スケジュール案

1. **設計レビュー**：1日
2. **基礎実装**：2日
3. **テスト**：1日
4. **ドキュメント**：1日
5. **合計**：5日

## 今後の拡張可能性

1. **他のAIツールへの対応**
   - 同様の専用ルート指示書を作成可能
   - 共通インターフェースの定義

2. **プラグインシステム**
   - OpenHands専用プラグインの開発
   - 動的な機能拡張

3. **メトリクス収集**
   - 実行効率の測定
   - 最適化の自動調整

---
## 承認事項

この設計書の承認により、以下を実施します：

1. OPENHANDS_ROOT.md の作成
2. setup-project.sh の修正
3. 関連ドキュメントの更新
4. テストの実施

## 参考資料

- [OpenHandsドキュメント](https://docs.all-hands.dev/)
- [AI指示書キット構造](../architecture.md)
- [既存のOpenHands提案](./openhands_oss_models.md)