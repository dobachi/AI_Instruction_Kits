---
description: "プロジェクトに適したビルドコマンドを実行"
---

# プロジェクトビルド実行

プロジェクトの設定に基づいて適切なビルドコマンドを実行します。

## 使用方法

```
/build [options]
```

## オプション

- `--clean` - クリーンビルドを実行
- `--watch` - ウォッチモードでビルド（対応している場合）
- `--prod` - プロダクションビルド
- `--test` - テストも含めて実行

## 実行内容

1. **プロジェクトタイプの検出**
   ```bash
   # package.json の存在確認（Node.js/npm/yarn/pnpm）
   if [ -f "package.json" ]; then
     # package manager の検出
     if [ -f "pnpm-lock.yaml" ]; then
       PM="pnpm"
     elif [ -f "yarn.lock" ]; then
       PM="yarn"
     else
       PM="npm"
     fi
   fi
   
   # その他のプロジェクトタイプ
   # - Cargo.toml (Rust)
   # - pom.xml (Maven)
   # - build.gradle (Gradle)
   # - Makefile
   # - pyproject.toml (Python)
   # - go.mod (Go)
   ```

2. **ビルドコマンドの実行**
   ```bash
   # Node.js プロジェクト
   !$PM run build
   
   # Rust プロジェクト
   !cargo build --release
   
   # Python プロジェクト
   !python -m build
   
   # Go プロジェクト
   !go build
   
   # Makefile があれば
   !make
   ```

3. **ビルド後の確認**
   - ビルド成果物の存在確認
   - エラーの有無をチェック
   - 成功/失敗のレポート

## 使用例

```
/build
/build --clean
/build --prod
/build --test
```

## プロジェクト固有の設定

`CLAUDE.md` または `PROJECT.md` にビルドコマンドを記載しておくことで、カスタムビルドコマンドを使用できます：

```markdown
## ビルド設定
- ビルドコマンド: `npm run custom-build`
- テストコマンド: `npm run test:all`
- プロダクションビルド: `npm run build:prod`
```

## スマート機能

1. **依存関係の自動インストール**
   - `node_modules` がない場合は自動で `npm install` を実行
   - `Cargo.lock` がない場合は依存関係を解決

2. **ビルドスクリプトの検出**
   - package.json の scripts セクションを解析
   - 利用可能なビルドコマンドを提案

3. **エラーハンドリング**
   - ビルドエラーを分析して解決策を提案
   - 一般的な問題の自動修正を試行

## 関連コマンド

- `/test` - テストの実行
- `/lint` - リンターの実行
- `/dev` - 開発サーバーの起動