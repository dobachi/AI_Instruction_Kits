#!/bin/bash
# generate-instruction.sh - モジュラー指示書生成スクリプト
# 使用例:
#   ./scripts/generate-instruction.sh --modules task_web_api skill_tdd --output output.md
#   ./scripts/generate-instruction.sh --preset web_api_production
#   ./scripts/generate-instruction.sh --help

set -e

# デフォルト値
MODULAR_DIR="modular"
OUTPUT_FILE=""
MODULES=()
PRESET=""
VARIABLES=()
LIST_TYPE=""

# ヘルプメッセージ
show_help() {
    cat << EOF
使用方法: $0 [オプション]

オプション:
  --modules MODULE1 MODULE2 ...  使用するモジュールIDのリスト
  --preset PRESET_NAME          プリセット名を指定
  --output FILE                 出力ファイル名
  --variable KEY=VALUE          変数を設定（複数指定可）
  --list TYPE                   利用可能な要素を表示 (presets|modules)
  --metadata                    AIが分析するためのメタデータサマリーを表示
  --help                        このヘルプを表示

例:
  # モジュールを直接指定
  $0 --modules core_role_definition task_code_generation --output api_instruction.md

  # プリセットを使用
  $0 --preset web_api_production --output api_instruction.md

  # 変数を指定
  $0 --preset web_api_production --variable framework=FastAPI

  # 利用可能なプリセット一覧
  $0 --list presets

  # 利用可能なモジュール一覧
  $0 --list modules
EOF
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --modules)
            shift
            while [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-- ]]; do
                MODULES+=("$1")
                shift
            done
            ;;
        --preset)
            PRESET="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --variable)
            VARIABLES+=("$2")
            shift 2
            ;;
        --list)
            LIST_TYPE="$2"
            shift 2
            ;;
        --metadata)
            LIST_TYPE="metadata"
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "エラー: 不明なオプション $1"
            show_help
            exit 1
            ;;
    esac
done

# プロジェクトルートディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
cd "$PROJECT_ROOT"

# Pythonスクリプトのパスを設定
COMPOSER_PY="${MODULAR_DIR}/composer.py"

# composer.pyの存在確認
if [[ ! -f "$COMPOSER_PY" ]]; then
    echo "エラー: $COMPOSER_PY が見つかりません"
    exit 1
fi

# listコマンドまたはmetadataコマンドの処理
if [[ -n "$LIST_TYPE" ]]; then
    if [[ "$LIST_TYPE" == "metadata" ]]; then
        python3 "$COMPOSER_PY" metadata
    else
        python3 "$COMPOSER_PY" list "$LIST_TYPE"
    fi
    exit 0
fi

# モジュールとプリセットのいずれかが必須
if [[ ${#MODULES[@]} -eq 0 ]] && [[ -z "$PRESET" ]]; then
    echo "エラー: --modules または --preset のいずれかを指定してください"
    show_help
    exit 1
fi

# 両方指定された場合はエラー
if [[ ${#MODULES[@]} -gt 0 ]] && [[ -n "$PRESET" ]]; then
    echo "エラー: --modules と --preset は同時に指定できません"
    exit 1
fi

# Pythonコンポーザーを呼び出す
if [[ -n "$PRESET" ]]; then
    # プリセットを使用
    ARGS=("preset" "$PRESET")
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=("-o" "$OUTPUT_FILE")
    for var in "${VARIABLES[@]}"; do
        ARGS+=("-v" "$var")
    done
    python3 "$COMPOSER_PY" "${ARGS[@]}"
else
    # モジュールを直接指定
    ARGS=("modules")
    for module in "${MODULES[@]}"; do
        ARGS+=("$module")
    done
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=("-o" "$OUTPUT_FILE")
    for var in "${VARIABLES[@]}"; do
        ARGS+=("-v" "$var")
    done
    python3 "$COMPOSER_PY" "${ARGS[@]}"
fi