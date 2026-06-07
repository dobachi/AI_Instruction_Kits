# AI開発支援設定

このプロジェクトでは`instructions/ai_instruction_kits/`のAI指示書システムを使用します。
タスク開始時は`instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

## プロジェクト設定
- 言語: 日本語 (ja)
- タスク管理・進捗追跡: AIツールのネイティブ機能を利用

## 重要なパス
- AI指示書システム: `instructions/ai_instruction_kits/`
- 安全なコミット: `scripts/commit.sh`
- プロジェクト固有の設定: このファイル（`instructions/PROJECT.md`）

## コミットルール
- **必須**: `bash scripts/commit.sh "メッセージ"` または `git commit -m "メッセージ"`
- **禁止**: AI署名付きコミット（自動検出・拒否されます）

## プロジェクト固有の追加指示
<!-- ここにプロジェクト固有の指示を追加してください -->

### 例：
- コーディング規約: 
- テストフレームワーク: 
- ビルドコマンド: 
- リントコマンド: 
- その他の制約事項: 