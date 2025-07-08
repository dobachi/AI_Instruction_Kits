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
DRY_RUN=false
LIST_MODULES=false
REFRESH_CACHE=false

# ヘルプメッセージ
show_help() {
    cat << EOF
使用方法: $0 [オプション]

オプション:
  --modules MODULE1 MODULE2 ...  使用するモジュールIDのリスト
  --preset PRESET_NAME          プリセット名を指定
  --output FILE                 出力ファイル名（デフォルト: 標準出力）
  --variable KEY=VALUE          変数を設定（複数指定可）
  --dry-run                     実際には生成せず、使用モジュールを表示
  --list                        利用可能なモジュール一覧を表示
  --refresh-cache               モジュールキャッシュを更新
  --help                        このヘルプを表示

例:
  # モジュールを直接指定
  $0 --modules task_web_api skill_tdd --output api_instruction.md

  # プリセットを使用
  $0 --preset web_api_production --output api_instruction.md

  # 変数を指定
  $0 --modules task_web_api --variable framework=FastAPI
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
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --list)
            LIST_MODULES=true
            shift
            ;;
        --refresh-cache)
            REFRESH_CACHE=true
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

# 特殊コマンドを先に処理
if [[ "$LIST_MODULES" == "true" ]]; then
    python3 "${MODULAR_DIR}/composer.py" --list
    exit 0
fi

if [[ "$REFRESH_CACHE" == "true" ]]; then
    python3 "${MODULAR_DIR}/composer.py" --refresh-cache
    exit 0
fi

# Pythonコンポーザーを呼び出す
ARGS=()
for module in "${MODULES[@]}"; do
    ARGS+=("--module" "$module")
done
[[ -n "$PRESET" ]] && ARGS+=("--preset" "$PRESET")
[[ -n "$OUTPUT_FILE" ]] && ARGS+=("--output" "$OUTPUT_FILE")
for var in "${VARIABLES[@]}"; do
    ARGS+=("--variable" "$var")
done
[[ "$DRY_RUN" == "true" ]] && ARGS+=("--dry-run")

python3 "${MODULAR_DIR}/composer.py" "${ARGS[@]}"