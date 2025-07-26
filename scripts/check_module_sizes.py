#!/usr/bin/env python3
"""
モジュールサイズチェックスクリプト
各モジュールファイルのサイズを検証し、基準に適合しているか確認します
Module size check script
Validates each module file size and checks compliance with standards
"""

import sys
import os
import re
from pathlib import Path
import json


def get_lang():
    """Get current language from environment"""
    lang_env = os.environ.get('VALIDATE_LANG', os.environ.get('LANG', 'en'))
    return 'ja' if lang_env.startswith('ja') else 'en'


def get_message(key, en_msg, ja_msg):
    """Get message in appropriate language"""
    lang = get_lang()
    return ja_msg if lang == 'ja' else en_msg


def count_lines(file_path):
    """Count non-empty lines in a file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            # 空行を除いた行数
            non_empty_lines = [line for line in lines if line.strip()]
            return len(lines), len(non_empty_lines)
    except Exception as e:
        return 0, 0


def estimate_tokens(file_path):
    """Estimate token count for a file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # 簡易的なトークン推定
        # 日本語: 1文字 ≈ 0.7トークン
        # 英語: 1単語 ≈ 1.3トークン
        # 混在の場合は平均的な値を使用
        
        # 日本語文字のカウント
        jp_chars = len(re.findall(r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9fff]', content))
        # 英語単語のカウント（簡易的）
        en_words = len(re.findall(r'\b[a-zA-Z]+\b', content))
        
        # トークン推定
        jp_tokens = jp_chars * 0.7
        en_tokens = en_words * 1.3
        
        return int(jp_tokens + en_tokens)
    except Exception as e:
        return 0


# サイズ基準定義
SIZE_STANDARDS = {
    'concise': {
        'recommended_lines': (50, 200),
        'warning_lines': 250,
        'error_lines': 300,
        'recommended_tokens': (1000, 4000),
        'warning_tokens': 5000,
        'error_tokens': 6000
    },
    'detailed': {
        'recommended_lines': (200, 600),
        'warning_lines': 800,
        'error_lines': 1000,
        'recommended_tokens': (4000, 16000),
        'warning_tokens': 18000,
        'error_tokens': 20000
    },
    'ratio': {
        'recommended': (2.5, 4.0),
        'warning': 5.0,
        'minimum': 1.5
    }
}


def check_module_size(file_path, is_detailed=False):
    """
    モジュールファイルのサイズをチェック
    Check module file size
    
    Returns:
        dict: チェック結果 {
            'status': 'OK' | 'WARNING' | 'ERROR',
            'total_lines': 総行数,
            'non_empty_lines': 非空行数,
            'estimated_tokens': 推定トークン数,
            'messages': [メッセージリスト]
        }
    """
    messages = []
    status = 'OK'
    
    # 行数カウント
    total_lines, non_empty_lines = count_lines(file_path)
    # トークン推定
    estimated_tokens = estimate_tokens(file_path)
    
    # 対応する基準を選択
    standards = SIZE_STANDARDS['detailed' if is_detailed else 'concise']
    
    # 行数チェック
    if non_empty_lines > standards['error_lines']:
        status = 'ERROR'
        messages.append(get_message(
            'lines_error',
            f'Line count ({non_empty_lines}) exceeds maximum ({standards["error_lines"]})',
            f'行数（{non_empty_lines}）が最大値（{standards["error_lines"]}）を超えています'
        ))
    elif non_empty_lines > standards['warning_lines']:
        if status != 'ERROR':
            status = 'WARNING'
        messages.append(get_message(
            'lines_warning',
            f'Line count ({non_empty_lines}) exceeds recommended maximum ({standards["warning_lines"]})',
            f'行数（{non_empty_lines}）が推奨最大値（{standards["warning_lines"]}）を超えています'
        ))
    elif non_empty_lines < standards['recommended_lines'][0]:
        if status == 'OK':
            status = 'WARNING'
        messages.append(get_message(
            'lines_too_few',
            f'Line count ({non_empty_lines}) is below recommended minimum ({standards["recommended_lines"][0]})',
            f'行数（{non_empty_lines}）が推奨最小値（{standards["recommended_lines"][0]}）を下回っています'
        ))
    
    # トークン数チェック
    if estimated_tokens > standards['error_tokens']:
        status = 'ERROR'
        messages.append(get_message(
            'tokens_error',
            f'Estimated tokens ({estimated_tokens}) exceeds maximum ({standards["error_tokens"]})',
            f'推定トークン数（{estimated_tokens}）が最大値（{standards["error_tokens"]}）を超えています'
        ))
    elif estimated_tokens > standards['warning_tokens']:
        if status != 'ERROR':
            status = 'WARNING'
        messages.append(get_message(
            'tokens_warning',
            f'Estimated tokens ({estimated_tokens}) exceeds recommended maximum ({standards["warning_tokens"]})',
            f'推定トークン数（{estimated_tokens}）が推奨最大値（{standards["warning_tokens"]}）を超えています'
        ))
    
    return {
        'status': status,
        'total_lines': total_lines,
        'non_empty_lines': non_empty_lines,
        'estimated_tokens': estimated_tokens,
        'messages': messages
    }


def check_module_pair(concise_path, detailed_path):
    """
    簡潔版と詳細版のペアをチェック
    Check concise and detailed module pair
    
    Returns:
        dict: ペアのチェック結果
    """
    result = {
        'concise': None,
        'detailed': None,
        'ratio_status': 'OK',
        'ratio_messages': []
    }
    
    # 簡潔版が存在する場合
    if os.path.exists(concise_path):
        result['concise'] = check_module_size(concise_path, is_detailed=False)
    
    # 詳細版が存在する場合
    if os.path.exists(detailed_path):
        result['detailed'] = check_module_size(detailed_path, is_detailed=True)
    
    # 両方存在する場合は比率をチェック
    if result['concise'] and result['detailed']:
        concise_lines = result['concise']['non_empty_lines']
        detailed_lines = result['detailed']['non_empty_lines']
        
        if concise_lines > 0:
            ratio = detailed_lines / concise_lines
            
            if ratio < SIZE_STANDARDS['ratio']['minimum']:
                result['ratio_status'] = 'WARNING'
                result['ratio_messages'].append(get_message(
                    'ratio_too_small',
                    f'Size ratio ({ratio:.2f}) is below minimum ({SIZE_STANDARDS["ratio"]["minimum"]})',
                    f'サイズ比率（{ratio:.2f}）が最小値（{SIZE_STANDARDS["ratio"]["minimum"]}）を下回っています'
                ))
            elif ratio > SIZE_STANDARDS['ratio']['warning']:
                result['ratio_status'] = 'WARNING'
                result['ratio_messages'].append(get_message(
                    'ratio_too_large',
                    f'Size ratio ({ratio:.2f}) exceeds recommended maximum ({SIZE_STANDARDS["ratio"]["warning"]})',
                    f'サイズ比率（{ratio:.2f}）が推奨最大値（{SIZE_STANDARDS["ratio"]["warning"]}）を超えています'
                ))
            elif not (SIZE_STANDARDS['ratio']['recommended'][0] <= ratio <= SIZE_STANDARDS['ratio']['recommended'][1]):
                result['ratio_status'] = 'WARNING'
                result['ratio_messages'].append(get_message(
                    'ratio_not_recommended',
                    f'Size ratio ({ratio:.2f}) is outside recommended range ({SIZE_STANDARDS["ratio"]["recommended"][0]}-{SIZE_STANDARDS["ratio"]["recommended"][1]})',
                    f'サイズ比率（{ratio:.2f}）が推奨範囲（{SIZE_STANDARDS["ratio"]["recommended"][0]}-{SIZE_STANDARDS["ratio"]["recommended"][1]}）外です'
                ))
    
    return result


def main():
    """メイン処理"""
    if len(sys.argv) < 2:
        print("Usage: check_module_sizes.py <module_file_path> [<module_file_path> ...]")
        sys.exit(1)
    
    results = []
    
    for file_path in sys.argv[1:]:
        if not os.path.exists(file_path):
            results.append({
                'file': file_path,
                'status': 'ERROR',
                'error': get_message(
                    'file_not_found',
                    'File not found',
                    'ファイルが見つかりません'
                )
            })
            continue
        
        # ファイル名から簡潔版/詳細版を判定
        base_name = os.path.basename(file_path)
        dir_name = os.path.dirname(file_path)
        
        if base_name.endswith('_detailed.md'):
            # 詳細版の場合
            module_name = base_name[:-12]  # _detailed.md を除去
            concise_path = os.path.join(dir_name, f"{module_name}.md")
            detailed_path = file_path
        else:
            # 簡潔版の場合
            module_name = base_name[:-3] if base_name.endswith('.md') else base_name
            concise_path = file_path
            detailed_path = os.path.join(dir_name, f"{module_name}_detailed.md")
        
        # ペアチェック
        pair_result = check_module_pair(concise_path, detailed_path)
        
        results.append({
            'module_name': module_name,
            'concise_path': concise_path if os.path.exists(concise_path) else None,
            'detailed_path': detailed_path if os.path.exists(detailed_path) else None,
            'results': pair_result
        })
    
    # JSON形式で結果を出力
    print(json.dumps(results, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()