# モジュラーシステム動作確認テスト

## テスト手順

### 1. 新しいAIセッションでの確認
新しいAIセッションを開始し、以下のメッセージを送信：

```
Python製のCLIツールを作りたい。エラーハンドリングとログ機能を重視して、ユーザーフレンドリーなものにしたい。
```

### 2. 期待される動作
AIは以下のような応答をするはずです：

1. ROOT_INSTRUCTIONを読み込む
2. MODULE_COMPOSERを読み込む（カスタマイズが必要と判断）
3. 以下のようなモジュール選択を提案：
   - task_cli_tool
   - skill_error_handling
   - skill_logging（存在する場合）
   - quality_user_friendly（存在する場合）

4. generate-instruction.shコマンドを実行
5. 生成された指示書に従って実装

### 3. 確認ポイント
- [ ] MODULE_COMPOSERが読み込まれるか
- [ ] 適切なモジュールが選択されるか
- [ ] generate-instruction.shが正しく実行されるか
- [ ] 生成された指示書が期待通りか

### 4. トラブルシューティング
もしMODULE_COMPOSERが読み込まれない場合：
1. ROOT_INSTRUCTION.mdのパスが正しいか確認
2. CLAUDE.mdやプロジェクト固有の設定を確認
3. 明示的に「モジュラーシステムを使って」と指示してみる