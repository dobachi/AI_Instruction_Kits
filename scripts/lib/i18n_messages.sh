#!/bin/bash
# 共通メッセージカタログ
# Common message catalog for i18n

# This file can be used to centralize common messages across scripts
# Usage: source this file after i18n.sh

# Common error messages
MSG_ERROR_UNKNOWN_OPTION_EN="Error: Unknown option"
MSG_ERROR_UNKNOWN_OPTION_JA="エラー: 不明なオプション"

MSG_ERROR_NOT_FOUND_EN="Error: not found"
MSG_ERROR_NOT_FOUND_JA="エラー: 見つかりません"

MSG_ERROR_REQUIRED_EN="Error: required"
MSG_ERROR_REQUIRED_JA="エラー: 必須"

# Common labels
MSG_USAGE_EN="Usage"
MSG_USAGE_JA="使用方法"

MSG_EXAMPLE_EN="Example"
MSG_EXAMPLE_JA="例"

MSG_OPTIONS_EN="Options"
MSG_OPTIONS_JA="オプション"

MSG_HELP_EN="Help"
MSG_HELP_JA="ヘルプ"

MSG_YES_EN="yes"
MSG_YES_JA="はい"

MSG_NO_EN="no"
MSG_NO_JA="いいえ"

MSG_COMPLETED_EN="Completed"
MSG_COMPLETED_JA="完了"

MSG_FAILED_EN="Failed"
MSG_FAILED_JA="失敗"

MSG_STARTING_EN="Starting"
MSG_STARTING_JA="開始"

MSG_PROCESSING_EN="Processing"
MSG_PROCESSING_JA="処理中"

# Function to get common messages
get_common_message() {
    local key="$1"
    local lang=$(get_current_language)
    
    case "$key" in
        "error_unknown_option")
            [[ "$lang" == "ja" ]] && echo "$MSG_ERROR_UNKNOWN_OPTION_JA" || echo "$MSG_ERROR_UNKNOWN_OPTION_EN"
            ;;
        "error_not_found")
            [[ "$lang" == "ja" ]] && echo "$MSG_ERROR_NOT_FOUND_JA" || echo "$MSG_ERROR_NOT_FOUND_EN"
            ;;
        "error_required")
            [[ "$lang" == "ja" ]] && echo "$MSG_ERROR_REQUIRED_JA" || echo "$MSG_ERROR_REQUIRED_EN"
            ;;
        "usage")
            [[ "$lang" == "ja" ]] && echo "$MSG_USAGE_JA" || echo "$MSG_USAGE_EN"
            ;;
        "example")
            [[ "$lang" == "ja" ]] && echo "$MSG_EXAMPLE_JA" || echo "$MSG_EXAMPLE_EN"
            ;;
        "options")
            [[ "$lang" == "ja" ]] && echo "$MSG_OPTIONS_JA" || echo "$MSG_OPTIONS_EN"
            ;;
        "help")
            [[ "$lang" == "ja" ]] && echo "$MSG_HELP_JA" || echo "$MSG_HELP_EN"
            ;;
        "yes")
            [[ "$lang" == "ja" ]] && echo "$MSG_YES_JA" || echo "$MSG_YES_EN"
            ;;
        "no")
            [[ "$lang" == "ja" ]] && echo "$MSG_NO_JA" || echo "$MSG_NO_EN"
            ;;
        "completed")
            [[ "$lang" == "ja" ]] && echo "$MSG_COMPLETED_JA" || echo "$MSG_COMPLETED_EN"
            ;;
        "failed")
            [[ "$lang" == "ja" ]] && echo "$MSG_FAILED_JA" || echo "$MSG_FAILED_EN"
            ;;
        "starting")
            [[ "$lang" == "ja" ]] && echo "$MSG_STARTING_JA" || echo "$MSG_STARTING_EN"
            ;;
        "processing")
            [[ "$lang" == "ja" ]] && echo "$MSG_PROCESSING_JA" || echo "$MSG_PROCESSING_EN"
            ;;
        *)
            echo "$key"
            ;;
    esac
}