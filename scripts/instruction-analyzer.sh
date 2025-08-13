#!/bin/bash
# AI指示書分析エージェントスクリプト
# Claude Code's Task tool (agent) functionality for instruction analysis

set -e

# カラー設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
MODE="quality"
LANG="ja"
OUTPUT_FORMAT="markdown"
VERBOSE=false

# 使用方法表示
show_usage() {
    cat << EOF
使用方法: $(basename "$0") [OPTIONS]

AI指示書をClaude Codeのエージェント機能で分析します。

OPTIONS:
    -m, --mode MODE         分析モード (quality|duplicate|optimize|all)
                           デフォルト: quality
    -l, --lang LANG        言語 (ja|en|all)
                           デフォルト: ja
    -o, --output FORMAT    出力形式 (markdown|json|yaml)
                           デフォルト: markdown
    -v, --verbose          詳細出力
    -h, --help             このヘルプを表示

分析モード:
    quality    - 指示書の品質チェック
    duplicate  - 重複内容の検出
    optimize   - 最適化提案の生成
    all        - すべての分析を実行

例:
    # 日本語指示書の品質チェック
    $(basename "$0") -m quality -l ja

    # すべての言語で重複検出
    $(basename "$0") -m duplicate -l all

    # 詳細な最適化分析をJSON形式で出力
    $(basename "$0") -m optimize -o json -v

EOF
}

# エラー出力
error() {
    echo -e "${RED}エラー: $1${NC}" >&2
    exit 1
}

# 情報出力
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# 警告出力
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -l|--lang)
            LANG="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            error "不明なオプション: $1"
            ;;
    esac
done

# モードの検証
case $MODE in
    quality|duplicate|optimize|all)
        ;;
    *)
        error "無効なモード: $MODE"
        ;;
esac

# 言語の検証
case $LANG in
    ja|en|all)
        ;;
    *)
        error "無効な言語: $LANG"
        ;;
esac

# 出力形式の検証
case $OUTPUT_FORMAT in
    markdown|json|yaml)
        ;;
    *)
        error "無効な出力形式: $OUTPUT_FORMAT"
        ;;
esac

# 品質チェック用のプロンプト生成
generate_quality_prompt() {
    local lang_path="$1"
    cat << EOF
AI指示書キットの品質チェックを実行してください。

対象ディレクトリ: instructions/${lang_path}/

チェック項目:
1. 必須セクション（目的、使用方法、例）の有無
2. Markdownフォーマットの正確性
3. コード例の文法的正確性
4. 相互参照（他の指示書への参照）の整合性
5. メタデータ（YAMLファイル）との一致性

詳細チェック:
- 各指示書が独立して機能するか
- 指示が明確で曖昧さがないか
- 実例が適切で実行可能か
- カテゴリ分けが適切か

出力形式: ${OUTPUT_FORMAT}

${OUTPUT_FORMAT}形式で以下の構造で報告してください:
- total_files: チェックしたファイル数
- passed: 問題のないファイル数
- issues:
  - critical: 重大な問題（必須セクション欠如等）
  - warning: 警告レベルの問題
  - info: 改善提案
- summary: 全体的な品質評価（1-10のスコア）
EOF
}

# 重複検出用のプロンプト生成
generate_duplicate_prompt() {
    local lang_path="$1"
    cat << EOF
AI指示書キットの重複検出を実行してください。

対象ディレクトリ: instructions/${lang_path}/

検出対象:
1. 機能の重複（同じ目的を持つ複数の指示書）
2. 内容の類似性（70%以上の内容が類似）
3. 部分的な重複（セクション単位での重複）
4. 統合可能な指示書の組み合わせ

分析方法:
- 各指示書の主要機能を抽出
- 類似度スコアリング（0-100）
- 統合提案の生成

出力形式: ${OUTPUT_FORMAT}

${OUTPUT_FORMAT}形式で以下の構造で報告してください:
- duplicates: 重複グループのリスト
  - files: 重複しているファイルパス
  - similarity: 類似度スコア
  - type: 重複タイプ（full|partial|functional）
  - suggestion: 統合または削除の提案
- summary: 重複率と推奨アクション
EOF
}

# 最適化提案用のプロンプト生成
generate_optimize_prompt() {
    local lang_path="$1"
    cat << EOF
AI指示書キットの最適化提案を生成してください。

対象ディレクトリ: instructions/${lang_path}/

最適化の観点:
1. 構造の改善
   - ディレクトリ構造の最適化
   - カテゴリの再編成提案
   - 命名規則の統一

2. 内容の改善
   - 不足している指示書の特定
   - 既存指示書の改善点
   - モジュール化の提案

3. 使いやすさの向上
   - ナビゲーションの改善
   - 検索性の向上
   - 依存関係の明確化

4. パフォーマンス
   - 読み込み効率の改善
   - キャッシュ活用の提案

出力形式: ${OUTPUT_FORMAT}

${OUTPUT_FORMAT}形式で以下の構造で報告してください:
- optimizations:
  - category: 最適化カテゴリ
  - priority: 優先度（high|medium|low）
  - description: 詳細説明
  - impact: 期待される効果
  - effort: 実装工数（hours）
- roadmap: 実装ロードマップ提案
- estimated_improvement: 全体的な改善度（%）
EOF
}

# エージェントタスクの実行
run_agent_task() {
    local description="$1"
    local prompt="$2"
    
    if [ "$VERBOSE" = true ]; then
        info "エージェントタスク実行: $description"
        echo -e "${BLUE}プロンプト:${NC}"
        echo "$prompt"
        echo ""
    fi
    
    # ここでClaude CodeのTask toolを使用
    # 実際の実装では、Claude Code CLIまたはAPIを通じて
    # Task toolを呼び出す必要があります
    
    cat << EOF

=== エージェントタスク設定 ===
Description: $description
Subagent Type: general-purpose

タスクプロンプト:
$prompt

=== 実行準備完了 ===

このスクリプトをClaude Code内で実行する場合、
Task toolを使用して上記のプロンプトでエージェントを起動します。

使用例（Claude Code内）:
Task({
    description: "$description",
    prompt: \`$prompt\`,
    subagent_type: "general-purpose"
})

EOF
}

# メイン処理
main() {
    info "AI指示書分析を開始します"
    info "モード: $MODE, 言語: $LANG, 出力形式: $OUTPUT_FORMAT"
    
    # 言語パスの設定
    local lang_paths=()
    case $LANG in
        ja)
            lang_paths=("ja")
            ;;
        en)
            lang_paths=("en")
            ;;
        all)
            lang_paths=("ja" "en")
            ;;
    esac
    
    # モードに応じた処理
    for lang_path in "${lang_paths[@]}"; do
        info "言語: $lang_path の分析を開始"
        
        case $MODE in
            quality)
                prompt=$(generate_quality_prompt "$lang_path")
                run_agent_task "品質チェック-$lang_path" "$prompt"
                ;;
            duplicate)
                prompt=$(generate_duplicate_prompt "$lang_path")
                run_agent_task "重複検出-$lang_path" "$prompt"
                ;;
            optimize)
                prompt=$(generate_optimize_prompt "$lang_path")
                run_agent_task "最適化提案-$lang_path" "$prompt"
                ;;
            all)
                # すべての分析を実行
                info "品質チェックを実行中..."
                prompt=$(generate_quality_prompt "$lang_path")
                run_agent_task "品質チェック-$lang_path" "$prompt"
                
                info "重複検出を実行中..."
                prompt=$(generate_duplicate_prompt "$lang_path")
                run_agent_task "重複検出-$lang_path" "$prompt"
                
                info "最適化提案を生成中..."
                prompt=$(generate_optimize_prompt "$lang_path")
                run_agent_task "最適化提案-$lang_path" "$prompt"
                ;;
        esac
    done
    
    info "分析が完了しました"
}

# スクリプト実行
main