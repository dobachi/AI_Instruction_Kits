#!/bin/bash

# プリセット指示書一括生成スクリプト
# 用途: すべての定義済みプリセットから指示書を事前生成し、Git管理下に配置

set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# タイムスタンプ関数
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# ログ関数
log() {
    echo -e "${GREEN}[$(timestamp)]${NC} $1"
}

error() {
    echo -e "${RED}[$(timestamp)] ERROR:${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[$(timestamp)] WARNING:${NC} $1"
}

info() {
    echo -e "${BLUE}[$(timestamp)] INFO:${NC} $1"
}

# 使用方法表示
usage() {
    cat << EOF
使用方法: $(basename "$0") [オプション]

プリセット指示書を一括生成してGit管理下に配置します。

オプション:
    -h, --help          このヘルプを表示
    -l, --lang LANG     生成する言語（ja/en/all）デフォルト: all
    -p, --preset PRESET 特定のプリセットのみ生成
    -d, --dry-run       実際には生成せず、実行内容を表示
    -f, --force         既存ファイルを上書き
    -v, --validate      生成後に検証を実行
    --no-git            Git操作をスキップ

例:
    # すべてのプリセットを生成
    $(basename "$0")

    # 日本語のみ生成
    $(basename "$0") --lang ja

    # 特定のプリセットのみ生成
    $(basename "$0") --preset web_api_production

    # ドライラン（実行内容の確認）
    $(basename "$0") --dry-run

EOF
}

# デフォルト値
LANG="all"
PRESET=""
DRY_RUN=false
FORCE=false
VALIDATE=false
NO_GIT=false

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -l|--lang)
            LANG="$2"
            shift 2
            ;;
        -p|--preset)
            PRESET="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -v|--validate)
            VALIDATE=true
            shift
            ;;
        --no-git)
            NO_GIT=true
            shift
            ;;
        *)
            error "不明なオプション: $1"
            usage
            exit 1
            ;;
    esac
done

# 生成スクリプトの存在確認
GENERATE_SCRIPT="$SCRIPT_DIR/generate-instruction.sh"
if [ ! -f "$GENERATE_SCRIPT" ]; then
    error "generate-instruction.shが見つかりません: $GENERATE_SCRIPT"
    exit 1
fi

# 出力ディレクトリの設定
setup_directories() {
    local lang=$1
    local preset_dir="$PROJECT_ROOT/instructions/$lang/presets"
    
    if [ "$DRY_RUN" = true ]; then
        info "[DRY-RUN] ディレクトリ作成: $preset_dir"
    else
        mkdir -p "$preset_dir"
        log "ディレクトリ作成: $preset_dir"
    fi
}

# プリセット一覧取得
get_presets() {
    "$GENERATE_SCRIPT" --list presets 2>/dev/null | grep -E '^\s*-' | sed 's/^\s*-\s*//'
}

# プリセット生成
generate_preset() {
    local preset_name=$1
    local lang=$2
    local output_dir="$PROJECT_ROOT/instructions/$lang/presets"
    local output_file="$output_dir/${preset_name}.md"
    local temp_file="/tmp/preset_${preset_name}_${lang}_$$.md"
    
    # 既存ファイルチェック
    if [ -f "$output_file" ] && [ "$FORCE" = false ]; then
        warning "既存ファイルをスキップ: $output_file (--forceで上書き可能)"
        return 1
    fi
    
    if [ "$DRY_RUN" = true ]; then
        info "[DRY-RUN] 生成: $preset_name ($lang) → $output_file"
        return 0
    fi
    
    log "生成中: $preset_name ($lang)"
    
    # 言語オプションの設定
    local lang_opt=""
    if [ "$lang" = "en" ]; then
        lang_opt="--lang en"
    fi
    
    # プリセット生成
    if "$GENERATE_SCRIPT" --preset "$preset_name" $lang_opt --output "$temp_file" 2>/dev/null; then
        # ヘッダーコメント追加
        {
            echo "<!-- "
            echo "  自動生成されたプリセット指示書"
            echo "  プリセット: $preset_name"
            echo "  言語: $lang"
            echo "  生成日時: $(timestamp)"
            echo "  生成スクリプト: scripts/generate-all-presets.sh"
            echo "  "
            echo "  ⚠️ このファイルは自動生成されます。直接編集しないでください。"
            echo "  変更が必要な場合は、対応するモジュールまたはプリセット定義を編集してください。"
            echo "-->"
            echo ""
            cat "$temp_file"
        } > "$output_file"
        
        rm -f "$temp_file"
        log "  ✓ 生成完了: $output_file"
        return 0
    else
        error "  ✗ 生成失敗: $preset_name ($lang)"
        rm -f "$temp_file"
        return 1
    fi
}

# 生成されたファイルの検証
validate_preset() {
    local file=$1
    local errors=0
    
    # ファイルサイズチェック
    if [ ! -s "$file" ]; then
        error "  ✗ ファイルが空: $file"
        errors=$((errors + 1))
    fi
    
    # 必須セクションチェック
    if ! grep -q "^# " "$file"; then
        error "  ✗ タイトルが見つかりません: $file"
        errors=$((errors + 1))
    fi
    
    if ! grep -q "^## " "$file"; then
        warning "  ⚠ セクションが見つかりません: $file"
    fi
    
    # トークン数推定（簡易）
    local char_count=$(wc -m < "$file")
    local estimated_tokens=$((char_count / 4))  # 概算
    
    if [ $estimated_tokens -gt 20000 ]; then
        warning "  ⚠ 推定トークン数が多い: $file (~${estimated_tokens}トークン)"
    fi
    
    if [ $errors -eq 0 ]; then
        log "  ✓ 検証成功: $file"
        return 0
    else
        return 1
    fi
}

# メイン処理
main() {
    log "プリセット一括生成開始"
    
    # 言語リスト設定
    local languages=()
    case $LANG in
        all)
            languages=("ja" "en")
            ;;
        ja|en)
            languages=("$LANG")
            ;;
        *)
            error "不正な言語指定: $LANG (ja/en/allのいずれかを指定)"
            exit 1
            ;;
    esac
    
    # プリセットリスト取得
    local presets=()
    if [ -n "$PRESET" ]; then
        presets=("$PRESET")
    else
        mapfile -t presets < <(get_presets)
    fi
    
    if [ ${#presets[@]} -eq 0 ]; then
        error "プリセットが見つかりません"
        exit 1
    fi
    
    info "対象プリセット: ${presets[*]}"
    info "対象言語: ${languages[*]}"
    
    # 統計用変数
    local total=0
    local success=0
    local failed=0
    local skipped=0
    
    # 各言語・各プリセットで生成
    for lang in "${languages[@]}"; do
        log "言語: $lang の処理開始"
        setup_directories "$lang"
        
        for preset in "${presets[@]}"; do
            total=$((total + 1))
            if generate_preset "$preset" "$lang"; then
                success=$((success + 1))
                
                # 検証実行
                if [ "$VALIDATE" = true ] && [ "$DRY_RUN" = false ]; then
                    local output_file="$PROJECT_ROOT/instructions/$lang/presets/${preset}.md"
                    validate_preset "$output_file" || true
                fi
            else
                if [ -f "$PROJECT_ROOT/instructions/$lang/presets/${preset}.md" ] && [ "$FORCE" = false ]; then
                    skipped=$((skipped + 1))
                else
                    failed=$((failed + 1))
                fi
            fi
        done
    done
    
    # 結果サマリー
    echo ""
    log "========== 生成結果 =========="
    log "合計: $total"
    log "成功: $success"
    log "失敗: $failed"
    log "スキップ: $skipped"
    
    # Git操作
    if [ "$NO_GIT" = false ] && [ "$DRY_RUN" = false ] && [ $success -gt 0 ]; then
        echo ""
        log "Git操作"
        
        # 新規ファイルの追加
        cd "$PROJECT_ROOT"
        local new_files=$(git ls-files --others --exclude-standard instructions/*/presets/*.md)
        if [ -n "$new_files" ]; then
            info "新規ファイルをGitに追加:"
            echo "$new_files" | while read -r file; do
                git add "$file"
                echo "  + $file"
            done
        fi
        
        # 変更されたファイルの表示
        local modified_files=$(git diff --name-only instructions/*/presets/*.md)
        if [ -n "$modified_files" ]; then
            info "変更されたファイル:"
            echo "$modified_files" | while read -r file; do
                echo "  M $file"
            done
        fi
    fi
    
    # 終了メッセージ
    if [ $failed -gt 0 ]; then
        error "一部のプリセット生成に失敗しました"
        exit 1
    elif [ $success -eq 0 ] && [ $skipped -eq 0 ]; then
        warning "プリセットが生成されませんでした"
        exit 1
    else
        log "プリセット生成が完了しました"
    fi
}

# 実行
main