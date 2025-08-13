# Serena外部メモリ統合設計書

## 1. 概要

### 1.1 背景
AI指示書キットシステムは現在、静的な指示書とモジュラーシステムを使用してAIの振る舞いを制御している。しかし、動的な知識ベースや過去の作業履歴へのアクセスが限定的であり、コンテキストの継続性に課題がある。

### 1.2 目的
Serena（oraios/serena）のMCPサーバー機能を活用し、AI指示書キットシステムに外部メモリ機能を統合することで、以下を実現する：
- 動的な知識ベースの構築と活用
- セマンティック検索による効率的な情報取得
- プロジェクト固有の知識の蓄積と再利用
- 作業履歴とコンテキストの永続化

### 1.3 Serenaとは
Serenaは、MCPサーバーとして動作するコーディングエージェントツールキットで、以下の特徴を持つ：
- **セマンティックコード理解**: LSP（Language Server Protocol）を使用したシンボルレベルのコード理解
- **MCP統合**: Model Context Protocolを通じた各種AIツールとの統合
- **言語非依存**: Python、TypeScript、Go、Rust等、多言語対応
- **トークン効率**: 精密なコードコンテキスト提供によるトークン使用量の削減

## 2. 要件定義

### 2.1 機能要件

#### 2.1.1 知識ベース管理
- **知識の登録**: 指示書、モジュール、作業結果を外部メモリに登録
- **知識の検索**: セマンティック検索による関連情報の取得
- **知識の更新**: 既存知識の更新と版管理
- **知識の削除**: 不要になった知識の削除

#### 2.1.2 コンテキスト管理
- **セッション管理**: 作業セッションごとのコンテキスト保存
- **履歴追跡**: 過去の作業履歴とその結果の記録
- **関連性分析**: 現在のタスクと過去の作業の関連性分析

#### 2.1.3 検索機能
- **セマンティック検索**: 意味的に関連する情報の検索
- **構造化検索**: メタデータやタグによる検索
- **ハイブリッド検索**: キーワードとセマンティックの組み合わせ

### 2.2 非機能要件

#### 2.2.1 パフォーマンス
- 検索レスポンス時間: 1秒以内（ローカル環境）
- 同時接続数: 最低5セッション
- メモリ使用量: 1GB以内

#### 2.2.2 信頼性
- データ永続性: ローカルファイルシステムへの保存
- エラーハンドリング: MCPサーバー障害時のグレースフルデグレード
- バックアップ: 定期的な知識ベースのバックアップ

#### 2.2.3 セキュリティ
- アクセス制御: ローカル環境のみでの動作
- データ暗号化: 機密情報の暗号化（オプション）
- 監査ログ: アクセスログの記録

## 3. システムアーキテクチャ

### 3.1 全体構成

```
┌─────────────────────────────────────────────────────────┐
│                   AI Agent (Claude等)                    │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ MCP Protocol
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Serena MCP Server                     │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Semantic  │  │   Code       │  │   Memory     │  │
│  │   Search    │  │   Analysis   │  │   Manager    │  │
│  └─────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│              AI Instruction Kits System                  │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ Instructions│  │   Modular    │  │  Checkpoint  │  │
│  │   & Presets │  │   System     │  │   System     │  │
│  └─────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  External Memory Store                   │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Knowledge  │  │   Context    │  │   History    │  │
│  │     Base    │  │    Store     │  │    Store     │  │
│  └─────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### 3.2 コンポーネント設計

#### 3.2.1 Serena統合レイヤー
```yaml
components:
  serena_adapter:
    description: "SerenaのMCPサーバーとの通信を管理"
    responsibilities:
      - MCPサーバーの起動・停止
      - リクエスト/レスポンスの処理
      - エラーハンドリング
    
  memory_interface:
    description: "外部メモリ操作のインターフェース"
    methods:
      - store_knowledge(content, metadata)
      - search_knowledge(query, filters)
      - update_knowledge(id, content, metadata)
      - delete_knowledge(id)
```

#### 3.2.2 知識ベース構造
```yaml
knowledge_structure:
  instruction:
    id: string
    type: "instruction" | "module" | "preset"
    content: string
    metadata:
      created_at: timestamp
      updated_at: timestamp
      tags: string[]
      category: string
      usage_count: number
  
  context:
    id: string
    session_id: string
    task_id: string
    content: string
    metadata:
      timestamp: timestamp
      agent: string
      status: string
  
  history:
    id: string
    task_id: string
    actions: array
    results: array
    metadata:
      duration: number
      success: boolean
      error_message: string?
```

## 4. 実装計画

### 4.1 フェーズ1: 基盤構築（2週間）
1. Serena MCPサーバーのセットアップ
2. 基本的な統合アダプターの実装
3. テスト環境の構築

### 4.2 フェーズ2: 知識ベース実装（3週間）
1. 知識ベースのデータモデル設計
2. CRUD操作の実装
3. セマンティック検索の実装

### 4.3 フェーズ3: AI指示書統合（2週間）
1. 既存システムとの統合ポイント実装
2. チェックポイントシステムとの連携
3. モジュラーシステムとの連携

### 4.4 フェーズ4: 最適化とテスト（2週間）
1. パフォーマンス最適化
2. 統合テスト
3. ドキュメント作成

## 5. 技術スタック

### 5.1 必須コンポーネント
- **Serena**: MCPサーバー（oraios/serena）
- **uv**: Pythonパッケージマネージャー
- **MCP SDK**: Model Context Protocol SDK

### 5.2 推奨コンポーネント
- **Docker**: コンテナ化（オプション）
- **SQLite/PostgreSQL**: メタデータストア
- **Elasticsearch**: 高度な検索機能（オプション）

## 6. 統合ポイント

### 6.1 checkpoint.sh との統合
```bash
# チェックポイント作成時に外部メモリに保存
scripts/checkpoint.sh start "task" --with-memory

# 過去のチェックポイントを検索
scripts/checkpoint.sh search "keyword"
```

### 6.2 generate-instruction.sh との統合
```bash
# 生成された指示書を外部メモリに自動保存
scripts/generate-instruction.sh --preset web_api --save-to-memory

# 過去の指示書を基に新規生成
scripts/generate-instruction.sh --from-memory "similar-task"
```

### 6.3 ROOT_INSTRUCTION.md への統合
```markdown
## 外部メモリシステムの活用（Serena統合時）

外部メモリが有効な場合、以下のコマンドが利用可能：
1. **知識検索**: `scripts/memory-search.sh <query>` 
   - 過去の指示書、作業結果、コンテキストを検索
2. **知識保存**: `scripts/memory-store.sh <content> <metadata>`
   - 新しい知識を外部メモリに保存
3. **コンテキスト確認**: `scripts/memory-context.sh`
   - 現在のセッションコンテキストを表示

指示書選択時に外部メモリから類似タスクを自動検索し、
参考情報として提示します。
```

### 6.4 MODULE_COMPOSER.md への統合
```markdown
## 外部メモリからのモジュール推薦

外部メモリが有効な場合：
- 過去の類似タスクで使用されたモジュールを推薦
- 成功率の高いモジュール組み合わせを提案
- タスク固有の最適化されたパラメータを提供
```

## 7. セキュリティ考慮事項

### 7.1 データプライバシー
- すべてのデータはローカルに保存
- 外部サービスへの送信は行わない
- 機密情報のマスキング機能

### 7.2 アクセス制御
- ローカルホストのみでMCPサーバーを起動
- 認証トークンによる保護（オプション）

## 8. 運用・保守

### 8.1 バックアップ戦略
```bash
# 日次バックアップ
0 2 * * * /path/to/backup-memory.sh

# バックアップからの復元
scripts/restore-memory.sh backup-20250813.tar.gz
```

### 8.2 メンテナンス
- 定期的な不要データのクリーンアップ
- インデックスの再構築
- パフォーマンス監視

## 9. 制約事項とリスク

### 9.1 制約事項
- Serenaの言語サポートに依存
- MCPプロトコルの仕様変更への対応が必要
- ローカル環境でのみ動作

### 9.2 リスクと対策
| リスク | 影響度 | 対策 |
|--------|--------|------|
| MCPサーバーの障害 | 高 | フォールバック機能の実装 |
| データ容量の増大 | 中 | 定期的なクリーンアップと圧縮 |
| 検索性能の劣化 | 中 | インデックスの最適化 |

## 10. 成功指標

### 10.1 定量的指標
- 検索精度: 90%以上
- レスポンス時間: 1秒以内
- システム稼働率: 99%以上

### 10.2 定性的指標
- 開発者の生産性向上
- コンテキスト切り替えの削減
- 知識の再利用性向上

## 11. 今後の拡張可能性

### 11.1 短期的拡張
- Webベースの管理UI
- 複数プロジェクト対応
- チーム間での知識共有

### 11.2 長期的拡張
- クラウドベースの知識ベース
- AI による知識の自動整理
- 他のMCPサーバーとの連携

## 12. 参考資料

- [Serena GitHub Repository](https://github.com/oraios/serena)
- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [AI Instruction Kits Documentation](./README.md)

---
## ライセンス情報
- **作成日**: 2025-08-13
- **作成者**: AI Instruction Kits Development Team
- **ステータス**: Draft v1.0