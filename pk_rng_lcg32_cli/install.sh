#!/bin/bash
#
# pk_rng_lcg32 CLI installer for Git Bash / MSYS2
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXE_PATH="$SCRIPT_DIR/_build/native/debug/build/pk_rng_lcg32_cli.exe"
BIN_DIR="$HOME/bin"
DEST_PATH="$BIN_DIR/lcg32.exe"

if [[ ! -f "$EXE_PATH" ]]; then
    echo "Error: 実行ファイルが見つかりません: $EXE_PATH" >&2
    echo "先に 'moon build' を実行してください。" >&2
    exit 1
fi

if [[ ! -d "$BIN_DIR" ]]; then
    echo "Creating $BIN_DIR ..."
    mkdir -p "$BIN_DIR"
fi

echo "Copying executable to $DEST_PATH ..."
cp "$EXE_PATH" "$DEST_PATH"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo "NOTE: $BIN_DIR is not in your PATH."
    echo "Add the following line to your ~/.bashrc or ~/.bash_profile:"
    echo ""
    echo "  export PATH=\"\$HOME/bin:\$PATH\""
    echo ""
fi

echo ""
echo "Installation complete!"
echo "Command: lcg32"
