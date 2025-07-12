#!/bin/bash
# 国際化（i18n）サポート用の共通ライブラリ

# 言語コードを検出
# デフォルトは英語（en）
detect_language() {
    local lang_code="${LANG%%_*}"
    
    # 日本語環境の場合
    if [[ "$lang_code" == "ja" ]]; then
        echo "ja"
    else
        # その他の場合は英語をデフォルト
        echo "en"
    fi
}

# 現在の言語を取得（キャッシュ付き）
get_current_language() {
    if [[ -z "$DETECTED_LANGUAGE" ]]; then
        export DETECTED_LANGUAGE=$(detect_language)
    fi
    echo "$DETECTED_LANGUAGE"
}

# メッセージを言語に応じて選択
# 使用例: get_message "start" "Starting" "開始"
get_message() {
    local key="$1"
    local en_msg="$2"
    local ja_msg="$3"
    local lang=$(get_current_language)
    
    if [[ "$lang" == "ja" ]]; then
        echo "$ja_msg"
    else
        echo "$en_msg"
    fi
}

# 複数行メッセージ用のヘルパー関数
# 使用例: print_multilang_message "key" <<EOF_EN
# English message
# EOF_EN
# <<EOF_JA
# 日本語メッセージ
# EOF_JA
print_multilang_message() {
    local key="$1"
    local lang=$(get_current_language)
    
    # 一時ファイルに出力を保存
    local temp_file=$(mktemp)
    cat > "$temp_file"
    
    # 言語に応じて適切な部分を抽出
    if [[ "$lang" == "ja" ]]; then
        awk '/^EOF_EN$/,/^EOF_JA$/{if(!/^EOF_/) next} /^EOF_JA$/,0{if(!/^EOF_/) print}' "$temp_file"
    else
        awk 'BEGIN{p=1} /^EOF_EN$/{p=0} p{print} /^EOF_EN$/{p=1}' "$temp_file" | head -n -1
    fi
    
    rm -f "$temp_file"
}

# エクスポート用の環境変数
export -f detect_language
export -f get_current_language
export -f get_message
export -f print_multilang_message