# OpenHandsでオープンソースモデルを使用するガイド

## 概要

このドキュメントは、OpenHandsでオープンソースの大規模言語モデル（LLM）を無料で使用する方法を体系的に説明します。2025年7月時点の最新モデルと設定方法を網羅しています。

## 背景と動機

### 現状の課題
- OpenHandsのデフォルトプロバイダーリストには有料モデルのみが表示される
- 多くの開発者が無料で使えるオプションを求めている
- オープンソースモデルの設定方法が分かりにくい

### 解決策
Ollama、Groq、Google AI Studioなどを活用し、最新の高品質オープンソースモデルを無料で利用可能にする。

## 2025年7月時点の最新オープンソースモデル

### 1. Llama 3.1シリーズ（Meta - 2024年7月リリース）
- **Llama 3.1 405B**: 最大規模、GPT-4レベルの性能
- **Llama 3.1 70B**: 高性能、実用的なサイズ
- **Llama 3.1 8B**: 軽量版、高速応答
- 特徴：128Kコンテキスト、多言語対応強化

### 2. Gemma 2シリーズ（Google - 2024年6月リリース）
- **Gemma 2 27B**: 新しい大規模モデル
- **Gemma 2 9B**: バランス型（推奨）
- **Gemma 2 2B**: 超軽量
- 特徴：効率的なアーキテクチャ、日本語性能向上

### 3. Qwen2.5シリーズ（Alibaba - 2024年9月リリース）
- **Qwen2.5 72B**: 中国語・英語・日本語に強い
- **Qwen2.5 32B**: 実用的サイズ
- **Qwen2.5 7B**: 軽量版
- 特徴：コード生成能力が高い、アジア言語に強い

### 4. DeepSeek-V2.5（2024年11月リリース）
- **DeepSeek-Coder-V2.5**: コード特化
- **DeepSeek-V2.5 236B MoE**: 超大規模
- 特徴：MoEアーキテクチャ、効率的な推論

### 5. Mistral最新モデル（2024年12月）
- **Mixtral 8x22B**: 大規模MoE
- **Mistral-Medium-2**: 中規模高性能
- **Mistral 7B v0.3**: 改良版軽量モデル
- 特徴：商用利用可、高速推論

### 6. コード特化最新モデル
- **Code Llama 70B**: Llama 3.1ベース
- **StarCoder2 15B**: 多言語プログラミング
- **WizardCoder-33B-V1.1**: 指示追従性が高い

## セットアップ方法

### 重要な注意事項

**ローカルCLIインストール版では環境変数は使用できません。** 必ず以下のいずれかの方法を使用してください：
1. 初回起動時の対話的設定
2. `~/.openhands/settings.json`ファイルの事前作成
3. `/settings`コマンドでの設定変更

環境変数はDockerでの実行時のみ有効です。

### 方法1: Ollama（完全ローカル・推奨）

#### インストール（2025年7月最新版）
```bash
# Linux/Mac/WSL
curl -fsSL https://ollama.com/install.sh | sh

# Windows (PowerShell管理者権限)
# winget install Ollama.Ollama
```

#### 最新モデルの準備
```bash
# 2025年7月時点のおすすめモデル
ollama pull llama3.1:8b        # Llama 3.1 8B（最新・推奨）
ollama pull gemma2:9b          # Gemma 2 9B
ollama pull qwen2.5:7b         # Qwen 2.5 7B
ollama pull deepseek-coder-v2  # コード特化
ollama pull mistral:7b-v0.3    # Mistral最新版

# インストール済みモデルの確認
ollama list
```

#### OpenHandsでの設定

**方法A: 設定ファイルを事前作成（推奨・ウィザードをスキップ）**

`~/.openhands/settings.json`を作成：
```json
{
  "llm_model": "ollama/llama3.1:8b",
  "llm_api_key": "ollama",
  "llm_base_url": "http://localhost:11434",
  "agent": "CodeActAgent",
  "language": "ja",
  "enable_default_condenser": true,
  "enable_sound_notifications": false,
  "enable_proactive_conversation_starters": true
}
```

その後、OpenHandsを起動：
```bash
openhands
```

**方法B: 対話的設定（初回のみ）**
```
openhands
# → "Select another provider" を選択
# → Provider: ollama
# → Model: llama3.1:8b
# → Base URL: http://localhost:11434
# → API Key: （空欄でEnter）
```

**方法C: Docker実行（環境変数使用可）**
```bash
docker run -it --rm \
  -e LLM_PROVIDER="ollama" \
  -e LLM_MODEL="llama3.1:8b" \
  -e LLM_BASE_URL="http://host.docker.internal:11434" \
  -v $(pwd):/workspace \
  ghcr.io/all-hands-ai/openhands:latest
```

### 方法2: Groq Cloud（無料枠・超高速）

#### 2025年7月時点の利用可能モデル
- llama-3.1-405b-reasoning（新規追加）
- llama-3.1-70b-versatile
- llama-3.1-8b-instant
- mixtral-8x7b-32768
- gemma2-9b-it

#### 無料枠（2025年7月時点）
- 30,000トークン/分
- 14,400リクエスト/日

#### OpenHandsでの設定

**方法A: 設定ファイルを事前作成（推奨）**

`~/.openhands/settings.json`：
```json
{
  "llm_model": "groq/llama-3.1-70b-versatile",
  "llm_api_key": "gsk_あなたのAPIキー",
  "llm_base_url": null,
  "agent": "CodeActAgent"
}
```

**方法B: Docker実行**
```bash
docker run -it --rm \
  -e LLM_PROVIDER="groq" \
  -e LLM_MODEL="llama-3.1-70b-versatile" \
  -e LLM_API_KEY="gsk_..." \
  -v $(pwd):/workspace \
  ghcr.io/all-hands-ai/openhands:latest
```

### 方法3: Together AI（新規追加・$25無料クレジット）

#### 2025年7月時点の利用可能モデル
- Llama-3.1-405B-Instruct
- Qwen2.5-72B-Instruct
- DeepSeek-V2.5
- Mixtral-8x22B

#### 設定ファイル（`~/.openhands/settings.json`）
```json
{
  "llm_model": "together/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
  "llm_api_key": "your-together-api-key",
  "llm_base_url": null,
  "agent": "CodeActAgent"
}
```

### 設定の変更方法

OpenHands実行中に設定を変更する場合：
```
/settings
# 対話的に設定を変更
```

## 2025年7月版 モデル選択ガイド

### ユースケース別推奨モデル

| ユースケース | 推奨モデル | 理由 |
|------------|-----------|------|
| 汎用コーディング | Llama 3.1 8B | 最新、バランス良好 |
| 高度なコード生成 | DeepSeek-Coder-V2.5 | コード特化、最新 |
| 日本語含む開発 | Qwen2.5 7B/32B | 日本語性能最高 |
| 超高速応答 | Groq + Llama 3.1 8B | クラウド最速 |
| 長文コンテキスト | Llama 3.1（128K対応） | 大規模プロジェクト |
| 低スペックPC | Gemma 2 2B | 超軽量、高効率 |

### システム要件（2025年7月更新）

| モデル | 最小RAM | 推奨RAM | GPU VRAM |
|--------|---------|---------|----------|
| Gemma 2 2B | 4GB | 8GB | 3GB |
| Llama 3.1 8B | 16GB | 32GB | 10GB |
| Gemma 2 9B | 16GB | 32GB | 12GB |
| Qwen2.5 7B | 16GB | 32GB | 10GB |
| DeepSeek-Coder 6.7B | 12GB | 24GB | 8GB |
| Llama 3.1 70B | 64GB | 128GB | 80GB |

## 実践的な使用例（2025年7月版）

### 例1: Next.js 14 App Router開発

**設定ファイル準備（`~/.openhands/config.toml`）：**
```toml
[llm]
provider = "ollama"
model = "llama3.1:8b"
base_url = "http://localhost:11434"
```

**使用例：**
```bash
# OpenHands起動
openhands

# タスク例
> Create a Next.js 14 app with App Router, Server Components, and Tailwind CSS
```

### 例2: AI/MLパイプライン構築

**Qwen2.5を使用（Python/MLに強い）：**
```toml
[llm]
provider = "ollama"
model = "qwen2.5:7b"
base_url = "http://localhost:11434"
```

**使用例：**
```bash
openhands

# タスク例
> Build a machine learning pipeline with scikit-learn and pandas for data preprocessing
```

### 例3: マイクロサービスAPI開発

**DeepSeek-Coder使用時：**
```bash
# 実行中に設定変更
/settings
# → プロバイダー: ollama
# → モデル: deepseek-coder-v2

# タスク例
> Create a FastAPI microservice with async endpoints and Pydantic validation
```

### 例4: 複数プロジェクトでの使い分け

**プロジェクトごとの設定ファイル：**
```bash
# プロジェクト1用（Web開発）
mkdir -p ~/project1/.openhands
cat > ~/project1/.openhands/config.toml << EOF
[llm]
provider = "groq"
model = "llama-3.1-70b-versatile"
api_key = "gsk_..."
EOF

# プロジェクト2用（データ分析）
mkdir -p ~/project2/.openhands
cat > ~/project2/.openhands/config.toml << EOF
[llm]
provider = "ollama"
model = "qwen2.5:32b"
base_url = "http://localhost:11434"
EOF

# 各プロジェクトディレクトリで実行
cd ~/project1 && openhands  # Groqを使用
cd ~/project2 && openhands  # Ollamaを使用
```

## パフォーマンス最適化（2025年版）

### 量子化オプション（メモリ削減）
```bash
# Q4量子化モデルの使用
ollama pull llama3.1:8b-q4_K_M  # 通常の1/4サイズ

# Q8量子化（品質重視）
ollama pull llama3.1:8b-q8_0
```

### Flash Attention対応
```bash
# Flash Attention v2対応モデル
export OLLAMA_FLASH_ATTENTION=1
```

### バッチ処理最適化
```toml
# ~/.openhands/config.toml
[performance]
batch_size = 8
max_concurrent_requests = 4
timeout = 300
```

## トラブルシューティング（2025年版）

### CUDA 12.x対応
```bash
# NVIDIA GPU最新ドライバー確認
nvidia-smi
# CUDA Version: 12.4以上推奨

# PyTorch 2.3+インストール
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
```

### Apple Silicon最適化
```bash
# Metal Performance Shaders利用
export OLLAMA_METAL=1

# Unified Memory活用
export OLLAMA_UNIFIED_MEMORY=1
```

### メモリ不足対策（最新）
```bash
# ページファイル/スワップ拡張
# Linux
sudo fallocate -l 32G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# モデルのアンロード
curl -X DELETE http://localhost:11434/api/models/llama3.1:8b
```

## 2025年の展望

### 今後リリース予定のモデル
- Llama 4（2025年後半予定）
- GPT-4.5相当のオープンソースモデル
- 1兆パラメータ級MoEモデル

### 技術トレンド
- より効率的な量子化技術
- エッジデバイス対応の強化
- マルチモーダル対応の拡大

## まとめ

2025年7月時点で、OpenHandsで使える高品質なオープンソースモデルは大幅に増加し、性能も向上しています。特に：

- **Llama 3.1シリーズ**：汎用性と性能のバランスが最良
- **Qwen2.5シリーズ**：日本語を含むアジア言語に最適
- **DeepSeek-V2.5**：コード生成に特化
- **Groqクラウド**：無料で超高速な推論

推奨構成（2025年7月版）：
1. **標準開発環境**: Ollama + Llama 3.1 8B
2. **日本語重視**: Ollama + Qwen2.5 7B  
3. **高速クラウド**: Groq + Llama 3.1 70B
4. **コード特化**: Ollama + DeepSeek-Coder-V2.5

## 関連リンク

- [Ollama公式サイト](https://ollama.com/)
- [Groq Console](https://console.groq.com/)
- [Together AI](https://together.ai/)
- [OpenHands Documentation](https://docs.all-hands.dev/)
- [Hugging Face Open LLM Leaderboard](https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard)

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-07-22
- **最終更新**: 2025-07-22
- **作成者**: AI Instruction Kits Project