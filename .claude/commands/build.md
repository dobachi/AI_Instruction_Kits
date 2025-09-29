---
description: "プロジェクトに適したビルドコマンドを自動検出・実行"
---

# 🔨 スマートビルドシステム

プロジェクトの構成を自動検出し、最適なビルドコマンドを実行します。

## 使用方法

```
/build [options]
```

## オプション

- `--clean` - クリーンビルドを実行（キャッシュクリア）
- `--watch` - ウォッチモードでビルド（開発時）
- `--prod` - プロダクションビルド（最適化あり）
- `--test` - テストも含めて実行
- `--deps` - 依存関係のみインストール
- `--check` - ビルド可能性をチェックのみ
- `--verbose` - 詳細ログ出力

## 🎯 対応プロジェクトタイプ

### フロントエンド・JavaScript
- **Node.js**: `package.json` → `npm/yarn/pnpm run build`
- **Vite**: `vite.config.*` → `vite build`
- **Next.js**: `next.config.*` → `next build`
- **React**: Create React App → `react-scripts build`
- **Vue**: `vue.config.*` → `vue-cli-service build`
- **Angular**: `angular.json` → `ng build`
- **Webpack**: `webpack.config.*` → `webpack`

### バックエンド・システム
- **Rust**: `Cargo.toml` → `cargo build --release`
- **Go**: `go.mod` → `go build`
- **Python**: `pyproject.toml` → `python -m build`
- **Java Maven**: `pom.xml` → `mvn compile`
- **Java Gradle**: `build.gradle` → `gradle build`
- **C/C++**: `Makefile` → `make`
- **CMake**: `CMakeLists.txt` → `cmake --build .`

### モバイル・その他
- **Flutter**: `pubspec.yaml` → `flutter build`
- **Docker**: `Dockerfile` → `docker build`
- **Deno**: `deno.json` → `deno task build`

## 🚀 実行内容

1. **プロジェクト構成の自動検出**
   ```bash
   # 優先順位付きでプロジェクトタイプを検出
   detect_project_type() {
     # 1. Claude/Project設定をチェック
     check_custom_build_config

     # 2. 専門的なフレームワーク
     [ -f "next.config.js" ] && echo "nextjs"
     [ -f "vite.config.*" ] && echo "vite"
     [ -f "angular.json" ] && echo "angular"

     # 3. 一般的なプロジェクトタイプ
     [ -f "package.json" ] && echo "nodejs"
     [ -f "Cargo.toml" ] && echo "rust"
     [ -f "go.mod" ] && echo "go"
     [ -f "pom.xml" ] && echo "maven"
     [ -f "build.gradle" ] && echo "gradle"
     [ -f "pyproject.toml" ] && echo "python"
     [ -f "CMakeLists.txt" ] && echo "cmake"
     [ -f "Makefile" ] && echo "make"
   }
   ```

2. **依存関係チェック & 自動インストール**
   ```bash
   check_dependencies() {
     case $PROJECT_TYPE in
       nodejs)
         [ ! -d "node_modules" ] && !$PM install
         ;;
       rust)
         [ ! -f "Cargo.lock" ] && !cargo fetch
         ;;
       python)
         [ ! -d "venv" ] && !python -m venv venv && source venv/bin/activate
         ;;
     esac
   }
   ```

3. **スマートビルド実行**
   ```bash
   execute_build() {
     case $PROJECT_TYPE in
       nextjs)
         !$PM run build
         ;;
       vite)
         !$PM run build || !vite build
         ;;
       nodejs)
         !$PM run build || !$PM run compile
         ;;
       rust)
         !cargo build ${PROD_FLAG:+--release}
         ;;
       go)
         !go build ${PROD_FLAG:+-ldflags="-s -w"}
         ;;
       python)
         !python -m build
         ;;
     esac
   }
   ```

4. **ビルド後の検証**
   ```bash
   verify_build() {
     case $PROJECT_TYPE in
       nodejs)
         [ -d "dist" ] || [ -d "build" ] || [ -d ".next" ]
         ;;
       rust)
         [ -f "target/release/${PROJECT_NAME}" ] || [ -d "target/release" ]
         ;;
       go)
         [ -f "${PROJECT_NAME}" ] || ls *.exe 2>/dev/null
         ;;
     esac
   }
   ```

5. **エラー分析 & 解決策提案**
   ```bash
   analyze_build_error() {
     # 一般的なエラーパターンを検出
     # - 依存関係エラー → 自動インストール提案
     # - メモリ不足 → ヒープサイズ調整提案
     # - TypeScript エラー → 型チェック提案
   }
   ```

## 📝 使用例

```bash
# 基本ビルド（プロジェクトタイプ自動検出）
/build

# クリーンビルド（キャッシュクリア）
/build --clean

# プロダクションビルド（最適化あり）
/build --prod

# テスト含むビルド
/build --test

# 依存関係のみインストール
/build --deps

# ビルド可能性チェック（実際にはビルドしない）
/build --check

# 詳細ログ付きビルド
/build --verbose

# 複数オプション組み合わせ
/build --clean --prod --verbose
```

## ⚙️ プロジェクト固有の設定

### CLAUDE.md / PROJECT.md での設定
```markdown
## ビルド設定
- ビルドコマンド: `npm run custom-build`
- テストコマンド: `npm run test:all`
- プロダクションビルド: `npm run build:prod`
- クリーンコマンド: `npm run clean`
- ウォッチコマンド: `npm run dev`
```

### パッケージマネージャーの自動検出
```
pnpm-lock.yaml → pnpm
yarn.lock → yarn
package-lock.json → npm
```

### 環境変数サポート
```bash
# ビルド時に自動設定される環境変数
NODE_ENV=production  # --prod 使用時
CI=true             # CI環境検出時
```

## 🔧 スマート機能

### 1. 依存関係の自動管理
- `node_modules` 不存在 → 自動 `npm install`
- `Cargo.lock` 不存在 → 自動 `cargo fetch`
- Python `venv` 不存在 → 自動仮想環境作成

### 2. ビルドスクリプトの智能検出
- `package.json` scripts解析
- 利用可能なビルドコマンド提案
- フォールバック戦略（`build` → `compile` → `start`）

### 3. エラーハンドリング & 自動修復
- **メモリ不足**: Node.js ヒープサイズ調整提案
- **依存関係エラー**: 自動インストール試行
- **TypeScript エラー**: 型チェック・修正提案
- **ポートエラー**: 代替ポート提案

### 4. パフォーマンス最適化
- 並列ビルド対応（`--parallel` 自動検出）
- インクリメンタルビルド活用
- キャッシュ戦略の最適化

### 5. CI/CD 統合
- CI環境の自動検出
- ビルド時間測定
- アーティファクト情報の出力

## 🔗 関連コマンド

- `/test` - テストの実行（Jest、Pytest、Cargo test等）
- `/lint` - リンターの実行（ESLint、Clippy、Flake8等）
- `/dev` - 開発サーバーの起動
- `/deploy` - デプロイメント実行
- `/clean` - キャッシュ・成果物のクリーンアップ

## 🚨 トラブルシューティング

### よくある問題と解決策

**Q: ビルドが失敗する**
```bash
/build --verbose  # 詳細ログで原因調査
/build --check    # ビルド可能性の事前チェック
```

**Q: 依存関係エラー**
```bash
/build --deps     # 依存関係のみ再インストール
/build --clean    # キャッシュクリア後ビルド
```

**Q: プロジェクトタイプが誤検出される**
→ `CLAUDE.md` にカスタムビルドコマンドを記載