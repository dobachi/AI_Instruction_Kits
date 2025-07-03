# Examples / 使用例

This directory contains usage examples for the AI Instruction Kits system in both Japanese and English.

このディレクトリには、AI指示書システムの使用例が日本語と英語の両方で含まれています。

## Structure / 構造

```
examples/
├── ja/                    # Japanese examples / 日本語の例
│   ├── basic_usage.md    # Basic usage patterns / 基本的な使用方法
│   └── advanced_usage.md # Advanced techniques / 高度な使用方法
├── en/                    # English examples / 英語の例
│   └── basic_usage.md    # Basic usage patterns / 基本的な使用方法
└── README.md             # This file / このファイル
```

## Quick Start / クイックスタート

### Japanese / 日本語
- 基本的な使い方: [ja/basic_usage.md](ja/basic_usage.md)
- 高度な使い方: [ja/advanced_usage.md](ja/advanced_usage.md)

### English
- Basic usage: [en/basic_usage.md](en/basic_usage.md)

## Common Patterns / よくあるパターン

1. **Direct instruction reference / 直接指示書参照**
   ```bash
   claude "Refer to instructions/[lang]/[category]/[instruction].md and [task]"
   ```

2. **Automatic selection / 自動選択**
   ```bash
   claude "Refer to instructions/[lang]/system/ROOT_INSTRUCTION.md and [task]"
   ```

3. **Progress tracking / 進捗追跡**
   - Checkpoint information is automatically displayed
   - チェックポイント情報が自動的に表示されます

## Tips / ヒント

- Always specify the correct language (ja/en)
- 正しい言語（ja/en）を指定してください
- Complex tasks are automatically broken down into steps
- 複雑なタスクは自動的にステップに分解されます
- Check checkpoint.log for task history
- タスク履歴はcheckpoint.logで確認できます

---
## License / ライセンス
- Apache-2.0
- Author / 著者: dobachi
- Created / 作成日: 2025-06-30