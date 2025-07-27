# チェックポイントスクリプトのステータス表示動作改善提案

**注：この提案は、より包括的な「サブコマンド体系設計」に発展しました。詳細は`checkpoint-subcommand-design.md`を参照してください。**

## 背景と課題

現在の`checkpoint.sh`は引数なしで実行するとステータスを表示するが、これによりAIが以下のような問題行動を起こしている：

1. **ステータス表示で満足**: AIが`checkpoint.sh`を実行してステータスを見ただけで次のアクションを取らない
2. **タスク継続の失敗**: 進行中のタスクがあってもprogress/completeコマンドを実行しない
3. **新規タスク開始の忘却**: タスク完了後、新しいタスクの開始を忘れる

現在の出力例：
```
📊 現在のタスク: プリセットカスタマイズ機能実装 (推定8ステップ)
🔄 タスク進行中 - 次のステップを続行するか 'progress/complete/error' コマンドを使用
📌 詳細→checkpoint.log (200件のタスク記録)
```

AIはこの出力を見て「確認完了」と判断し、次のアクションを取らないケースが多い。

## 提案するアプローチ

### アプローチ1: エラー終了による強制的なアクション促進

#### 概要
引数なし実行時にエラー（終了コード1）を返し、必ず具体的なアクションを要求する。

#### 実装例
```bash
"status"|"")
    # 状態を表示
    show_current_status
    
    # エラーメッセージとアクション指示
    echo "❌ エラー: アクションを指定してください"
    echo "必須: 以下のいずれかのコマンドを実行してください："
    
    if [ "$TASK_STATUS" == "in_progress" ]; then
        echo "  - scripts/checkpoint.sh progress <step> <total> <status> <next>"
        echo "  - scripts/checkpoint.sh complete <task-id> <result>"
        echo "  - scripts/checkpoint.sh error <task-id> <message>"
    else
        echo "  - scripts/checkpoint.sh start <task-id> <name> <steps>"
    fi
    
    exit 1  # エラー終了
    ;;
```

#### メリット
- AIが必ずアクションを取らざるを得ない
- 明確なエラーによる注意喚起
- 次のステップが明示的

#### デメリット
- 人間ユーザーには使いにくい
- ステータス確認だけしたい場合に不便
- エラーログが増える

### アプローチ2: インタラクティブモードの追加

#### 概要
引数なし実行時に対話的にアクションを選択させる。

#### 実装例
```bash
"status"|"")
    show_current_status
    
    echo "次のアクションを選択してください："
    if [ "$TASK_STATUS" == "in_progress" ]; then
        echo "1) progress - 進捗を報告"
        echo "2) complete - タスクを完了"
        echo "3) error - エラーを報告"
        echo "4) exit - 何もしない"
        
        read -p "選択 (1-4): " choice
        case $choice in
            1) exec $0 progress ;;
            2) exec $0 complete ;;
            3) exec $0 error ;;
            4) exit 0 ;;
        esac
    fi
    ;;
```

#### メリット
- ユーザーフレンドリー
- 明確な選択肢
- 誤操作の防止

#### デメリット
- AIには使えない（対話的入力不可）
- 自動化に不向き
- 実装が複雑

### アプローチ3: AI専用モードの追加

#### 概要
環境変数やフラグでAIモードを判定し、AIの場合のみエラーを返す。

#### 実装例
```bash
# スクリプトの冒頭で判定
AI_MODE="${AI_MODE:-false}"
if [ "$1" == "--ai" ]; then
    AI_MODE=true
    shift
fi

"status"|"")
    show_current_status
    
    if [ "$AI_MODE" == "true" ]; then
        echo "❌ AI実行エラー: 具体的なアクションを指定してください"
        show_required_actions
        exit 1
    else
        # 人間向けの通常表示
        show_friendly_suggestions
        exit 0
    fi
    ;;
```

#### メリット
- 人間とAIで最適な動作を分離
- 既存の使い勝手を維持
- 柔軟な制御が可能

#### デメリット
- 実装が複雑
- AIが--aiフラグを忘れる可能性
- 環境設定が必要

### アプローチ4: 警告レベルの段階的エスカレーション

#### 概要
連続して引数なし実行された回数を記録し、段階的に警告を強くする。

#### 実装例
```bash
# 連続実行カウンターファイル
COUNTER_FILE=".checkpoint_status_count"

"status"|"")
    # カウンター増加
    COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
    COUNT=$((COUNT + 1))
    echo $COUNT > "$COUNTER_FILE"
    
    show_current_status
    
    case $COUNT in
        1) 
            # 通常表示
            exit 0
            ;;
        2)
            echo "⚠️ 注意: アクションを実行してください"
            exit 0
            ;;
        3)
            echo "❌ エラー: 3回連続でステータスのみ確認しています"
            echo "必須: 具体的なアクションを実行してください"
            show_required_actions
            exit 1
            ;;
    esac
    ;;

# 他のアクション実行時はカウンターリセット
*) 
    rm -f "$COUNTER_FILE"
    ;;
```

#### メリット
- 段階的な対応で柔軟
- 初回は通常動作を維持
- AIの行動パターンを学習

#### デメリット
- 状態管理が複雑
- ファイル管理が必要
- 予期しない動作の可能性

### アプローチ5: アクション必須フラグの追加

#### 概要
ROOT_INSTRUCTIONで`--require-action`フラグの使用を必須化する。

#### 実装例
```bash
# 新しいフラグの処理
REQUIRE_ACTION=false
if [ "$1" == "--require-action" ]; then
    REQUIRE_ACTION=true
    shift
fi

"status"|"")
    show_current_status
    
    if [ "$REQUIRE_ACTION" == "true" ]; then
        echo "❌ --require-actionモード: アクションの指定が必須です"
        show_required_actions
        exit 1
    fi
    exit 0
    ;;
```

ROOT_INSTRUCTION.mdへの追加：
```markdown
## チェックポイント実行時の必須フラグ
**【重要】必ず`--require-action`フラグを付けて実行すること**
```bash
scripts/checkpoint.sh --require-action
```
```

#### メリット
- 明示的な制御
- 既存動作への影響なし
- AIへの指示が明確

#### デメリット
- フラグを忘れる可能性
- コマンドが長くなる
- 後方互換性の問題

## 比較検討

| 観点 | アプローチ1<br>エラー終了 | アプローチ2<br>対話モード | アプローチ3<br>AI専用モード | アプローチ4<br>段階的警告 | アプローチ5<br>必須フラグ |
|------|----------|----------|------------|----------|----------|
| AI効果 | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 人間UX | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 実装容易性 | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| 保守性 | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| 後方互換性 | ⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 確実性 | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

## 推奨案：アプローチ3（AI専用モード）の改良版

### 実装計画

#### Phase 1: 基本実装
1. 環境変数`CHECKPOINT_AI_MODE`のサポート追加
2. ROOT_INSTRUCTIONで環境変数設定を必須化
3. AIモード時のエラー動作実装

#### Phase 2: スマート検出
1. 実行パターンからAI実行を自動検出
2. 短時間での連続実行を監視
3. 警告メッセージの最適化

#### Phase 3: 統合改善
1. 指示書使用履歴との連携
2. AIの行動ログ分析
3. 最適な促しメッセージの自動生成

### 詳細実装案

```bash
#!/bin/bash

# AI実行の自動検出
detect_ai_execution() {
    # 1. 環境変数チェック
    if [ "$CHECKPOINT_AI_MODE" == "true" ]; then
        return 0
    fi
    
    # 2. 実行パターン検出（1分以内の連続実行）
    LAST_RUN_FILE=".checkpoint_last_run"
    CURRENT_TIME=$(date +%s)
    
    if [ -f "$LAST_RUN_FILE" ]; then
        LAST_TIME=$(cat "$LAST_RUN_FILE")
        DIFF=$((CURRENT_TIME - LAST_TIME))
        
        if [ $DIFF -lt 60 ]; then
            return 0  # AI実行と判定
        fi
    fi
    
    echo $CURRENT_TIME > "$LAST_RUN_FILE"
    return 1  # 人間実行と判定
}

case "$ACTION" in
    "status"|"")
        show_current_status
        
        if detect_ai_execution; then
            echo ""
            echo "❌ アクション必須: ステータス確認のみは許可されていません"
            echo ""
            
            if [ "$TASK_STATUS" == "completed" ] || [ "$TASK_STATUS" == "none" ]; then
                echo "📝 必須アクション: 新しいタスクを開始してください"
                echo "   scripts/checkpoint.sh start <task-id> <task-name> <steps>"
                echo ""
                echo "例:"
                echo "   scripts/checkpoint.sh start TASK-$(openssl rand -hex 3) \"機能実装\" 5"
            else
                echo "📝 必須アクション: 現在のタスクを進めてください"
                echo "   scripts/checkpoint.sh progress <current> <total> <status> <next>"
                echo "   scripts/checkpoint.sh complete <task-id> <result>"
                echo ""
                echo "例:"
                echo "   scripts/checkpoint.sh progress 2 5 \"分析完了\" \"実装開始\""
            fi
            
            exit 1
        else
            # 人間向けの親切な表示
            echo ""
            echo "💡 ヒント: 'help'でコマンド一覧を表示"
            exit 0
        fi
        ;;
esac
```

### ROOT_INSTRUCTION.mdへの追加

```markdown
## 【最重要】チェックポイント実行設定

### AI実行環境の設定（必須）
```bash
export CHECKPOINT_AI_MODE=true
```

### チェックポイント実行ルール
1. **引数なし実行は禁止** - 必ず具体的なアクションを指定
2. **エラー時は即座に対応** - 指示に従ってコマンドを実行
3. **タスク完了後は新規開始** - 自動的に次のタスクを開始

### 実行例
```bash
# ❌ 禁止（エラーになります）
scripts/checkpoint.sh

# ✅ 正しい使用方法
scripts/checkpoint.sh start TASK-abc123 "機能実装" 5
scripts/checkpoint.sh progress 1 5 "分析完了" "設計開始"
scripts/checkpoint.sh complete TASK-abc123 "5つの機能実装完了"
```
```

## まとめ

推奨するAI専用モードの改良版により：

1. **AI動作の改善**: ステータス確認で止まらず、必ずアクションを実行
2. **人間UXの維持**: 通常ユーザーには影響なし
3. **段階的導入**: 環境変数による制御から自動検出へ
4. **将来の拡張性**: 行動パターン学習による最適化

この実装により、AIがチェックポイントシステムを効果的に活用し、タスクを確実に進行させることが期待できる。