#!/usr/bin/env python3
"""
モジュールYAMLメタデータ検証スクリプト
各モジュールのメタデータファイルの妥当性を検証します
Module YAML metadata validation script
Validates the validity of each module's metadata file
"""

import yaml
import sys
import os
import json
from pathlib import Path


def get_lang():
    """Get current language from environment"""
    lang_env = os.environ.get('VALIDATE_LANG', os.environ.get('LANG', 'en'))
    return 'ja' if lang_env.startswith('ja') else 'en'


def get_message(key, en_msg, ja_msg):
    """Get message in appropriate language"""
    lang = get_lang()
    return ja_msg if lang == 'ja' else en_msg


def validate_module_yaml(file_path, category):
    """
    モジュールYAMLファイルを検証
    Validate module YAML file
    
    Args:
        file_path: YAMLファイルのパス / Path to YAML file
        category: モジュールカテゴリ（core, tasks, skills等） / Module category (core, tasks, skills, etc.)
    
    Returns:
        dict: 検証結果 / Validation result {
            'status': 'OK' | 'WARNING' | 'ERROR',
            'errors': [エラーメッセージのリスト / List of error messages],
            'warnings': [警告メッセージのリスト / List of warning messages]
        }
    """
    errors = []
    warnings = []
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = yaml.safe_load(f)
        
        if data is None:
            errors.append(get_message(
                'yaml_empty',
                'YAML file is empty',
                'YAMLファイルが空です'
            ))
            return {'status': 'ERROR', 'errors': errors, 'warnings': warnings}
        
        # 必須フィールドチェック / Check required fields
        required_fields = ['id', 'name', 'version', 'description']
        for field in required_fields:
            if field not in data:
                errors.append(get_message(
                    f'missing_field_{field}',
                    f'Required field "{field}" is missing',
                    f'必須フィールド「{field}」が欠落しています'
                ))
        
        # idの命名規則チェック
        if 'id' in data:
            # カテゴリ別のプレフィックス定義
            prefix_map = {
                'core': 'core_',
                'tasks': 'task_',
                'skills': 'skill_',
                'methods': 'method_',
                'domains': 'domain_',
                'roles': 'role_',
                'quality': 'quality_',
                'expertise': 'expertise_'
            }
            
            expected_prefix = prefix_map.get(category, f'{category[:-1]}_')
            
            if not data['id'].startswith(expected_prefix):
                warnings.append(get_message(
                    'id_naming_convention',
                    f'ID naming convention: Should start with "{expected_prefix}" (current: {data["id"]})',
                    f'idの命名規則: 「{expected_prefix}」で始まることを推奨（現在: {data["id"]}）'
                ))
        
        # versionフィールドの形式チェック
        if 'version' in data:
            version = str(data['version'])
            # セマンティックバージョニングの簡易チェック
            if not any([
                version.count('.') == 2,  # x.y.z形式
                version.replace('.', '').isdigit(),  # 数字とドットのみ
                version in ['1.0', '1.0.0', '0.1.0']  # よくある形式
            ]):
                warnings.append(get_message(
                    'version_format',
                    f'Version field should use semantic versioning (x.y.z) (current: {version})',
                    f'versionフィールドはセマンティックバージョニング（x.y.z）を推奨（現在: {version}）'
                ))
        
        # categoryフィールドの確認（存在する場合） / Check category field if exists
        if 'category' in data and data['category'] != category:
            warnings.append(get_message(
                'category_mismatch',
                f'Category field does not match directory (expected: {category}, actual: {data["category"]})',
                f'categoryフィールドがディレクトリと一致しません（期待値: {category}、実際: {data["category"]}）'
            ))
        
        # 配列フィールドの形式チェック / Check array field formats
        array_fields = ['tags', 'dependencies', 'prerequisites', 'compatible_tasks']
        for field in array_fields:
            if field in data and not isinstance(data[field], list):
                errors.append(get_message(
                    f'field_must_be_array_{field}',
                    f'{field} field must be an array',
                    f'{field}フィールドは配列形式である必要があります'
                ))
        
        # 文字列フィールドの形式チェック / Check string field formats
        string_fields = ['id', 'name', 'description', 'author']
        for field in string_fields:
            if field in data and not isinstance(data[field], str):
                errors.append(get_message(
                    f'field_must_be_string_{field}',
                    f'{field} field must be a string',
                    f'{field}フィールドは文字列形式である必要があります'
                ))
        
    except yaml.YAMLError as e:
        errors.append(get_message(
            'yaml_parse_error',
            f'YAML parse error: {str(e)}',
            f'YAMLパースエラー: {str(e)}'
        ))
    except Exception as e:
        errors.append(get_message(
            'unexpected_error',
            f'Unexpected error: {str(e)}',
            f'予期しないエラー: {str(e)}'
        ))
    
    # ステータス決定
    if errors:
        status = 'ERROR'
    elif warnings:
        status = 'WARNING'
    else:
        status = 'OK'
    
    return {
        'status': status,
        'errors': errors,
        'warnings': warnings
    }


def main():
    """メイン処理"""
    if len(sys.argv) != 3:
        print("Usage: validate_module_yaml.py <yaml_file_path> <category>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    category = sys.argv[2]
    
    # 検証実行
    result = validate_module_yaml(file_path, category)
    
    # JSON形式で結果を出力（シェルスクリプトから解析しやすいように）
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()