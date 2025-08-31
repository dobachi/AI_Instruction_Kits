#!/bin/bash
# generate-instruction.sh - モジュラー指示書生成スクリプト / Modular Instruction Generation Script

# i18nライブラリをソース
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/i18n.sh"

set -e

# デフォルト値
MODULAR_DIR="modular"
OUTPUT_FILE=""
MODULES=()
PRESET=""
VARIABLES=()
LIST_TYPE=""
LANG="ja"
VERBOSE=false

# ヘルプメッセージ
show_help() {
    MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
    MSG_OPTIONS=$(get_message "options" "Options" "オプション")
    MSG_MODULES_DESC=$(get_message "modules_desc" "List of module IDs to use" "使用するモジュールIDのリスト")
    MSG_PRESET_DESC=$(get_message "preset_desc" "Specify preset name" "プリセット名を指定")
    MSG_OUTPUT_DESC=$(get_message "output_desc" "Output file name" "出力ファイル名")
    MSG_VARIABLE_DESC=$(get_message "variable_desc" "Set variables (can be specified multiple times)" "変数を設定（複数指定可）")
    MSG_LIST_DESC=$(get_message "list_desc" "Show available items" "利用可能な要素を表示")
    MSG_METADATA_DESC=$(get_message "metadata_desc" "Show metadata summary for AI analysis" "AIが分析するためのメタデータサマリーを表示")
    MSG_LANG_DESC=$(get_message "lang_desc" "Language for modules (ja|en, default: ja)" "モジュール言語 (ja|en, デフォルト: ja)")
    MSG_VERBOSE_DESC=$(get_message "verbose_desc" "Use detailed version modules (default: concise)" "詳細版モジュールを使用 (デフォルト: 簡潔版)")
    MSG_HELP_DESC=$(get_message "help_desc" "Show this help" "このヘルプを表示")
    MSG_EXAMPLES=$(get_message "examples" "Examples" "例")
    MSG_DIRECT_MODULES=$(get_message "direct_modules" "Specify modules directly" "モジュールを直接指定")
    MSG_USE_PRESET=$(get_message "use_preset" "Use preset" "プリセットを使用")
    MSG_SPECIFY_VARIABLE=$(get_message "specify_variable" "Specify variables" "変数を指定")
    MSG_LIST_PRESETS=$(get_message "list_presets" "List available presets" "利用可能なプリセット一覧")
    MSG_LIST_MODULES=$(get_message "list_modules" "List available modules" "利用可能なモジュール一覧")
    
    cat << EOF
$MSG_USAGE: $0 [$MSG_OPTIONS]

$MSG_OPTIONS:
  --modules MODULE1 MODULE2 ...  $MSG_MODULES_DESC
  --preset PRESET_NAME          $MSG_PRESET_DESC
  --output FILE                 $MSG_OUTPUT_DESC
  --variable KEY=VALUE          $MSG_VARIABLE_DESC
  --list TYPE                   $MSG_LIST_DESC (presets|modules)
  --metadata                    $MSG_METADATA_DESC
  --lang LANG                   $MSG_LANG_DESC
  --verbose                     $MSG_VERBOSE_DESC
  --help                        $MSG_HELP_DESC

$MSG_EXAMPLES:
  # $MSG_DIRECT_MODULES
  $0 --modules core_role_definition task_code_generation --output api_instruction.md

  # $MSG_USE_PRESET
  $0 --preset web_api_production --output api_instruction.md

  # $MSG_SPECIFY_VARIABLE
  $0 --preset web_api_production --variable framework=FastAPI

  # $MSG_LIST_PRESETS
  $0 --list presets

  # $MSG_LIST_MODULES
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
        --lang)
            LANG="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            MSG_ERROR_UNKNOWN_OPTION=$(get_message "error_unknown_option" "Error: Unknown option" "エラー: 不明なオプション")
            echo "$MSG_ERROR_UNKNOWN_OPTION $1"
            show_help
            exit 1
            ;;
    esac
done

# プロジェクトルートディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
cd "$PROJECT_ROOT"

# Pythonスクリプトのパスを設定（サブモジュール環境対応）
COMPOSER_PY=""
if [[ -f "${MODULAR_DIR}/composer.py" ]]; then
    # 直接実行（AI指示書キット自体の開発時）
    COMPOSER_PY="${MODULAR_DIR}/composer.py"
elif [[ -f "instructions/ai_instruction_kits/${MODULAR_DIR}/composer.py" ]]; then
    # サブモジュール経由での実行（別プロジェクトでの使用時）
    COMPOSER_PY="instructions/ai_instruction_kits/${MODULAR_DIR}/composer.py"
else
    MSG_ERROR_NOT_FOUND=$(get_message "error_not_found" "Error: not found" "エラー: 見つかりません")
    echo "$MSG_ERROR_NOT_FOUND: ${MODULAR_DIR}/composer.py"
    echo "探索パス:"
    echo "  - ${MODULAR_DIR}/composer.py"
    echo "  - instructions/ai_instruction_kits/${MODULAR_DIR}/composer.py"
    exit 1
fi

# verboseフラグを追加
VERBOSE_FLAG=""
if [[ "$VERBOSE" == "true" ]]; then
    VERBOSE_FLAG="--verbose"
fi

# listコマンドまたはmetadataコマンドの処理
if [[ -n "$LIST_TYPE" ]]; then
    if [[ "$LIST_TYPE" == "metadata" ]]; then
        python3 "$COMPOSER_PY" --lang "$LANG" $VERBOSE_FLAG metadata
    else
        python3 "$COMPOSER_PY" --lang "$LANG" $VERBOSE_FLAG list "$LIST_TYPE"
    fi
    exit 0
fi

# モジュールとプリセットのいずれかが必須
if [[ ${#MODULES[@]} -eq 0 ]] && [[ -z "$PRESET" ]]; then
    MSG_ERROR_SPECIFY_ONE=$(get_message "error_specify_one" "Error: Please specify either --modules or --preset" "エラー: --modules または --preset のいずれかを指定してください")
    echo "$MSG_ERROR_SPECIFY_ONE"
    show_help
    exit 1
fi

# 両方指定された場合は許可（プリセット拡張機能）
# if [[ ${#MODULES[@]} -gt 0 ]] && [[ -n "$PRESET" ]]; then
#     MSG_ERROR_BOTH_SPECIFIED=$(get_message "error_both_specified" "Error: Cannot specify both --modules and --preset" "エラー: --modules と --preset は同時に指定できません")
#     echo "$MSG_ERROR_BOTH_SPECIFIED"
#     exit 1
# fi

# Pythonコンポーザーを呼び出す
if [[ -n "$PRESET" ]]; then
    # 事前生成プリセットの確認
    PRESET_FILE="instructions/$LANG/presets/${PRESET}.md"
    
    # 事前生成プリセットが存在する場合
    if [[ -f "$PRESET_FILE" ]] && [[ ${#MODULES[@]} -eq 0 ]]; then
        # タイムスタンプをチェック（モジュールが更新されていないか確認）
        PRESET_TIME=$(stat -c %Y "$PRESET_FILE" 2>/dev/null || stat -f %m "$PRESET_FILE" 2>/dev/null || echo "0")
        NEEDS_REGEN=false
        
        # 関連モジュールの更新チェック
        # プリセット定義ファイルをチェック
        PRESET_DEF="modular/presets/${PRESET}.yaml"
        if [[ -f "$PRESET_DEF" ]]; then
            # プリセット定義より新しいモジュールがあるかチェック
            for module_file in modular/modules/*/*.md; do
                if [[ -f "$module_file" ]]; then
                    MODULE_TIME=$(stat -c %Y "$module_file" 2>/dev/null || stat -f %m "$module_file" 2>/dev/null || echo "0")
                    if [[ "$MODULE_TIME" -gt "$PRESET_TIME" ]]; then
                        NEEDS_REGEN=true
                        MSG_MODULE_UPDATED=$(get_message "module_updated" "Module updated, regenerating preset" "モジュールが更新されているため、プリセットを再生成します")
                        echo "⚠️  $MSG_MODULE_UPDATED"
                        break
                    fi
                fi
            done
        fi
        
        if [[ "$NEEDS_REGEN" = false ]]; then
            # 事前生成版を使用
            if [[ -n "$OUTPUT_FILE" ]]; then
                cp "$PRESET_FILE" "$OUTPUT_FILE"
                MSG_USING_CACHED=$(get_message "using_cached" "Using pre-generated preset" "事前生成プリセットを使用")
                echo "✅ $MSG_USING_CACHED: $PRESET_FILE → $OUTPUT_FILE"
            else
                OUTPUT_FILE="modular/cache/${PRESET}_$(date +%Y%m%d_%H%M%S).md"
                mkdir -p "modular/cache"
                cp "$PRESET_FILE" "$OUTPUT_FILE"
                MSG_USING_CACHED=$(get_message "using_cached" "Using pre-generated preset" "事前生成プリセットを使用")
                echo "✅ $MSG_USING_CACHED: $PRESET_FILE → $OUTPUT_FILE"
            fi
            exit 0
        fi
    fi
    
    # プリセットを使用（オプションで追加モジュール）
    ARGS=("--lang" "$LANG")
    [[ -n "$VERBOSE_FLAG" ]] && ARGS+=($VERBOSE_FLAG)
    ARGS+=("preset" "$PRESET")
    
    # 追加モジュールがある場合
    if [[ ${#MODULES[@]} -gt 0 ]]; then
        ARGS+=("--modules")
        for module in "${MODULES[@]}"; do
            ARGS+=("$module")
        done
    fi
    
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=("-o" "$OUTPUT_FILE")
    for var in "${VARIABLES[@]}"; do
        ARGS+=("-v" "$var")
    done
    python3 "$COMPOSER_PY" "${ARGS[@]}"
else
    # モジュールを直接指定
    ARGS=("--lang" "$LANG")
    [[ -n "$VERBOSE_FLAG" ]] && ARGS+=($VERBOSE_FLAG)
    ARGS+=("modules")
    for module in "${MODULES[@]}"; do
        ARGS+=("$module")
    done
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=("-o" "$OUTPUT_FILE")
    for var in "${VARIABLES[@]}"; do
        ARGS+=("-v" "$var")
    done
    python3 "$COMPOSER_PY" "${ARGS[@]}"
fi