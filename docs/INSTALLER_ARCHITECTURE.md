# インストーラーアーキテクチャ

## 概要

AI指示書キットには2つのインストール方法があります：

1. **ワンライナーインストール** (`install.sh`)
2. **ローカルインストール** (`setup-project.sh`)

## install.sh（ワンライナー用）

### 用途
```bash
# インターネット経由で直接実行
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

### 特徴
- リポジトリのクローン不要
- プリセット機能付き
- インタラクティブモード
- 全モード対応（copy/clone/submodule）

### 動作フロー
```
1. ユーザー選択（モード、プリセット、言語）
   ↓
2. 環境チェック
   ↓
3. モード別処理:
   - copy: tarball全体をダウンロード → setup-project.sh実行
   - clone/submodule: 必要最小限をダウンロード → setup-project.sh実行
   ↓
4. プリセット適用（オプション）
   ↓
5. 完了
```

### copyモードの特別処理
```bash
# copyモードではリポジトリ全体が必要
if [ "$MODE" = "copy" ]; then
    # GitHubからtarballをダウンロード
    curl -sSL https://github.com/.../archive/refs/heads/main.tar.gz
    # 展開してsetup-project.shを実行
fi
```

## setup-project.sh（ローカル用）

### 用途
```bash
# リポジトリをクローン済みの環境で実行
git clone https://github.com/dobachi/AI_Instruction_Kits.git
cd AI_Instruction_Kits
./scripts/setup-project.sh --mode submodule
```

### 特徴
- ローカルファイルを使用
- 詳細な設定オプション
- バックアップ機能
- i18n対応

### 動作フロー
```
1. モード選択（対話式 or オプション指定）
   ↓
2. ディレクトリ作成
   ↓
3. モード別処理:
   - copy: ../をコピー
   - clone: git clone実行
   - submodule: git submodule add実行
   ↓
4. シンボリックリンク作成
   ↓
5. 設定ファイル生成
   ↓
6. 完了
```

## なぜ2つのスクリプト？

### 分離の理由

1. **責任の分離**
   - install.sh: リモート実行とプリセット管理
   - setup-project.sh: ローカル環境のセットアップ

2. **後方互換性**
   - 既存ユーザーはsetup-project.shを直接使用中
   - 変更による影響を最小化

3. **メンテナンス性**
   - 各スクリプトが単一責任
   - テストが容易

4. **柔軟性**
   - ワンライナー: 初心者向け、簡単
   - ローカル: 上級者向け、詳細設定

### 統合しない理由

1. **copyモードの複雑性**
   - setup-project.shは`${SCRIPT_DIR}/..`に依存
   - ワンライナーでは全体のダウンロードが必要

2. **ファイルサイズ**
   - 統合すると巨大なスクリプトに
   - ダウンロード時間が増加

3. **デバッグの困難さ**
   - 単一の巨大スクリプトはデバッグが困難
   - 分離により問題の切り分けが容易

## ベストプラクティス

### 新規ユーザー
```bash
# ワンライナーで簡単インストール
curl -sSL .../install.sh | bash -s -- --preset web_api --force
```

### 開発者
```bash
# フォークして独自カスタマイズ
git clone https://github.com/yourname/AI_Instruction_Kits.git
cd AI_Instruction_Kits
./scripts/setup-project.sh --mode submodule
```

### CI/CD
```bash
# 自動化環境での使用
curl -sSL .../install.sh | bash -s -- \
  --mode submodule \
  --preset cli_tool \
  --force \
  --skip-claude
```

## まとめ

現在のアーキテクチャは：
- **シンプル**: 各スクリプトが単一責任
- **柔軟**: 様々な使用ケースに対応
- **保守的**: 既存ユーザーへの影響なし
- **実用的**: 実際の使用で問題なし

この設計により、初心者から上級者まで、様々なニーズに対応できます。