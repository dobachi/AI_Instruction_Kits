# GitHub CLI自動セットアップ機能

このプロジェクトは、Claude Code on the Web環境で自動的にGitHub CLIをセットアップする機能を提供します。

## 概要

`scripts/gh-setup.sh`は、リモート環境（Claude Code on the Web）で自動的にGitHub CLIをインストールし、認証を設定するスクリプトです。`.claude/settings.json`のSessionStartフックとして実行されます。

## 特徴

- **自動インストール**: SessionStartフックで自動実行
- **環境判別**: `CLAUDE_CODE_REMOTE=true`の環境でのみ動作
- **パス永続化**: `~/.local/bin`にインストールし、PATH設定も自動保持
- **バージョン指定**: `GH_SETUP_VERSION`環境変数でバージョン変更可能
- **認証設定**: `GH_TOKEN`または`GITHUB_TOKEN`で自動認証

## セットアップ方法

### このプロジェクト自体で使用する場合

既に`.claude/settings.json`が設定済みです。環境変数を設定するだけで使用できます。

#### Claude Code on the Webの設定

1. **GitHub トークンの設定**
   - Claude Code on the Webの設定画面で環境変数を追加
   - `GH_TOKEN`または`GITHUB_TOKEN`にPersonal Access Tokenを設定

2. **ネットワーク設定**
   - ネットワーク設定を「Full」または「Custom」に設定
   - Customの場合は`release-assets.githubusercontent.com`を許可リストに追加

3. **セッション開始**
   - 新しいセッションを開始すると自動的にGitHub CLIがインストールされます

### 他のプロジェクトで使用する場合

`scripts/setup-project.sh`を実行すると、自動的に配備されます。

```bash
# サブモジュールとして追加している場合
cd /path/to/your/project
bash instructions/ai_instruction_kits/scripts/setup-project.sh

# このリポジトリをクローンしている場合
bash /path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

セットアップ時にClaude Code設定を有効にすると、以下のファイルが配備されます：

- `scripts/gh-setup.sh` - GitHub CLI自動セットアップスクリプト
- `.claude/settings.json` - SessionStartフック設定（既存ファイルがない場合のみ）

既に`.claude/settings.json`が存在する場合は、手動で以下を追加してください：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash scripts/gh-setup.sh",
        "timeout": 120
      }
    ]
  }
}
```

## 設定オプション

### 環境変数

| 変数名 | 説明 | デフォルト値 |
|--------|------|--------------|
| `GH_SETUP_VERSION` | インストールするGitHub CLIのバージョン | `2.83.2` |
| `GH_TOKEN` | GitHub認証トークン（優先） | - |
| `GITHUB_TOKEN` | GitHub認証トークン（代替） | - |
| `CLAUDE_CODE_REMOTE` | リモート環境判定フラグ | - |

### GitHub Personal Access Token の作成

1. GitHubの設定画面を開く: https://github.com/settings/tokens
2. "Generate new token" → "Generate new token (classic)" を選択
3. 必要なスコープを選択（最小限の場合は`repo`のみ）
4. トークンを生成してコピー
5. Claude Code on the Webの環境変数に設定

## 動作確認

スクリプトが正しく動作しているか確認する方法：

```bash
# GitHub CLIがインストールされているか確認
which gh
# → /home/user/.local/bin/gh

# バージョン確認
gh --version
# → gh version 2.83.2 (...)

# 認証状態確認
gh auth status
# → ✓ Logged in to github.com as username (...)
```

## トラブルシューティング

### GitHub CLIがインストールされない

**原因**: ネットワーク設定が制限されている

**解決方法**:
- ネットワーク設定を「Full」に変更
- または「Custom」で`release-assets.githubusercontent.com`を許可

### 認証が失敗する

**原因**: トークンが設定されていない、または無効

**解決方法**:
- 環境変数`GH_TOKEN`または`GITHUB_TOKEN`が正しく設定されているか確認
- トークンの有効期限が切れていないか確認
- トークンに必要なスコープが付与されているか確認

### ローカル環境でもインストールされてしまう

**原因**: `CLAUDE_CODE_REMOTE`環境変数が誤って設定されている

**解決方法**:
- スクリプトは`CLAUDE_CODE_REMOTE=true`の場合のみ動作します
- ローカル環境では自動的にスキップされるはずです

## 参考

- 元になったプロジェクト: [oikon48/gh-setup-hooks](https://github.com/oikon48/gh-setup-hooks)
- GitHub CLI公式: https://cli.github.com/
- Claude Code on the Web: https://claude.ai/

## ライセンス

このスクリプトはMITライセンスの[gh-setup-hooks](https://github.com/oikon48/gh-setup-hooks)を参考に、独自実装したものです。

---

最終更新: 2026-01-17
