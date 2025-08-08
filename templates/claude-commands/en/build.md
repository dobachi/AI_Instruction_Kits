---
description: "Execute project-appropriate build commands"
---

# Project Build Execution

Execute appropriate build commands based on project configuration.

## Usage

```
/build [options]
```

## Options

- `--clean` - Execute clean build
- `--watch` - Build in watch mode (if supported)
- `--prod` - Production build
- `--test` - Include tests in build

## Execution Flow

1. **Project Type Detection**
   ```bash
   # Check for package.json (Node.js/npm/yarn/pnpm)
   if [ -f "package.json" ]; then
     # Detect package manager
     if [ -f "pnpm-lock.yaml" ]; then
       PM="pnpm"
     elif [ -f "yarn.lock" ]; then
       PM="yarn"
     else
       PM="npm"
     fi
   fi
   
   # Other project types
   # - Cargo.toml (Rust)
   # - pom.xml (Maven)
   # - build.gradle (Gradle)
   # - Makefile
   # - pyproject.toml (Python)
   # - go.mod (Go)
   ```

2. **Build Command Execution**
   ```bash
   # Node.js project
   !$PM run build
   
   # Rust project
   !cargo build --release
   
   # Python project
   !python -m build
   
   # Go project
   !go build
   
   # If Makefile exists
   !make
   ```

3. **Post-build Verification**
   - Check for build artifacts
   - Verify error status
   - Report success/failure

## Examples

```
/build
/build --clean
/build --prod
/build --test
```

## Project-specific Configuration

Custom build commands can be specified in `CLAUDE.md` or `PROJECT.md`:

```markdown
## Build Configuration
- Build command: `npm run custom-build`
- Test command: `npm run test:all`
- Production build: `npm run build:prod`
```

## Smart Features

1. **Automatic Dependency Installation**
   - Auto-run `npm install` if `node_modules` is missing
   - Resolve dependencies if `Cargo.lock` is missing

2. **Build Script Detection**
   - Parse package.json scripts section
   - Suggest available build commands

3. **Error Handling**
   - Analyze build errors and suggest solutions
   - Attempt automatic fixes for common issues

## Related Commands

- `/test` - Run tests
- `/lint` - Run linter
- `/dev` - Start development server