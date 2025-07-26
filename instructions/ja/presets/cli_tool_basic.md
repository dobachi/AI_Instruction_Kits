<!-- 
  自動生成されたプリセット指示書
  プリセット: cli_tool_basic
  言語: ja
  生成日時: 2025-07-26 22:25:30
  生成スクリプト: scripts/generate-all-presets.sh
  
  ⚠️ このファイルは自動生成されます。直接編集しないでください。
  変更が必要な場合は、対応するモジュールまたはプリセット定義を編集してください。
-->

# AI指示書
*この指示書はモジュラーシステム v2.0 によって自動生成されました*

**プリセット**: CLIツール基本開発
**説明**: コマンドラインツールの基本的な開発指示書プリセット

## 適用設定

- **argument_style**: posix
- **cli_framework**: {{framework}}
- **code_coverage_target**: 基本的なパスをカバー
- **command_structure**: {{structure}}
- **comment_style**: inline_and_docstring
- **communication_style**: 技術的
- **documentation_level**: 基本的な使用方法
- **error_handling_pattern**: 終了コードとエラーメッセージ
- **error_message_format**: stderr出力
- **expertise_level**: 中級
- **format_description**: 実装可能なコマンドラインツールのコードと使用例
- **framework**: argparse
- **help_format**: 標準的なUNIXスタイル
- **indent_style**: スペース4つ
- **interactive_mode**: optional
- **language**: Python
- **length_requirements**: 完全な実装とドキュメント、使用例を含む
- **naming_convention**: snake_case
- **option_prefix**: dash
- **output_format**: plain_text
- **programming_language**: {{language}}
- **progress_indication**: simple
- **required_args_handling**: explicit
- **role_description**: CLIツール開発者として、使いやすいコマンドラインインターフェースを実装する
- **structure**: single
- **structure_requirements**: 明確なコマンド構造、ヘルプメッセージ、引数検証
- **style_requirements**: 標準的なCLI規約とベストプラクティスに従う
- **test_strategy**: ユニットテスト
- **validation_level**: strict

## 実行指示

### Core
- core_role_definition
- core_output_format
- core_constraints

### Tasks
- task_code_generation

### Skills
- skill_error_handling
- skill_cli_interface
- skill_argument_parsing

### Quality
- quality_basic