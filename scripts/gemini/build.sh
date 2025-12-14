#!/bin/bash
set -e

# 引数を解析
CLEAN=false
WATCH=false
PROD=false
TEST=false
ARGS=""

for arg in "$@"; do
  case $arg in
    --clean)
      CLEAN=true
      shift
      ;;
    --watch)
      WATCH=true
      shift
      ;;
    --prod)
      PROD=true
      shift
      ;;
    --test)
      TEST=true
      shift
      ;;
    *)
      ARGS="$ARGS $1"
      shift
      ;;
  esac
done

# プロジェクトタイプの検出とビルドコマンドの実行
if [ -f "pnpm-lock.yaml" ]; then
    PM="pnpm"
    echo "📦 pnpm プロジェクトを検出しました。"
    if [ ! -d "node_modules" ]; then
        echo "💨 依存関係をインストールします: $PM install"
        $PM install
    fi
    echo "🚀 ビルドコマンドを実行します: $PM run build $ARGS"
    $PM run build $ARGS
elif [ -f "yarn.lock" ]; then
    PM="yarn"
    echo "📦 yarn プロジェクトを検出しました。"
    if [ ! -d "node_modules" ]; then
        echo "💨 依存関係をインストールします: $PM install"
        $PM install
    fi
    echo "🚀 ビルドコマンドを実行します: $PM run build $ARGS"
    $PM run build $ARGS
elif [ -f "package.json" ]; then
    PM="npm"
    echo "📦 npm プロジェクトを検出しました。"
    if [ ! -d "node_modules" ]; then
        echo "💨 依存関係をインストールします: $PM install"
        $PM install
    fi
    echo "🚀 ビルドコマンドを実行します: $PM run build $ARGS"
    $PM run build $ARGS
elif [ -f "Cargo.toml" ]; then
    echo "📦 Rust プロジェクトを検出しました。"
    BUILD_CMD="cargo build"
    if [ "$PROD" = true ]; then
        BUILD_CMD="$BUILD_CMD --release"
    fi
    echo "🚀 ビルドコマンドを実行します: $BUILD_CMD $ARGS"
    eval "$BUILD_CMD $ARGS"
elif [ -f "pyproject.toml" ]; then
    echo "📦 Python プロジェクトを検出しました。"
    echo "🚀 ビルドコマンドを実行します: python3 -m build $ARGS"
    python3 -m build $ARGS
elif [ -f "go.mod" ]; then
    echo "📦 Go プロジェクトを検出しました。"
    echo "🚀 ビルドコマンドを実行します: go build $ARGS"
    go build $ARGS
elif [ -f "Makefile" ]; then
    echo "📦 Makefile を検出しました。"
    TARGET="build"
    if [ "$CLEAN" = true ]; then
        TARGET="clean"
    fi
    echo "🚀 ビルドコマンドを実行します: make $TARGET $ARGS"
    make $TARGET $ARGS
else
    echo "❌ ビルド可能なプロジェクトタイプを検出できませんでした。"
    exit 1
fi

echo "✅ ビルドが完了しました。"
