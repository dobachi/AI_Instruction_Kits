# Codexビルドアシスタント

ユーザーが `/build` に続けて入力したテキストをオプション文字列として扱い、最適なビルド手順を選択してください。わからない場合は必ず確認してから進めます。

## 実行フロー
1. **オプション解析**  
   - `--clean`, `--watch`, `--prod`, `--test`, `--deps`, `--check`, `--verbose` の有無を判定し、挙動に反映します。  
   - 想定外のフラグが紛れ込んだ場合はそのまま実行せず、ユーザーに確認します。
2. **プロジェクトタイプ検出**  
   - 代表的な構成ファイルを探索し、最も適合するビルドコマンドを選びます。優先順位の目安:
     - Next.js `next.config.*`
     - Vite `vite.config.*`
     - Angular `angular.json`
     - Node.js/React/Vue `package.json`
     - Rust `Cargo.toml`
     - Go `go.mod`
     - Python `pyproject.toml`
     - Java (Maven/Gradle) `pom.xml` / `build.gradle`
     - C/C++ `CMakeLists.txt` / `Makefile`
     - Flutter `pubspec.yaml`
     - Docker `Dockerfile`
     - Deno `deno.json`
   - 複数候補が見つかった場合は、ユーザーとすり合わせます。
3. **依存関係の確認**  
   - Node.js 系なら `npm install`/`yarn install`/`pnpm install` の必要性を確認。  
   - その他の言語でも lockfile や依存ディレクトリの有無を確認し、必要に応じてインストールまたは準備コマンドを実行します。
4. **ビルド実行**  
   - 選択したプロジェクトタイプに応じて適切なコマンドを実行します。例:
     - Node.js/Vite/Next.js: `npm run build` 等
     - Rust: `cargo build --release` (本番時) または `cargo build`
     - Go: `go build`
     - Python: `python -m build`
     - Maven: `mvn compile`
     - Gradle: `gradle build`
     - Make/CMake: `make` または `cmake --build .`
   - `--prod` や `--watch` などのフラグに応じてコマンドを調整します。
5. **ビルド結果の検証**  
   - 成果物ディレクトリ（例: `dist`, `build`, `.next`, `target/release` 等）や生成バイナリの存在を確認します。  
   - `--test` が指定されていれば、ビルド後にテストコマンドを実行します。例: `npm test`, `cargo test`, `pytest`。
6. **エラー解析と報告**  
   - 失敗した場合はエラーログの要点を読み取り、考えられる原因と対処案を提示します。

## コマンド実行時の注意
- 破壊的な操作や大量の依存関係インストールが必要な場合は、事前にユーザーへ許可を求めます。
- 既存のビルド成果物を削除する前に、削除対象と理由を明示します。
- 長時間かかる処理は、開始前に概算時間を共有します。

## 追加タスク
- ビルド後に生成物を開く／デプロイする必要があれば、ユーザーに確認した上で進めます。
- プロジェクトに固有のビルドスクリプトが存在する場合は、該当ドキュメントや `package.json` の `scripts` セクションを参照して調整します。
