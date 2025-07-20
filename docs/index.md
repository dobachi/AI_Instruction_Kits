---
layout: default
title: AI Instruction Kits
description: AIへの指示を構造的に管理・提供するシステム
lang: ja
---

# AI Instruction Kits

**AIとの対話を構造化し、再利用可能にする指示書管理システム**

[![GitHub Stars](https://img.shields.io/github/stars/dobachi/AI_Instruction_Kits?style=social)](https://github.com/dobachi/AI_Instruction_Kits)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 🎯 なぜAI指示書キットが必要か？

AIツール（Claude、ChatGPT、Gemini等）を使う際、こんな課題はありませんか？

- 同じような指示を何度も書いている
- チーム内で指示の品質にばらつきがある
- 過去に作った良い指示を忘れてしまう
- プロジェクト固有の制約を毎回説明している

**AI Instruction Kitsは、これらの課題を解決します！**

## ✨ 主な特徴

### 🧩 NEW! モジュラー指示書システム
- **動的に指示書を生成**：プロジェクトに合わせてカスタマイズ
- **6つのプリセット**：学術研究、ビジネスコンサル、データ分析など
- **5つの専門知識モジュール**：ソフトウェア工学、法令工学、機械学習、並列分散、データスペース

### 📚 構造化された指示書ライブラリ
- **7つのカテゴリ**で整理された指示書
- 日本語・英語の両方に対応
- すぐに使える実践的なテンプレート

### 🚀 簡単セットアップ
```bash
# 1行でプロジェクトに統合
bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

### 🔄 柔軟な統合モード
- **コピーモード**: Gitなしでシンプルに利用
- **クローンモード**: 独自カスタマイズ可能
- **サブモジュールモード**: バージョン管理に最適

### 📊 進捗管理機能
チェックポイント機能で、AIとの作業進捗を自動追跡

## 🎬 デモ

### 従来の方法
```bash
# AIに指示する例
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装して"

# 自動的に以下が実行される：
# 1. プロジェクト固有の設定を読み込み
# 2. 適切な指示書を選択
# 3. 進捗をチェックポイントに記録
```

### 🆕 モジュラーシステムを使った方法
```bash
# MODULE_COMPOSERが自動的に最適な指示書を生成
claude "Webサイトを作成してください"

# MODULE_COMPOSERが以下を実行：
# 1. タスクを分析してWebサイトプリセットを選択
# 2. 必要なモジュールを自動的に組み合わせ
# 3. プロジェクトに最適化された指示書を生成
# 4. 進捗をチェックポイントに記録
```

## 🛠️ 使用例

### ケース1: 個人開発者
```bash
# フォークしたリポジトリから指示書を使用
./setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone
```

### ケース2: 企業チーム
```bash
# 社内プライベートリポジトリを使用
./setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

### ケース3: オフライン環境
```bash
# Gitなしでローカルコピーを使用
./setup-project.sh --copy
```

## 📖 ドキュメント

- [クイックスタートガイド](quickstart)
- [機能詳細](features)
- [提案ドキュメント](proposals)
- [開発者向け情報](developers)
- [カスタマイズ方法](https://github.com/dobachi/AI_Instruction_Kits/blob/main/docs/HOW_TO_USE.md)

## 🤝 コントリビューション

新しい指示書の追加や改善提案を歓迎します！

1. リポジトリをフォーク
2. 新しい指示書を適切なカテゴリに追加
3. プルリクエストを送信

## 📄 ライセンス

- デフォルト: Apache License 2.0
- 個別の指示書: 各ファイルに記載されたライセンスが優先

## 🚀 今すぐ始める

<div style="text-align: center; margin: 2em 0;">
  <a href="quickstart" style="background-color: #0366d6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block; font-weight: bold;">
    クイックスタートガイドを見る →
  </a>
</div>

---

<div style="text-align: center; color: #666; margin-top: 3em;">
  Made with ❤️ by the AI Instruction Kits community
</div>