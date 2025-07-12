# Data Space 説明ウェブサイト

## 概要
Data Spaceについて説明するシンプルなウェブサイトです。

## ファイル構成
- `index.html` - メインのHTMLファイル
- `styles.css` - スタイルシート
- `README.md` - このファイル

## プレビュー方法

### 方法1: ファイルを直接開く
1. ファイルエクスプローラーで `test/data-space-website/index.html` を見つける
2. ダブルクリックしてブラウザで開く

### 方法2: Pythonの簡易サーバーを使用
```bash
cd test/data-space-website
python3 -m http.server 8000
```
ブラウザで http://localhost:8000 にアクセス

### 方法3: VS CodeのLive Server拡張機能
VS Codeを使用している場合は、Live Server拡張機能をインストールして、
index.htmlを右クリック → "Open with Live Server"を選択

## 内容
- Data Spaceの概要
- 主な特徴（セキュア、リアルタイム同期、ガバナンス、グローバル対応）
- アーキテクチャの説明
- ユースケース（製造業、医療、金融、スマートシティ）
- 導入ステップ

## カスタマイズ
- コンテンツの編集: `index.html`を編集
- スタイルの変更: `styles.css`を編集
- 画像の追加: 適切な画像ファイルを追加し、HTMLで参照