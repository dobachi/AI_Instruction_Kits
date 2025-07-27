# モジュラーシステム高度機能 実装提案書

## 概要
本文書は、AI Instruction Kitsのモジュラーシステムに追加する高度機能の実装提案です。Issue #13で管理される4つの主要機能について、詳細な設計と実装計画を記述します。

## 背景
現在のモジュラーシステムは基本的な機能を提供していますが、以下の高度な要求に対応する必要があります：
- 複雑なモジュール間の依存関係管理
- 動的なモジュール選択
- バージョン管理と互換性保証
- 柔軟なテンプレート処理

## 提案する機能

### 1. 依存関係管理システム

#### 現状の課題
- モジュールの依存関係は記述されているが、自動解決されない
- 循環依存の検出機能がない
- 必須変数の伝播が行われない

#### 提案する解決策

##### 1.1 依存関係の自動解決
```python
# composer.pyに追加する主要メソッド
def resolve_dependencies(self, module_ids: List[str]) -> List[str]:
    """依存関係を解決し、必要なすべてのモジュールIDを返す"""
    resolved = []
    to_process = list(module_ids)
    processed = set()
    
    while to_process:
        module_id = to_process.pop(0)
        if module_id in processed:
            continue
            
        module = self.load_module(module_id)
        meta = module['metadata']
        
        # 必須依存関係を追加
        if 'dependencies' in meta:
            if isinstance(meta['dependencies'], dict):
                required = meta['dependencies'].get('required', [])
                for dep in required:
                    if dep not in processed:
                        to_process.append(dep)
        
        resolved.append(module_id)
        processed.add(module_id)
    
    return resolved
```

##### 1.2 循環依存の検出
```python
def detect_circular_dependencies(self, module_ids: List[str]) -> Optional[List[str]]:
    """循環依存を検出"""
    graph = self._build_dependency_graph(module_ids)
    visited = set()
    rec_stack = set()
    path = []
    
    def has_cycle(node):
        visited.add(node)
        rec_stack.add(node)
        path.append(node)
        
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                if has_cycle(neighbor):
                    return True
            elif neighbor in rec_stack:
                # 循環を発見
                cycle_start = path.index(neighbor)
                return path[cycle_start:]
        
        path.pop()
        rec_stack.remove(node)
        return False
    
    for module_id in module_ids:
        if module_id not in visited:
            cycle = has_cycle(module_id)
            if cycle:
                return cycle
    
    return None
```

##### 1.3 必須変数の伝播
依存モジュールが要求する変数を自動的に収集し、ユーザーに提示する機能。

### 2. 条件付きモジュール読み込み

#### 提案するYAML構造
```yaml
conditional_modules:
  - condition: "programming_language == 'Python'"
    modules: ["skill_python_best_practices"]
  - condition: "security_level == 'high'"
    modules: ["skill_security_advanced", "quality_security_audit"]
  - condition: "deployment_env in ['production', 'staging']"
    modules: ["quality_production"]
```

#### 実装方法
```python
def evaluate_conditions(self, conditions: List[Dict], variables: Dict) -> List[str]:
    """条件を評価し、読み込むべきモジュールを決定"""
    additional_modules = []
    
    for cond in conditions:
        if self._safe_eval(cond['condition'], variables):
            additional_modules.extend(cond['modules'])
    
    return additional_modules

def _safe_eval(self, expr: str, variables: Dict) -> bool:
    """安全な式評価（限定的な演算子のみサポート）"""
    # ast.parseを使用して安全な評価を実装
    import ast
    
    # サポートする演算子を制限
    allowed_ops = {
        ast.Eq, ast.NotEq, ast.Lt, ast.LtE, ast.Gt, ast.GtE,
        ast.And, ast.Or, ast.Not, ast.In, ast.NotIn
    }
    
    # 式をパースして検証
    tree = ast.parse(expr, mode='eval')
    # ... 安全性チェックと評価
```

### 3. モジュールバージョニング

#### 提案する仕様

##### 3.1 バージョン指定形式
```yaml
# モジュールのメタデータ
version: "2.0.0"
min_composer_version: "1.5.0"

# 依存関係でのバージョン指定
dependencies:
  required:
    - module: "core_role_definition"
      version: ">=1.0.0,<3.0.0"
    - module: "skill_api_design"
      version: "~1.2.0"  # 1.2.x を許可
```

##### 3.2 バージョン互換性チェック
```python
from packaging import version, specifiers

def check_version_compatibility(self, module_id: str, version_spec: str) -> bool:
    """バージョン互換性をチェック"""
    module = self.load_module(module_id)
    module_version = version.parse(module['metadata']['version'])
    spec = specifiers.SpecifierSet(version_spec)
    
    return module_version in spec
```

##### 3.3 バージョンロック機能
`composer.lock`ファイルを生成し、使用したモジュールの正確なバージョンを記録。

### 4. カスタムフィルター/変換機能

#### 提案する実装

##### 4.1 フィルターレジストリ
```python
class FilterRegistry:
    def __init__(self):
        self.filters = {
            # 文字列変換
            'upper': lambda x: str(x).upper(),
            'lower': lambda x: str(x).lower(),
            'capitalize': lambda x: str(x).capitalize(),
            'title': lambda x: str(x).title(),
            
            # ケース変換
            'snake_to_camel': self._snake_to_camel,
            'camel_to_snake': self._camel_to_snake,
            'kebab_to_snake': lambda x: x.replace('-', '_'),
            
            # 配列操作
            'join': lambda x, sep=',': sep.join(x) if isinstance(x, list) else x,
            'first': lambda x: x[0] if x else None,
            'last': lambda x: x[-1] if x else None,
            
            # 条件付き
            'default': lambda x, default='': x if x else default
        }
```

##### 4.2 テンプレート内での使用
```
役割: {{role_description|capitalize}}
プログラミング言語: {{language|upper|default:'PYTHON'}}
モジュール名: {{module_name|snake_to_camel}}
```

##### 4.3 カスタムフィルターの登録
```python
# ユーザー定義フィルターの登録API
composer.register_filter('my_filter', lambda x: custom_transform(x))
```

## 実装計画

### フェーズ1：依存関係管理（2週間）
- 週1：基本的な依存関係解決の実装
- 週2：循環依存検出とエラーハンドリング

### フェーズ2：条件付き読み込み（1週間）
- 条件式パーサーの実装
- セキュリティテストの実施

### フェーズ3：バージョニング（1週間）
- バージョン比較ロジックの実装
- composer.lockファイルの生成

### フェーズ4：フィルター機能（4日）
- 組み込みフィルターの実装
- カスタムフィルターAPI

## テスト戦略

### 単体テスト
各機能に対して包括的な単体テストを作成：
- 依存関係解決の各種パターン
- 条件式評価のエッジケース
- バージョン比較の境界値
- フィルター変換の正確性

### 統合テスト
実際のモジュールを使用したE2Eテスト：
- 複雑な依存関係グラフの解決
- 条件付きモジュールの動的読み込み
- バージョン互換性の実践的検証

### パフォーマンステスト
- 大量モジュールでの依存関係解決速度
- キャッシュ効果の測定

## リスク評価と対策

### 技術的リスク
1. **複雑性の増加**
   - 対策：段階的な機能追加とフィーチャーフラグ
   
2. **後方互換性の破壊**
   - 対策：既存APIの維持と移行パスの提供

3. **セキュリティリスク（条件式評価）**
   - 対策：ホワイトリスト方式の演算子制限

### 運用リスク
1. **学習曲線の上昇**
   - 対策：豊富なドキュメントとサンプル

2. **デバッグの困難さ**
   - 対策：詳細なログ出力と診断ツール

## 期待される効果

1. **開発効率の向上**
   - 依存関係の自動管理により、手動での調整が不要に
   - 条件付き読み込みにより、柔軟な構成が可能に

2. **保守性の改善**
   - バージョン管理により、互換性の問題を事前に検出
   - モジュール間の関係が明確化

3. **表現力の向上**
   - カスタムフィルターにより、より洗練された出力が可能に

## まとめ
これらの高度機能により、AI Instruction Kitsのモジュラーシステムは、より強力で柔軟なツールとなります。段階的な実装により、リスクを最小限に抑えながら、ユーザーに価値を提供していきます。