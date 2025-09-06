# クイックスタート - 30秒でセットアップ

## ワンライナーインストール

プロジェクトのルートディレクトリで以下のコマンドを実行するだけ！

### 基本インストール（インタラクティブ）
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

または wget を使用:
```bash
wget -qO- https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

**注意:** copyモードを選択すると、リポジトリ全体（約10MB）がダウンロードされます。

### プリセット付き高速インストール

#### Web API開発
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset web_api --force
```

#### CLIツール開発
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset cli_tool --force
```

#### データ分析
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset data_analyst --force
```

### カスタムオプション

#### 英語版をインストール
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --lang en
```

#### フォークしたリポジトリから
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --repo https://github.com/yourname/fork.git
```

#### 全オプション指定
```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- \
  --mode submodule \
  --preset web_api \
  --lang ja \
  --force
```

## インストール後の使い方

### 1. AIツールに指示
```
「CLAUDE.mdを参照して、タスクを開始してください」
```

### 2. 進捗管理
```bash
# タスク開始
scripts/checkpoint.sh start "機能実装" 5

# 進捗確認
scripts/checkpoint.sh progress

# タスク完了
scripts/checkpoint.sh complete TASK-xxx "実装完了"
```

### 3. コミット
```bash
# AIの署名なしでクリーンにコミット
scripts/commit.sh "feat: 新機能追加"
```

## トラブルシューティング

### Gitがインストールされていない場合
```bash
# macOS
brew install git

# Ubuntu/Debian
sudo apt-get install git

# CentOS/RHEL
sudo yum install git
```

### 権限エラーが出る場合
```bash
# 実行権限を付与
chmod +x scripts/*.sh
```

### プロキシ環境の場合
```bash
# プロキシ設定を追加
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
curl -sSL ... | bash
```

## オプション一覧

| オプション | 説明 | デフォルト |
|-----------|------|------------|
| `--mode <mode>` | インストールモード (copy/clone/submodule) | submodule |
| `--lang <lang>` | 言語 (ja/en) | ja |
| `--preset <name>` | プリセット設定 | なし |
| `--repo <url>` | カスタムリポジトリURL | 公式リポジトリ |
| `--force` | 確認をスキップ | false |
| `--skip-claude` | Claude Codeコマンドをスキップ | false |
| `--skip-git-hooks` | Gitフックをスキップ | false |
| `--help` | ヘルプを表示 | - |

## さらに詳しく

- [完全なセットアップガイド](../README.md)
- [プロジェクト設定のカスタマイズ](./PROJECT_CUSTOMIZATION.md)
- [モジュラーシステムの使い方](./MODULAR_SYSTEM.md)