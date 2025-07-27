#!/bin/bash
# test_preset_customization.sh - プリセットカスタマイズ機能のテスト

# エラーが発生しても続行（各テストで個別に処理）
set +e

# テスト用の作業ディレクトリ
TEST_DIR="/tmp/ai_instruction_test_$$"
mkdir -p "$TEST_DIR"

# 色付き出力
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# テスト結果のカウンタ
PASSED=0
FAILED=0

# テスト結果を表示する関数
print_result() {
    local test_name="$1"
    local result="$2"
    
    if [[ "$result" == "PASS" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $test_name"
        ((FAILED++))
    fi
}

# プロジェクトルートに移動
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== プリセットカスタマイズ機能テスト ==="
echo "作業ディレクトリ: $TEST_DIR"
echo ""

# テスト1: 基本的なプリセット使用（後方互換性）
echo "テスト1: 基本的なプリセット使用"
./scripts/generate-instruction.sh --preset technical_writer --output "test1.md" >/dev/null 2>&1
if [[ -f "modular/cache/test1.md" ]] && grep -q "technical_writer" "modular/cache/test1.md"; then
    print_result "基本的なプリセット使用" "PASS"
else
    print_result "基本的なプリセット使用" "FAIL"
fi

# テスト2: プリセット + 追加モジュール
echo -e "\nテスト2: プリセット + 追加モジュール"
./scripts/generate-instruction.sh --preset technical_writer --modules skill_code_documentation --output "test2.md" >/dev/null 2>&1
if [[ -f "modular/cache/test2.md" ]]; then
    if grep -q "追加モジュール.*skill_code_documentation" "modular/cache/test2.md"; then
        print_result "追加モジュール情報の表示" "PASS"
    else
        print_result "追加モジュール情報の表示" "FAIL"
    fi
    
    if grep -q "コードドキュメント" "modular/cache/test2.md"; then
        print_result "追加モジュールの内容反映" "PASS"
    else
        print_result "追加モジュールの内容反映" "FAIL"
    fi
else
    print_result "プリセット + 追加モジュール" "FAIL"
fi

# テスト3: プリセット + 複数の追加モジュール
echo -e "\nテスト3: プリセット + 複数の追加モジュール"
./scripts/generate-instruction.sh --preset cli_tool_basic --modules skill_testing skill_performance --output "test3.md" >/dev/null 2>&1
if [[ -f "modular/cache/test3.md" ]]; then
    if grep -q "skill_testing, skill_performance" "modular/cache/test3.md"; then
        print_result "複数モジュールの表示" "PASS"
    else
        print_result "複数モジュールの表示" "FAIL"
    fi
else
    print_result "プリセット + 複数モジュール" "FAIL"
fi

# テスト4: プリセット + モジュール + 変数オーバーライド
echo -e "\nテスト4: プリセット + モジュール + 変数オーバーライド"
./scripts/generate-instruction.sh --preset web_api_production --modules skill_authentication --variable framework=FastAPI --output "test4.md" >/dev/null 2>&1
if [[ -f "modular/cache/test4.md" ]]; then
    if grep -q "FastAPI" "modular/cache/test4.md"; then
        print_result "変数オーバーライド" "PASS"
    else
        print_result "変数オーバーライド" "FAIL"
    fi
else
    print_result "プリセット + モジュール + 変数" "FAIL"
fi

# テスト5: モジュールの重複排除
echo -e "\nテスト5: モジュールの重複排除"
# web_api_productionプリセットにはskill_api_designが含まれている
./scripts/generate-instruction.sh --preset web_api_production --modules skill_api_design skill_caching --output "test5.md" >/dev/null 2>&1
if [[ -f "modular/cache/test5.md" ]]; then
    # skill_api_designが重複していないことを確認
    API_DESIGN_COUNT=$(grep -o "API設計" "modular/cache/test5.md" | wc -l)
    if [[ $API_DESIGN_COUNT -lt 5 ]]; then  # 適度な出現回数（重複していない）
        print_result "モジュール重複排除" "PASS"
    else
        print_result "モジュール重複排除" "FAIL"
    fi
else
    print_result "重複排除テスト" "FAIL"
fi

# テスト6: ヘルプメッセージの確認
echo -e "\nテスト6: ヘルプメッセージ"
HELP_OUTPUT=$(./scripts/generate-instruction.sh --help 2>&1)
if echo "$HELP_OUTPUT" | grep -q "preset.*modules"; then
    print_result "ヘルプメッセージ更新" "PASS"
else
    print_result "ヘルプメッセージ更新" "FAIL"
fi

# テスト7: 無効なモジュールの処理
echo -e "\nテスト7: 無効なモジュールの処理"
OUTPUT=$(./scripts/generate-instruction.sh --preset technical_writer --modules invalid_module --output "test7.md" 2>&1)
if echo "$OUTPUT" | grep -q "警告: 追加モジュールが見つかりません: invalid_module"; then
    print_result "無効なモジュール警告" "PASS"
else
    print_result "無効なモジュール警告" "FAIL"
fi

# テスト8: Blueprintフォーマットのプリセット
echo -e "\nテスト8: Blueprintフォーマットのプリセット"
./scripts/generate-instruction.sh --preset academic_researcher --modules skill_systems_thinking --output "test8.md" >/dev/null 2>&1
if [[ -f "modular/cache/test8.md" ]]; then
    if grep -q "システム思考" "modular/cache/test8.md"; then
        print_result "Blueprintプリセット + モジュール" "PASS"
    else
        print_result "Blueprintプリセット + モジュール" "FAIL"
    fi
else
    print_result "Blueprintプリセットテスト" "FAIL"
fi

# 結果サマリー
echo -e "\n=== テスト結果サマリー ==="
echo -e "成功: ${GREEN}$PASSED${NC}"
echo -e "失敗: ${RED}$FAILED${NC}"

# クリーンアップ
rm -rf "$TEST_DIR"

# 終了コード
if [[ $FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}すべてのテストが成功しました！${NC}"
    exit 0
else
    echo -e "\n${RED}いくつかのテストが失敗しました。${NC}"
    exit 1
fi