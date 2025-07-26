<!-- 
  自動生成されたプリセット指示書
  プリセット: web_api_production
  言語: ja
  生成日時: 2025-07-26 22:25:30
  生成スクリプト: scripts/generate-all-presets.sh
  
  ⚠️ このファイルは自動生成されます。直接編集しないでください。
  変更が必要な場合は、対応するモジュールまたはプリセット定義を編集してください。
-->

# AI指示書
*この指示書はモジュラーシステム v2.0 によって自動生成されました*

**プリセット**: 本番用Web API開発
**説明**: 本番環境で使用するWeb APIの開発指示書プリセット

## 適用設定

- **api_documentation**: openapi_3.0
- **api_style**: restful
- **auth_method**: {{auth_method}}
- **availability_target**: 99.9%
- **caching_strategy**: redis
- **comment_style**: docstring形式
- **communication_style**: 技術的
- **cors_policy**: restrictive
- **database_optimization**: connection_pooling
- **error_catalog**: complete
- **error_handling_pattern**: try-except with custom exceptions
- **error_message_format**: JSON形式 {"error": {"code": "", "message": "", "details": {}}}
- **example_requests**: comprehensive
- **expertise_level**: 専門家
- **format_description**: 実装可能なコードとAPIドキュメント
- **framework**: {{framework}}
- **indent_style**: スペース4つ
- **input_validation**: strict
- **language**: Python
- **length_requirements**: 各エンドポイントに対して完全な実装とテストコード
- **max_error_rate**: 0.1%
- **naming_convention**: snake_case
- **output_sanitization**: enabled
- **pagination_style**: offset_limit
- **permission_model**: rbac
- **programming_language**: {{language}}
- **rate_limiting**: 100 req/min per user
- **response_format**: json
- **response_time_target**: 200ms (95パーセンタイル)
- **role_description**: Web API開発の専門家として、高品質なRESTful APIを設計・実装する
- **security_level**: high
- **structure_requirements**: 明確なエンドポイント定義、リクエスト/レスポンス例、エラーハンドリング
- **style_requirements**: RESTfulな設計原則に従い、一貫性のある命名規則を使用
- **test_coverage_target**: 80%以上
- **test_framework**: {{test_framework}}
- **test_types**: unit, integration, e2e
- **token_expiration**: {{token_expiry}}
- **token_expiry**: 1h
- **validation_level**: comprehensive
- **versioning_strategy**: url_path

## 実行指示

### Core
- core_role_definition
- core_output_format
- core_constraints

### Tasks
- task_code_generation

### Skills
- skill_error_handling
- skill_testing
- skill_api_design
- skill_authentication

### Quality
- quality_production