#!/bin/bash

# スクリプトを実行可能にするには以下を実行してください:
# chmod +x cleanup_downloads.sh

# ダウンロードフォルダのパス（必要に応じて変更）
DOWNLOAD_DIR="$HOME/ダウンロード"

# フォルダが存在するか確認
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "エラー: ダウンロードフォルダが見つかりません: $DOWNLOAD_DIR" >&2
    exit 1
fi

# 30日より前のファイルを検索してゴミ箱へ移動
find "$DOWNLOAD_DIR" -type f -mtime +30 -print0 | while IFS= read -r -d '' file; do
    if gio trash "$file"; then
        echo "削除済み: $file"
    else
        echo "エラー: $file をゴミ箱に移動できませんでした" >&2
    fi
done